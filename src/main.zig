const std = @import("std");
const posix = std.posix;
const SIG = posix.SIG;
const time = std.time;
const root = @import("sql_cli");
const pager = @import("pager.zig");

const Allocator = std.mem.Allocator;
const Io = std.Io;


const StartupParams = struct {
    driver: ?[]const u8,
    pager: ?pager.PagerType,
    winsize: ?posix.winsize,
    errors: ?*root.errors.ErrorSingleton
};


/// Print startup information
fn startupMessage(writer: *Io.Writer, parms: StartupParams) !void {

    try writer.print("Squint {s} | ADBC CLI\n"
        ++ "Type \".help\" for dotcommands. "
        ++ "Type \".exit\" or ^D to quit.\n", .{root.VERSION});

    if (parms.driver) |d| {
        try writer.print("Driver \"{s}\"\n", .{d});
    }

    if (parms.pager) |p| {
        try writer.print("Pager \"{s}\"\n", .{@tagName(p)});
    }

    // TODO URI string or connection params?

    if (parms.winsize) |w| {
        try writer.print("Output window {d} x {d}\n", .{w.row, w.col});
    }

    // If we encountered any non-fatal errors during startup, print them
    // all now.
    if (parms.errors != null) {
        const n_err = parms.errors.?.numErrs();

        if (n_err > 0) {
            try writer.print("\n{s}Startup Errors ({d}):\n", .{root.format.RED, n_err});
            try parms.errors.?.printAllErrs(writer);
            try writer.print("{s}", .{root.format.RESET});
        }
    }

}

/// Get the output handle window size
fn windowSize(handle: Io.File.Handle, errs: *root.errors.ErrorSingleton) posix.winsize {
    var winsize: posix.winsize = .{
        .row = 0,
        .col = 0,
        .xpixel = 0,
        .ypixel = 0
    };

    const err = posix.system.ioctl(handle, posix.T.IOCGWINSZ, @intFromPtr(&winsize));

    if (posix.errno(err) != .SUCCESS) {
        errs.addErr("Ioctl winsize unknown.");
    }

    return winsize;
}

/// REPL loop
pub fn main(init: std.process.Init) !void {
    const gpa = init.gpa;

    var threaded: Io.Threaded = .init(gpa, .{.environ = init.minimal.environ});
    defer threaded.deinit();

    const io = threaded.io();

    var errs: root.errors.ErrorSingleton = try .init(gpa, 16);
    defer errs.deinit(gpa);

    var argp: root.cli.SimpleArgParser = .{};
    defer argp.vargs.deinit(gpa);

    argp.parse(gpa, init.minimal.args) catch |err| {
        switch (err) {
            error.UnsupportedDriverError => {
                root.cli.help();

                return error.FatalStartupError;
            },
            else => errs.addErr("Unexpected argument parsing error.")
        }
    };

    const arg_driver: []const u8 = argp.vargs.get("driver") orelse "sqlite";
    const arg_uri: []const u8 = argp.vargs.get("uri") orelse ":memory:";

    var cfg: root.config.Config = undefined;
    if (argp.vargs.get("profile")) |profile| {
        // Use arena allocator for profile config parsing
        cfg = try root.config.readProfile(io,
            init.arena.child_allocator,
            init.environ_map,
            arg_driver,
            profile);
    } else {
        cfg = try root.config.simpleConfig(arg_driver, arg_uri);
    }

    var stderr = Io.File.stderr();
    var stderrw = stderr.writer(io, &.{});

    // TODO:
    //  We can use window size information to apply some formatting rules to
    //  the output. But this is not currently something we do anything with.
    const winsize = windowSize(Io.File.stdout().handle, &errs);

    const page_exec = pager.whichPager(io, init.environ_map);

    // Set a signal handler for SIGINT received while in readline mode. This
    // will capture the signal and handle it in a different way instead of
    // exiting. Instead ctrl-d will exit the repl.
    //posix.sigaction(
    //    SIG.INT,
    //    &posix.Sigaction {
    //        .handler = .{ .handler = root.rlSigIntHandler },
    //        .mask = std.mem.zeroes(posix.sigset_t),
    //        .flags = 0
    //    },
    //    null);

    var conn: root.db.ConnManager = root.db.ConnManager.init();
    defer _ = conn.deinit() catch {};

    root.db.connectDriver(gpa, &conn, cfg) catch {
        errs.addErr(conn.lastErrMsg());
    };

    try startupMessage(&stderrw.interface, .{
        .driver = arg_driver,
        .pager = page_exec,
        .winsize = winsize,
        .errors = &errs
    });

    // If we encountered a fatal error during startup, just abort from here
    if (errs.fatal) {
        return error.FatalStartupError;
    }

    while (true) {
        const query = root.rlReadline("> ");

        // A Null value here indicates a ctrl-c or ctrl-d keypress. If ctrl-c,
        // then reset and continue. Otherwise exit the main loop.
        if (query == null) {
            if (std.c.errno(-1) == std.c.E.AGAIN) {
                continue;
            } else {
                break;
            }
        }

        // If the user entered a blank string, do not continue.
        if (std.mem.len(query) == 0) {
            continue;
        }

        _ = root.rlAddHistory(query);

        // Dot commands are meta commands for interacting with the session.
        if (query[0] == '.') {
            root.dotCommand(std.mem.span(query), .{
                .errors = &errs,
                .conn = &conn,
                .writer = &stderrw.interface
            }) catch {
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

        //var res = try root.stream.ArrowStreamBuffer.initRows(gpa, 100_000); // prod: 1024
        var res = try root.stream.ArrowStreamBuffer.initBuffers(gpa, 64);
        defer res.deinit(gpa);

        root.stream.readStream(gpa, &strm, &res) catch |err| {
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

        perf.load = perf.lap(io);

        res.metadata = try root.stream.calcColumnMetadata(io, gpa, &res);
        perf.rows = res.countRows();
        perf.bufsz = root.format.calcResultBufSize(res.metadata.?, perf.rows);

        perf.proc = perf.lap(io);

        var prntbuf = try gpa.alloc(u8, perf.bufsz);
        defer gpa.free(prntbuf);

        // Write the ArrowStream result set to the allocated print buffer. By
        // calculating the required buffer size ahead of time, instead of
        // dynamically allocating to build the string at print time, we save
        // a substantial amount of time rendering.
        try root.format.printStreamBuffer(&prntbuf, &res);

        perf.rend = perf.lap(io);

        try pager.page(io, page_exec, prntbuf);

        // Diagnostics
        root.format.printPerfData(gpa, perf);

        if (strm.release) |release| release(&strm);
        try root.db.releaseStatement(&conn, &stmt);

        std.c.free(query);
    }
}
