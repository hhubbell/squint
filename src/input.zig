const std = @import("std");
const c = @import("c");

const errors = @import("errors.zig");
const db = @import("db.zig");

const Allocator = std.mem.Allocator;
const Io = std.Io;
const TokenIter = std.mem.SplitIterator(u8, .scalar);

const Completions = c.linenoiseCompletions;

pub const readline = c.linenoise;
pub const addHistory = c.linenoiseHistoryAdd;
pub const setCompletionCallback = c.linenoiseSetCompletionCallback;

pub const DotCommandOptions = struct {
    errors: *errors.ErrorSingleton,
    conn: *db.ConnManager,
    writer: *Io.Writer
};

const DotCommand = struct {
    help: []const u8,
    call: *const fn (args: *TokenIter, opts: DotCommandOptions) anyerror!void
};

const DotCommandMap = std.StaticStringMap(DotCommand).initComptime(.{
    .{ "errors", DotCommand {
        .help = "Print logged error messages",
        .call = dcErrors }},
    .{ "exit", DotCommand {
        .help = "Exit the program",
        .call = dcExit }},
    .{ "help", DotCommand {
        .help = "Print this friendly help message",
        .call = dcHelp }},
    .{ "limit", DotCommand {
        .help = "Set a result set limit",
        .call = dcLimit }},
    .{ "nolimit", DotCommand {
        .help = "Return result sets unlimited",
        .call = dcNoLimit }},
    //"save": .{ .call = dcSave },
    //"source": .{ .call = dcSource }
});


/// Handle dotcommands such as .help or .exit
pub fn dotCommand(cmd: []const u8, opts: DotCommandOptions) !void {
    var iter = std.mem.splitScalar(u8, cmd[1..], ' ');
    const dotc = DotCommandMap.get(iter.first()) orelse {
        opts.errors.addErr("Invalid dot command.");
        return error.DotCommandError;
    };

    return try dotc.call(&iter, opts);
}

fn dcErrors(args: *TokenIter, opts: DotCommandOptions) !void {
    _ = args;
    try opts.errors.printAllErrs(opts.writer);
}

fn dcExit(args: *TokenIter, opts: DotCommandOptions) !void {
    _ = args;
    _ = opts;

    std.process.exit(0);
}

fn dcHelp(args: *TokenIter, opts: DotCommandOptions) !void {
    _ = args;

    const keys = comptime DotCommandMap.keys();
    var kcopy: [keys.len][]const u8 = undefined;

    @memcpy(&kcopy, keys);

    std.mem.sort([] const u8, &kcopy, {}, struct {
        fn lessThan(_: void, lhs: []const u8, rhs: []const u8) bool {
            return std.mem.order(u8, lhs, rhs) == .lt;
        }
    }.lessThan);

    for (kcopy) |k| {
        const v = DotCommandMap.get(k) orelse unreachable;

        try opts.writer.print(".{[key]s:<[kwid]} : {[val]s}\n", .{
            .key = k,
            .kwid = DotCommandMap.max_len,
            .val = v.help
        });
    }

    try opts.writer.print("\n", .{});
}

fn dcLimit(args: *TokenIter, opts: DotCommandOptions) !void {
    const cur: ?u64 = opts.conn.row_limit;
    const new: ?[]const u8 = args.next();

    if (new == null) {
        if (cur == null) {
            try opts.writer.print("Unlimited\n", .{});
        } else {
            try opts.writer.print("{d}\n", .{cur.?});
        }

        return;
    }

    opts.conn.row_limit = std.fmt.parseInt(u64, new.?, 10) catch {
        opts.errors.addErr("Invalid limit.");
        return error.DotCommandError;
    };
}

fn dcNoLimit(args: *TokenIter, opts: DotCommandOptions) !void {
    _ = args;
    opts.conn.row_limit = null;
}

/// Register SQL keyword completions
///
/// Requires but hides allocation, due to function signature requirements.
pub fn sqlCompletionCallback(buf: [*c]const u8, compl: [*c]Completions) callconv(.c) void {
    const gpa: Allocator = std.heap.c_allocator;

    //var ctx: std.ArrayList([]const u8) = .empty;
    //defer ctx.deinit(gpa);
    //defer for (ctx.items) |i| gpa.free(i);

    //var iter = std.mem.splitScalar(u8, std.mem.span(buf), ' ');
    //var word = iter.first();

    //while (iter.next()) |term| {
    //    ctx.append(gpa, word) catch return;
    //    word = term;
    //}

    //const preamble = std.mem.join(gpa, " ", ctx.items) catch return;
    //defer gpa.free(preamble);

    const idx: ?usize = std.mem.findScalarLast(u8, std.mem.span(buf), ' ');

    var preamble: []const u8 = undefined;
    var letter: u8 = undefined;

    if (idx != null) {
        preamble = buf[0..idx.? + 1];
        letter = buf[idx.? + 1];
    } else {
        preamble = "";
        letter = buf[0];
    }

    if (letter == 's') {
        const req: [:0]const u8 = std.mem.concatWithSentinel(gpa,
            u8,
            &.{
                preamble,
                "select"
            },
            '\x00'
        ) catch return;
        defer gpa.free(req);
        c.linenoiseAddCompletion(compl, @ptrCast(req));
    }
}
