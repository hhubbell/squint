const std = @import("std");
const config = @import("config");

const cli = @import("cli.zig");
const db = @import("db.zig");
const errors = @import("errors.zig");
const format = @import("format.zig");
const input = @import("input.zig");
const stream = @import("stream.zig");
const pager = @import("pager.zig");
const perfd = @import("perf.zig");

// Library version - is there a better way to do this?
const VERSION = "0.0.0";

const Allocator = std.mem.Allocator;
const Io = std.Io;
const posix = std.posix;


const StartupParams = struct {
    driver: ?[]const u8,
    pager: ?pager.PagerType,
    winsize: ?posix.winsize,
    errors: ?*errors.ErrorSingleton
};


/// Print startup information
fn startupMessage(writer: *Io.Writer, parms: StartupParams) !void {

    try writer.print("Squint {s} | ADBC CLI\n"
        ++ "Type \".help\" for dotcommands. "
        ++ "Type \".exit\" or ^D to quit.\n", .{VERSION});

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
            try writer.print("\n{s}Startup Errors ({d}):\n", .{format.RED, n_err});
            try parms.errors.?.printAllErrs(writer);
            try writer.print("{s}", .{format.RESET});
        }
    }

}

/// Get the output handle window size
fn windowSize(handle: Io.File.Handle, errs: *errors.ErrorSingleton) posix.winsize {
    var winsize: posix.winsize = .{
        .row = 0,
        .col = 0,
        .xpixel = 0,
        .ypixel = 0
    };

    const err = posix.system.ioctl(
        handle,
        posix.T.IOCGWINSZ,
        @intFromPtr(&winsize));

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

    var errs: errors.ErrorSingleton = try .init(gpa, 16);
    defer errs.deinit(gpa);

    var argp: cli.SimpleArgParser = .{};
    defer argp.vargs.deinit(gpa);

    argp.parse(gpa, init.minimal.args) catch |err| {
        switch (err) {
            error.UnsupportedDriverError => {
                cli.help();

                return error.FatalStartupError;
            },
            else => errs.addErr("Unexpected argument parsing error.")
        }
    };

    const arg_driver: []const u8 = argp.vargs.get("driver") orelse "sqlite";
    const arg_uri: []const u8 = argp.vargs.get("uri") orelse ":memory:";

    var cfg: config.Config = undefined;
    if (argp.vargs.get("profile")) |profile| {
        // Use arena allocator for profile config parsing
        cfg = try config.readProfile(io,
            init.arena.child_allocator,
            init.environ_map,
            arg_driver,
            profile);
    } else {
        cfg = try config.simpleConfig(arg_driver, arg_uri);
    }

    var stderr = Io.File.stderr();
    var stderrw = stderr.writer(io, &.{});

    // TODO:
    //  We can use window size information to apply some formatting rules to
    //  the output. But this is not currently something we do anything with.
    const winsize = windowSize(Io.File.stdout().handle, &errs);

    const page_exec = pager.whichPager(io, init.environ_map);

    var conn: db.ConnManager = .init();
    defer _ = conn.deinit() catch {};

    db.connectDriver(gpa, &conn, cfg) catch {
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
        const query = input.readline("> ");

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

        _ = input.addHistory(query);

        // Dot commands are meta commands for interacting with the session.
        if (query[0] == '.') {
            input.dotCommand(std.mem.span(query), .{
                .errors = &errs,
                .conn = &conn,
                .writer = &stderrw.interface
            }) catch {
                try errs.printLastErr(&stderrw.interface);
            };

            continue;
        }

        // Basic performance monitoring
        var perf: perfd.PerfData = .init(io);

        var stmt = db.prepareStatement(&conn, std.mem.span(query)) catch {
            errs.addErr(conn.lastErrMsg());
            try errs.printLastErr(&stderrw.interface);
            continue;
        };

        perf.prep = perf.lap(io);

        var strm = db.executeStatementWithCancel(io, &conn, &stmt) catch |err| {
            switch (err) {
                error.Canceled => errs.addErr("Execution canceled."),
                else => errs.addErr(conn.lastErrMsg())
            }
            try errs.printLastErr(&stderrw.interface);
            continue;
        };

        perf.exec = perf.lap(io);

        // FIXME: This is just a basic implementation to test that the behavior
        // is roughly working. We should rename these initializers, and perhaps
        // move the initializer to a vtable-ish think on another struct, i.e.
        // the ConnManager.
        // Due to the behavior of the ArrowArray stream, any limit the user has
        // set is actually rounded up to multiple of 1024. Because the limit is
        // applied on the client side and not server side, this really doesn't
        // have a noticeable impact on performance. It's more so a quality of
        // life behavior to avoid accidentally dumping millions of rows to the
        // user's stdout.
        var res: stream.ArrowStreamBuffer = undefined;
        if (conn.row_limit == null) {
            // Unlimited with 64 initial buffers (65,536 row initial cap)
            res = try stream.ArrowStreamBuffer.initBuffers(gpa, 64);
        } else {
            // Fixed limit bufers based on user-defined input
            res = try .initRows(gpa, conn.row_limit.?);
        }
        defer res.deinit(gpa);

        stream.readStream(gpa, &strm, &res) catch |err| {
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

        res.metadata = try stream.calcColumnMetadata(io, gpa, &res);
        perf.rows = res.countRows();
        perf.bufsz = format.calcResultBufSize(res.metadata.?, perf.rows);

        perf.proc = perf.lap(io);

        var prntbuf = try gpa.alloc(u8, perf.bufsz);
        defer gpa.free(prntbuf);

        // Write the ArrowStream result set to the allocated print buffer. By
        // calculating the required buffer size ahead of time, instead of
        // dynamically allocating to build the string at print time, we save
        // a substantial amount of time rendering.
        try format.printStreamBuffer(&prntbuf, &res);

        perf.rend = perf.lap(io);

        try pager.page(io, page_exec, prntbuf);

        // Diagnostics
        format.printPerfData(gpa, perf);

        if (strm.release) |release| release(&strm);
        try db.releaseStatement(&conn, &stmt);

        std.c.free(query);
    }
}
