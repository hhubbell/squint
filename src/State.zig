const std = @import("std");
const adbc = @import("adbc");

const cli = @import("cli.zig");
const editor = @import("editor.zig");
const input = @import("input.zig");
const mesg = @import("message.zig");
const pager = @import("pager.zig");
const render = @import("render/root.zig");

const version = @import("build_options").version;

const ConnectionIo = @import("ConnectionIo.zig");
const Color = @import("render/Color.zig");

const Allocator = std.mem.Allocator;
const Environ = std.process.Environ;
const Io = std.Io;
const posix = std.posix;

const Mode = enum { interactive, quit };

const StartupParams = struct {
    config: ?adbc.AdbcConfig,
    mesg: ?*mesg.MessageBuffer
};

const Self = @This();

conn: ConnectionIo,
edit: ?[]const u8,
page: pager.PagerType,
winsize: posix.winsize,
tbl_writer: render.WriterType,
mode: Mode,

/// Initialize the application state from cli arguments. Conduct all necessary
/// initializations to return a functioning application state. For example,
/// set the connection and handle any initialization failures.
pub fn init(
    io: Io,
    gpa: Allocator,
    msg: *mesg.MessageBuffer,
    pinit: std.process.Init
) !Self {
    var argp: cli.SimpleArgParser = .{};
    defer argp.vargs.deinit(gpa);

    argp.parse(gpa, pinit.minimal.args) catch {
        msg.addErr("Unexpected argument parsing error.", .{});
    };

    const cfg: adbc.AdbcConfig = .init(
        argp.get("profile"),
        argp.get("driver"),
        argp.get("uri"));

    // TODO:
    // We can use window size information to apply some formatting rules to
    // the output. But this is not currently something we do anything with.
    const winsize = windowSize(Io.File.stdout().handle, msg);

    const edit_exec: ?[]const u8 = editor.whichEditor(io, pinit.environ_map);
    const page_exec: pager.PagerType = selectPager(io, argp.get("pager"), pinit.environ_map);

    var conn: ConnectionIo = try .init(io, gpa);
    conn.connect(gpa, cfg) catch {
        msg.addFatalErr("{s}", .{conn.lastErrMsg()});
        _ = conn.deinit(gpa) catch {};
        return error.FatalStartupError;
    };
    errdefer _ = conn.deinit(gpa) catch {};

    var state: Self = .{
        .conn = conn,
        .edit = edit_exec,
        .page = page_exec,
        .winsize = winsize,
        .tbl_writer = .table,
        .mode = .interactive
    };

    if (argp.get("exec")) |cmd| {
        const cmdz = try gpa.dupeSentinel(u8, cmd, 0);
        defer gpa.free(cmdz);

        try input.execStatements(io, gpa, &state, msg, cmdz);

        if (argp.get("interactive") == null) {
            state.mode = .quit;
            return state;
        }
    }

    if (argp.get("source")) |path| {
        try input.sourceFile(io, gpa, &state, msg, path);

        if (argp.get("interactive") == null) {
            state.mode = .quit;
            return state;
        }
    }

    var buffer: [4096]u8 = undefined;
    var stderr: Io.File.Writer = Io.File.stderr().writer(io, &buffer);

    try state.startupMessage(&stderr.interface, .{
        .config = cfg,
        .mesg = msg
    });

    // If we encountered a fatal error during startup, just abort from here
    if (msg.numFatal() > 0) {
        return error.FatalStartupError;
    }

    return state;
}

/// Cleanup stateful assets: database connection, catalog futures, etc.
pub fn deinit(self: *Self, gpa: Allocator) void {
    _ = self.conn.deinit(gpa) catch {};
}

/// Print startup information
fn startupMessage(self: Self, writer: *Io.Writer, data: StartupParams) !void {
    try writer.print("Squint {f} | ADBC CLI\n"
        ++ "Type \".help\" for dotcommands. "
        ++ "Type \".exit\" or ^D to quit.\n", .{version});

    if (data.config) |x| {
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

    try writer.print("Pager \"{s}\"\n", .{@tagName(self.page)});

    try writer.print("Editor ", .{});
    if (self.edit) |x| {
        try writer.print("\"{s}\"\n", .{x});
    } else {
        try writer.print("unavailable\n", .{});
    }

    // TODO URI string or connection params?

    try writer.print("Output window {d} x {d}\n", .{
        self.winsize.row,
        self.winsize.col
    });

    // If we encountered any non-fatal errors, print them all now
    if (data.mesg) |x| {
        const n_err = x.numErrs();

        if (n_err > 0) {
            try writer.print("\n{s}Startup Errors ({d}):\n", .{Color.Red, n_err});
            try x.printAllErrs(writer);
            try writer.print("{s}", .{Color.Reset});
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

/// Get an appropriate pager given an optionally provided CLI arg
fn selectPager(io: Io, arg: ?[]const u8, env: *Environ.Map) pager.PagerType {
    if (arg == null) {
        return pager.whichPager(io, env);
    }

    return pager.fromString(arg.?) catch pager.whichPager(io, env);
}
