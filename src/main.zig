const std = @import("std");
const adbc = @import("adbc");
const c = @import("c");

const cli = @import("cli.zig");
const format = @import("format.zig");
const input = @import("input.zig");
const mesg = @import("message.zig");
const pager = @import("pager.zig");
const perfd = @import("perf.zig");

const version = @import("build_options").version;

const ConnectionCatalog = @import("ConnectionCatalog.zig");
const ConnectionIo = @import("ConnectionIo.zig");

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

    try writer.flush();
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
        msg.addErr("Ioctl winsize unknown.", .{});
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
        msg.addErr("Unexpected argument parsing error.", .{});
    };

    const cfg: adbc.AdbcConfig = .init(
        argp.vargs.get("profile"),
        argp.vargs.get("driver"),
        argp.vargs.get("uri"));

    var buffer: [4096]u8 = undefined;
    var stderr: Io.File.Writer = Io.File.stderr().writer(io, &buffer);

    // TODO:
    //  We can use window size information to apply some formatting rules to
    //  the output. But this is not currently something we do anything with.
    const winsize = windowSize(Io.File.stdout().handle, &msg);

    const page_exec = pager.whichPager(io, init.environ_map);

    var conn: ConnectionIo = try .init(io, gpa);
    conn.connect(gpa, cfg) catch {
        msg.addFatalErr("{s}", .{conn.lastErrMsg()});
    };
    defer _ = conn.deinit(gpa) catch {};

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
    var catalog_fut = io.async(ConnectionCatalog.refresh, .{&input.catalog, gpa, &conn});
    defer input.catalog.deinit(gpa);
    defer catalog_fut.cancel(io) catch {};

    input.setMultiLine(1);
    input.setCompletionCallback(input.completionCallback);

    input.active_query = try .init(gpa, 2);
    defer input.active_query.deinit(gpa);

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

                // Clear the prior result set, which was retained for .save and
                // maybe other dotcommands
                conn.last_result.clear(gpa);

            },
            .exit => break
        }

        const qstr: [:0]const u8 = try input.active_query.asStringZ(gpa);
        defer gpa.free(qstr);

        _ = input.addHistory(qstr);
        input.active_query.clear(gpa);

        const prntbuf = conn.execute(io, gpa, &msg, qstr) catch {
            try msg.printLastErr(&stderr.interface);
            continue;
        };
        defer gpa.free(prntbuf);

        // FIXME: We should do this selectively. E.g. only update the
        // catalog cache IF the statement type was something that would
        // have changed the catalog, such as changing the current
        // database or schema, or creating an object.
        // Also how to make sure this gets cleaned up without slowing
        // down the next prompt?
        //_ = io.async(ConnectionCatalog.refresh, .{&input.catalog, gpa, &conn});
        //defer ref_fut.cancel(io) catch {};

        try pager.page(io, page_exec, prntbuf);

        // Diagnostics
        try stderr.interface.print("{f}\n", .{ conn.pmon });
        try stderr.interface.flush();
    }
}

test {
    std.testing.refAllDecls(@This());
}
