const std = @import("std");
const adbc = @import("adbc");
const c = @import("c");

const cli = @import("cli.zig");
const mesg = @import("message.zig");
const format = @import("format.zig");
const input = @import("input.zig");
const pager = @import("pager.zig");
const perfd = @import("perf.zig");

const version = @import("build_options").version;

const Allocator = std.mem.Allocator;
const Io = std.Io;
const posix = std.posix;


const StartupParams = struct {
    config: ?adbc.AdbcConfig,
    pager: ?pager.PagerType,
    winsize: ?posix.winsize,
    mesg: ?*mesg.MessageBuffer
};

/// Print startup information
fn startupMessage(writer: *Io.Writer, parms: StartupParams) !void {

    try writer.print("Squint {f} | ADBC CLI\n"
        ++ "Type \".help\" for dotcommands. "
        ++ "Type \".exit\" or ^D to quit.\n", .{version});

    if (parms.config) |x| {
        if (x.driver) |d| {
            try writer.print("Driver \"{s}\"", .{d});

            if (x.uri) |u| {
                try writer.print(" | Uri \"{s}\"", .{u});
            }

            try writer.print("\n", .{});
        } else {
            try writer.print("Profile \"{s}\"\n", .{x.profile.?});
        }
    }

    if (parms.pager) |x| {
        try writer.print("Pager \"{s}\"\n", .{@tagName(x)});
    }

    // TODO URI string or connection params?

    if (parms.winsize) |x| {
        try writer.print("Output window {d} x {d}\n", .{x.row, x.col});
    }

    // If we encountered any non-fatal errors during startup, print them
    // all now.
    if (parms.mesg != null) {
        const n_err = parms.mesg.?.numErrs();

        if (n_err > 0) {
            try writer.print("\n{s}Startup Errors ({d}):\n", .{format.RED, n_err});
            try parms.mesg.?.printAllErrs(writer);
            try writer.print("{s}", .{format.RESET});
        }
    }

}

/// Get the output handle window size
fn windowSize(handle: Io.File.Handle, msg: *mesg.MessageBuffer) posix.winsize {
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
        msg.addErr("Ioctl winsize unknown.");
    }

    return winsize;
}

/// REPL loop
pub fn main(init: std.process.Init) !void {
    const gpa = init.gpa;

    var threaded: Io.Threaded = .init(gpa, .{.environ = init.minimal.environ});
    defer threaded.deinit();

    const io = threaded.io();

    var msg: mesg.MessageBuffer = try .init(gpa, 16);
    defer msg.deinit(gpa);

    var argp: cli.SimpleArgParser = .{};
    defer argp.vargs.deinit(gpa);

    argp.parse(gpa, init.minimal.args) catch {
        msg.addErr("Unexpected argument parsing error.");
    };

    const cfg: adbc.AdbcConfig = .init(
        argp.vargs.get("profile"),
        argp.vargs.get("driver"),
        argp.vargs.get("uri"));

    var stderr = Io.File.stderr().writer(io, &.{});

    // TODO:
    //  We can use window size information to apply some formatting rules to
    //  the output. But this is not currently something we do anything with.
    const winsize = windowSize(Io.File.stdout().handle, &msg);

    const page_exec = pager.whichPager(io, init.environ_map);

    var conn: adbc.ConnectionIo = .init();
    adbc.connect(gpa, &conn, cfg) catch {
        msg.addFatalErr(conn.lastErrMsg());
    };
    defer _ = conn.deinit() catch {};

    try startupMessage(&stderr.interface, .{
        .config = cfg,
        .pager = page_exec,
        .winsize = winsize,
        .mesg = &msg
    });

    // If we encountered a fatal error during startup, just abort from here
    if (msg.numFatal() > 0) {
        return error.FatalStartupError;
    }

    // Refresh the connection catalog asyncronously. This information is useful
    // for completion, but it's ok if it's not ready by the time we get to the
    // prompt. Spinning this off reduces the time to prompt, especially for
    // connections with large catalogs, or which take a while to yield a result.
    var catalog_fut = io.async(adbc.ConnectionCatalog.refresh, .{&input.catalog, gpa, &conn});
    defer input.catalog.deinit(gpa);
    defer catalog_fut.cancel(io) catch {};

    input.setMultiLine(1);
    input.setCompletionCallback(input.completionCallback);

    input.active_query = try .init(gpa, 2);
    defer input.active_query.deinit(gpa);

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
    // TODO: To support .save we are breaking row limits. This API needs
    // some work anyway so it's fine.
    var res: adbc.ArrowStreamBuffer = try .initRows(gpa, conn.row_limit.?);
    defer res.deinit(gpa);

    var prompt: [*c]u8 = @constCast("> \x00");

    while (true) {
        const query: [*c]u8 = input.readline(prompt);
        defer std.c.free(query);

        switch (input.inputType(query)) {
            .blank,
            .canceled => {
                prompt = @constCast("> \x00");
                input.active_query.clear(gpa);
                continue;
            },
            .continued => {
                prompt = @constCast(". \x00");
                try input.active_query.add(gpa, std.mem.span(query));
                continue;
            },
            .dot => {
                _ = input.addHistory(query);
                input.dotCommand(std.mem.span(query), .{
                    .msg = &msg,
                    .conn = &conn,
                    .gpa = gpa,
                    .io = io,
                    .pager = page_exec
                }) catch {
                    try msg.printLastErr(&stderr.interface);
                };

                continue;
            },
            .execute => {
                prompt = @constCast("> \x00");
                try input.active_query.add(gpa, std.mem.span(query));
            },
            .exit => break
        }

        const qstr: [:0]const u8 = try input.active_query.asStringZ(gpa);
        defer gpa.free(qstr);

        input.active_query.clear(gpa);

        _ = input.addHistory(qstr);

        // Basic performance monitoring
        var perf: perfd.PerfData = .init(io);

        // FIXME: Move this lifecycle management to adbc module directly
        var stmt: c.AdbcStatement = adbc.prepareStatement(&conn, qstr) catch {
            msg.addErr(conn.lastErrMsg());
            try msg.printLastErr(&stderr.interface);
            continue;
        };
        defer adbc.err.checkAdbc(c.AdbcStatementRelease(&stmt, conn.errPtr()))
            catch @panic("Failed to release statement.");

        var strm: c.ArrowArrayStream = adbc.executeWithCancel(io, &conn, &stmt) catch |err| {
            switch (err) {
                error.Canceled => msg.addErr("Execution canceled."),
                else => msg.addErr(conn.lastErrMsg())
            }
            try msg.printLastErr(&stderr.interface);
            continue;
        };
        defer if (strm.release) |release| release(&strm);

        perf.exec = perf.lap(io);

        // Clear the prior result set, which was retained for .save and maybe
        // other dotcommands
        res.clear(gpa);

        adbc.readStream(gpa, &strm, &res) catch |err| {
            switch (err) {
                error.ArrowStreamError => {
                    if (strm.get_last_error) |cb| {
                        const err_msg: [*c]const u8 = cb(&strm);

                        if (err_msg != null) {
                            msg.addErr(std.mem.span(err_msg));
                        }
                    }
                },
                error.NanoArrowError => msg.addErr(&res.err.message),
                error.AdbcLibError => msg.addErr("ADBC Library Error."),
                else => msg.addErr("Uncaught Error.")
            }

            try msg.printLastErr(&stderr.interface);
            continue;
        };

        conn.last_result = &res;

        perf.load = perf.lap(io);

        res.metadata = try adbc.calcColumnMetadata(io, gpa, &res);
        perf.rows = res.countRows();

        const bufsz = format.calcResultBufSize(res.metadata.?, perf.rows);

        perf.proc = perf.lap(io);

        var prntbuf = try gpa.alloc(u8, bufsz);
        defer gpa.free(prntbuf);

        // Write the ArrowStream result set to the allocated print buffer. By
        // calculating the required buffer size ahead of time, instead of
        // dynamically allocating to build the string at print time, we save
        // a substantial amount of time rendering.
        try format.printStreamBuffer(&prntbuf, &res);

        perf.rend = perf.lap(io);

        // FIXME: We should do this selectively. E.g. only update the catalog
        // cache IF the statement type was something that would have changed
        // the catalog, such as changing the current database or schema, or
        // creating an object.
        // Also how to make sure this gets cleaned up without slowing down the
        // next prompt?
        //_ = io.async(adbc.ConnectionCatalog.refresh, .{&input.catalog, gpa, &conn});
        //defer ref_fut.cancel(io) catch {};

        try pager.page(io, page_exec, prntbuf);

        // Diagnostics
        try stderr.interface.print("{f}\n", .{ perf });
    }
}

test {
    std.testing.refAllDecls(@This());
}
