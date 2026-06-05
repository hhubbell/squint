const std = @import("std");
const Io = std.Io;
const posix = std.posix;
const SIG = posix.SIG;
const time = std.time;

const Allocator = std.mem.Allocator;

pub const cli = @import("cli.zig");
pub const db = @import("db.zig");
pub const errors = @import("errors.zig");
pub const format = @import("format.zig");
pub const stream = @import("stream.zig");
pub const perf = @import("perf.zig");

// Expose required c functions
const c = @import("c");
pub const rlReadline = c.readline;
pub const rlAddHistory = c.add_history;


/// Yikes - dumpster signature
pub fn dotCommand(alloc: Allocator, log: *errors.ErrorSingleton, cmd: []const u8, writer: *std.Io.Writer) !void {

    _ = alloc;

    // Rethink this when we have more commands, e.g. hashmap with
    // some callable or something else.
    // Turns out this is kind of how the zig exe handles cli args
    // so I guess it's not horrible?
    const dotc = cmd[1..];

    if (std.mem.eql(u8, dotc, "errors")) {
        try log.printAllErrs(writer);
    } else if (std.mem.eql(u8, dotc, "save")) {
        log.addErr("Save not yet implemented.");
        return error.DotCommandError;
    } else {
        log.addErr("Invalid dot command.");
        return error.DotCommandError;
    }
}

/// Provide a pager child process for outputs that are larger than the standard
/// output window. Requires dependency `less`.
pub fn lessPipe(io: Io, alloc: Allocator, data: []const u8) !void {
    _ = alloc;

    var child = try std.process.spawn(io, .{
        .argv = &[2][]const u8 {"less", "-FRS"},
        .stdin = .pipe,
        .stdout = .inherit,
        .stderr = .inherit});

    var writer = child.stdin.?.writer(io, &.{});

    // WARNING: 
    //  When we close our pager without reading the full result set, less
    //  will attempt to issue a SIGPIPE which terminates the parent process.
    //  We are ignoring these signals. As a result, incomplete reading of
    //  inputs results in a WriteFailed error due to a broken pipe. In this
    //  case, we are just ignoring the error and returning.
    writer.interface.writeAll(data) catch |err| {
        if (err == error.WriteFailed) {
            child.stdin.?.close(io);
            child.stdin = null;
            _ = try child.wait(io);

            return;
        }

        return err;
    };
    
    child.stdin.?.close(io);

    // NOTE:
    //  Using -F results in a thread panic if the input data is too small
    //  without explicitly doing this action below. I believe this is caused
    //  by the wait function trying to clean up a non-existant fd. Setting
    //  it to null solves this problem.
    child.stdin = null;

    _ = try child.wait(io);
}

/// Set a signal handler specifically for when in readline mode to handle
/// SIGINT signals from users entering ctrl-c. When his happens. Abandon
/// the current input and give a new prompt.
///
/// According to Readline documentation, the default builtin SIGINT handler
/// should have handled cleanup of the input so far, so we do not need to
/// do our own housekeeping.
pub fn rlSigIntHandler(sig: SIG) callconv(.c) void {
    _ = sig;

    _ = c.rl_crlf();
    _ = c.rl_on_new_line();
    c.rl_replace_line("", 0);
    c.rl_redisplay();
}

