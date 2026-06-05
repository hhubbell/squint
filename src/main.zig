const std = @import("std");
const Io = std.Io;
const posix = std.posix;
const SIG = posix.SIG;
const time = std.time;
const root = @import("sql_cli");

const Allocator = std.mem.Allocator;


/// Get the output handle window size
fn windowSize(handle: Io.File.Handle) !posix.winsize {
    _ = handle;
    return .{ .row = 0, .col = 80, .xpixel = 0, .ypixel = 0};

//    var winsize: posix.winsize = .{
//        .row = 0,
//        .col = 0,
//        .xpixel = 0,
//        .ypixel = 0};
//
//    const err = posix.system.ioctl(handle, posix.T.IOCGWINSZ, @intFromPtr(&winsize));
//
//    if (posix.errno(err) != .SUCCESS) {
//        return error.IoctlError;
//    }
//
//    return winsize;
}

/// REPL loop
pub fn main(init: std.process.Init) !void {
    const gpa = init.gpa;

    var threaded: Io.Threaded = .init(gpa, .{.environ = init.minimal.environ});
    defer threaded.deinit();

    const io = threaded.io();

    var errs: root.errors.ErrorSingleton = try .init(gpa, 4);
    defer errs.deinit(gpa);

    var argp: root.cli.SimpleArgParser = .{};
    defer argp.vargs.deinit(gpa);

    // TODO:
    //  What if there was like an API where you could "Parse into" a struct.
    //  The struct would define the allowed arguments and act as the carrier
    //  for the parsed results. Would require some type introspection to
    //  determine allowed values at compile time, which I think is possible?
    try argp.parse(gpa, init.minimal.args);

    const arg_driver: []const u8 = argp.vargs.get("driver") orelse "sqlite";
    const arg_uri: []const u8 = argp.vargs.get("uri") orelse "/home/harry/oil.db";

    var stderr = Io.File.stderr();
    var stderrw = stderr.writer(io, &.{});
    const stdout = Io.File.stdout();
    //var stdoutw = stdout.writer(io, &.{});

    const winsize = windowSize(stdout.handle) catch {
        errs.addErr("Ioctl winsize unknown.");
        try errs.printLastErr(&stderrw.interface);
    };
    _ = winsize;

    // NOTE:
    //  When paging results, we need to disable SIGPIPE if we quit the pager
    //  without consuming the entire result set. This is a similar approach
    //  used in the Postgres cli
    const pg_act = posix.Sigaction {
        .handler = .{ .handler = SIG.IGN },
        .mask = std.mem.zeroes(posix.sigset_t),
        .flags = 0};
    std.posix.sigaction(SIG.PIPE, &pg_act, null);

    // Set a signal handler for SIGINT received while in readline mode. This
    // will capture the signal and handle it in a different way instead of
    // exiting. Instead ctrl-d will exit the repl.
    const rl_act = posix.Sigaction {
        .handler = .{ .handler = root.rlSigIntHandler },
        .mask = std.mem.zeroes(posix.sigset_t),
        .flags = 0};
    std.posix.sigaction(SIG.INT, &rl_act, null);

    var conn: root.db.ConnManager = root.db.ConnManager.init();
    root.db.connectSqlite(&conn, arg_driver, arg_uri) catch |err| {
        switch (err) {
            error.InvalidDriver => errs.addErr("Unsupported driver."),
            else => errs.addErr(conn.lastErrMsg())
        }

        try errs.printLastErr(&stderrw.interface);
        std.process.exit(1);
    };

    while (true) {
        const query = root.rlReadline("> ");
        
        // A Null value here indicates a ctrl-d keypress. Exit the main loop.
        if (query == null) {
            break;
        }

        // If the user entered a blank string, do not continue.
        if (std.mem.len(query) == 0) {
            continue;
        }

        root.rlAddHistory(query);

        // Dot commands are meta commands for interacting with the session.
        if (query[0] == '.') {
            root.dotCommand(gpa, &errs, std.mem.span(query), &stderrw.interface) catch {
                try errs.printLastErr(&stderrw.interface);
            };

            continue;
        }

        // Basic performance monitoring
        var perf: root.perf.PerfData = .init(io);

        var stmt = root.db.prepareStatement(&conn, std.mem.span(query)) catch {
            errs.addErr(conn.lastErrMsg());
            try errs.printLastErr(&stderrw.interface);
            continue;
        };

        perf.prep = perf.lap(io);

        var strm = root.db.executeStatement(&conn, &stmt) catch {
            errs.addErr(conn.lastErrMsg());
            try errs.printLastErr(&stderrw.interface);
            continue;
        };

        perf.exec = perf.lap(io);

        var res = try root.stream.ArrowStreamBuffer.initRows(gpa, 100_000); // prod: 1024
        root.stream.readStream(&conn, &strm, &res) catch |err| {
            switch (err) {
                error.AdbcStreamError => {
                    if (strm.get_last_error) |callable| {
                        const msg: [*c]const u8 = callable(&strm);

                        if (msg != null) {
                            errs.addErr(std.mem.span(msg));
                        }
                    }
                },
                error.AdbcNanoArrowError => errs.addErr(&res.err.message),
                error.AdbcLibError => errs.addErr("ADBC Library Error."),
                else => errs.addErr("Uncaught Error.")
            }

            try errs.printLastErr(&stderrw.interface);
            continue;
        };
        defer res.deinit(gpa);

        res.metadata = try root.stream.calcColumnMetadata(gpa, &res);
        perf.bufsz = root.format.calcResultBufSize(res.metadata.?, res.countRows());

        perf.rows = conn.last_row_count;
        perf.proc = perf.lap(io);

        var prntbuf = try gpa.alloc(u8, perf.bufsz);
        defer gpa.free(prntbuf);

        // Write the ArrowStream result set to the allocated print buffer. By
        // calculating the required buffer size ahead of time, instead of
        // dynamically allocating to build the string at print time, we save
        // a substantial amount of time rendering.
        try root.format.printStreamBuffer(&prntbuf, &res);

        perf.rend = perf.lap(io);

        try root.lessPipe(io, gpa, prntbuf);

        // Diagnostics
        root.format.printPerfData(gpa, perf);

        if (strm.release) |release| release(&strm);
        try root.db.releaseStatement(&conn, &stmt);

        std.c.free(query);
    }
}
