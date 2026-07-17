const std = @import("std");
const c = @import("c");

const errors = @import("errors.zig");
const db = @import("db.zig");

const Io = std.Io;

pub const readline = c.linenoise;
pub const addHistory = c.linenoiseHistoryAdd;


pub const DotCommandOptions = struct {
    errors: *errors.ErrorSingleton,
    conn: *db.ConnManager,
    writer: *Io.Writer
};


/// Handle dotcommands such as .help or .exit
pub fn dotCommand(cmd: []const u8, opts: DotCommandOptions) !void {

    const log = opts.errors;

    // Rethink this when we have more commands, e.g. hashmap with
    // some callable or something else.
    // Turns out this is kind of how the zig exe handles cli args
    // so I guess it's not horrible?
    var iter = std.mem.splitScalar(u8, cmd[1..], ' ');
    const dotc = iter.first();

    if (std.mem.eql(u8, dotc, "errors")) {
        try log.printAllErrs(opts.writer);
    } else if (std.mem.eql(u8, dotc, "exit")) {
        try opts.conn.deinit();
        std.process.exit(0);
    } else if (std.mem.eql(u8, dotc, "limit")) {
        const cur: ?u64 = opts.conn.row_limit;
        const new: ?[]const u8 = iter.next();

        if (new == null) {
            if (cur == null) {
                try opts.writer.print("Unlimited\n", .{});
            } else {
                try opts.writer.print("{d}\n", .{cur.?});
            }

            return;
        }

        opts.conn.row_limit = std.fmt.parseInt(u64, new.?, 10) catch {
            log.addErr("Invalid limit.");
            return error.DotCommandError;
        };
    } else if (std.mem.eql(u8, dotc, "nolimit")) {
        opts.conn.row_limit = null;
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


