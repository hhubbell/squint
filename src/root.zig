const std = @import("std");
const time = std.time;

const Allocator = std.mem.Allocator;
const Io = std.Io;
const SIG = std.posix.SIG;

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

// Library version - is there a better way to do this?
pub const VERSION = "0.0.0";


pub const DotCommandOptions = struct {
    errors: *errors.ErrorSingleton,
    conn: *db.ConnManager,
    writer: ?*Io.Writer,
};


/// Handle dotcommands such as .help or .exit
pub fn dotCommand(cmd: []const u8, opts: DotCommandOptions) !void {

    const log = opts.errors;

    // Rethink this when we have more commands, e.g. hashmap with
    // some callable or something else.
    // Turns out this is kind of how the zig exe handles cli args
    // so I guess it's not horrible?
    const dotc = cmd[1..];

    if (std.mem.eql(u8, dotc, "errors")) {
        try log.printAllErrs(opts.writer.?);
    } else if (std.mem.eql(u8, dotc, "exit")) {
        try opts.conn.deinit();
        std.process.exit(0);
    } else if (std.mem.eql(u8, dotc, "save")) {
        log.addErr("\".save\" not yet implemented.");
        return error.DotCommandError;
    } else if (std.mem.eql(u8, dotc, "source")) {
        log.addErr("\".source\" not yet implemented.");
        return error.DotCommandError;
    } else {
        log.addErr("Invalid dot command.");
        return error.DotCommandError;
    }
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

