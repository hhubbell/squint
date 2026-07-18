const std = @import("std");
const c = @import("c");

const errors = @import("errors.zig");
const db = @import("db.zig");

const Allocator = std.mem.Allocator;
const Io = std.Io;
const TokenIter = std.mem.SplitIterator(u8, .scalar);

const assert = std.debug.assert;

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
    .{ ".errors", DotCommand {
        .help = "Print logged error messages",
        .call = dcErrors }},
    .{ ".exit", DotCommand {
        .help = "Exit the program",
        .call = dcExit }},
    .{ ".help", DotCommand {
        .help = "Print this friendly help message",
        .call = dcHelp }},
    .{ ".limit", DotCommand {
        .help = "Set a result set limit",
        .call = dcLimit }},
    .{ ".nolimit", DotCommand {
        .help = "Return result sets unlimited",
        .call = dcNoLimit }},
    //"save": .{ .call = dcSave },
    //"source": .{ .call = dcSource }
});


/// Handle dotcommands such as .help or .exit
pub fn dotCommand(cmd: []const u8, opts: DotCommandOptions) !void {
    var iter = std.mem.splitScalar(u8, cmd, ' ');
    const dotc = DotCommandMap.get(iter.first()) orelse {
        opts.errors.addErr("Invalid dot command.");
        return error.DotCommandError;
    };

    return try dotc.call(&iter, opts);
}

fn iterDotCommands() [DotCommandMap.keys().len][]const u8 {
    const keys = comptime DotCommandMap.keys();
    var kcopy: [keys.len][]const u8 = undefined;

    @memcpy(&kcopy, keys);

    std.mem.sort([] const u8, &kcopy, {}, struct {
        fn lessThan(_: void, lhs: []const u8, rhs: []const u8) bool {
            return std.mem.order(u8, lhs, rhs) == .lt;
        }
    }.lessThan);

    return kcopy;
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

    for (iterDotCommands()) |k| {
        const v = DotCommandMap.get(k) orelse unreachable;

        try opts.writer.print("{[key]s:<[kwid]} : {[val]s}\n", .{
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


const StatementType = enum {
    alter, create, delete, drop, insert, select, truncate, update, use
};

/// Stores a tuple of strings referring to an input buffer that was split on
/// a space. Both parts can be reconstituted to form the original input buffer.
/// This means that `lhs` may contain a trailing space. When accessing `lhs`,
/// use `strippedLhs()` if the trailing space will cause issues.
const InputSplitTuple = struct {
    const Self = @This();

    lhs: []const u8,
    rhs: []const u8,

    pub fn split(buf: []const u8) Self {
        const idx: usize = std.mem.findScalarLast(u8, buf, ' ') orelse 0;

        if (idx > 0) {
            return .{
                .lhs = buf[0..idx + 1],
                .rhs = buf[idx + 1..]
            };
        }

        return .{
            .lhs = buf[0..idx],
            .rhs = buf[idx..]
        };   
    }

    pub fn hasLhs(self: Self) bool {
        return self.lhs.len > 0;
    }

    pub fn hasRhs(self: Self) bool {
        return self.rhs.len > 0;
    }

    pub fn strippedLhs(self: Self) []const u8 {
        if (self.hasLhs()
            and self.lhs[self.lhs.len - 1] == ' '
        ) {
            return self.lhs[0..self.lhs.len - 1];
        }

        return self.lhs;
    }
};

const InputContext = struct {
    const Self = @This();

    kind: ?StatementType,
    input: InputSplitTuple,
    last_word: ?[]const u8,

    pub fn firstLetter(self: Self) ?u8 {
        if (self.input.hasRhs()) {
            return self.input.rhs[0];
        }

        return null;
    }

};


/// Register keyword completions
///
/// Supported completions:
///     - dotcommands
///     - sql keywords (naive)
///     - database objects (TODO)
///
/// Requires but hides allocation, due to function signature requirements.
pub fn completionCallback(buf: [*c]const u8, compl: [*c]Completions) callconv(.c) void {
    const gpa: Allocator = std.heap.c_allocator;

    const inpt_ctx: InputContext = splitInput(std.mem.span(buf));

    if (inpt_ctx.kind == null) {
        const letter: ?u8 = inpt_ctx.firstLetter();

        // Enumerate dotcommands
        if (letter == '.') {
            const dots = iterDotCommands();
            var indexes: [dots.len]usize = undefined;
            const idx = matchFromPrefix(inpt_ctx.input.rhs, &dots, &indexes);

            for (0..idx) |i| {
                c.linenoiseAddCompletion(compl, @ptrCast(dots[i]));
            }
        } else {
            inline for (std.enums.values(StatementType)) |t| {
                const tag = @tagName(t);

                if (letter == null or letter == tag[0]) {
                    c.linenoiseAddCompletion(compl, @ptrCast(tag));
                }
            }
        }

        return;
    }

    const sugs = completionSuggestions(gpa, inpt_ctx.input.rhs, inpt_ctx) catch return;
    defer gpa.free(sugs);

    for (sugs) |sug| {
        const req: [:0]const u8 = std.mem.concatWithSentinel(gpa,
            u8,
            &.{ inpt_ctx.input.lhs, sug },
            '\x00'
        ) catch return;
        defer gpa.free(req);

        c.linenoiseAddCompletion(compl, @ptrCast(req));
    }
}

/// Provide suggestions based on the strings matching so far. Returns the
/// number of potential matches. Provides the indexes of these matches from
/// the `completions` input slice on the `matches` input slice. 
fn matchFromPrefix(
    term: []const u8,
    completions: []const []const u8,
    matches: []usize
) usize {
    // Both completions and matches must be the same length
    assert(completions.len == matches.len);

    var idx: usize = 0;

    for (completions, 0..) |cmp, i| {
        if (cmp.len < term.len) {
            continue;
        }

        if (std.mem.eql(u8, term, cmp[0..term.len])) {
            matches[idx] = i;
            idx += 1;
        }
    }

    return idx;
}

fn completionSuggestions(
    gpa: Allocator,
    term: []const u8,
    context: InputContext
) ![][]const u8 {
    _ = context;

    const keywords = comptime [_][]const u8 {
        "all",
        "and",
        "as",
        "between",
        "by",
        "case",
        "cast",
        "contains",
        "create",
        "cross",
        "distinct",
        "else",
        "end",
        "except",
        "extract",
        "exists",
        "false",
        "from",
        "full",
        "group",
        "having",
        "ilike",
        "in",
        "inner",
        "intersect",
        "is",
        "join",
        "left",
        "like",
        "limit",
        "minus",
        "not",
        "null",
        "on",
        "or",
        "order",
        "outer",
        "over",
        "partition",
        "qualify",
        "replace",
        "right",
        "select",
        "table",
        "temp",
        "temporary",
        "then",
        "top",
        "true",
        "try_cast",
        "union",
        "use",
        "using",
        "view",
        "when",
        "where",
        "with"
    };

    var indexes: [keywords.len]usize = undefined;
    const idx = matchFromPrefix(term, &keywords, &indexes);

    var sugs = try gpa.alloc([]const u8, idx);

    for (0..idx) |i| {
        sugs[i] = keywords[indexes[i]];
    }

    return sugs;
}

fn statementType(buf: []const u8) ?StatementType {
    var iter = std.mem.splitScalar(u8, buf, ' ');

    return std.meta.stringToEnum(StatementType, iter.first());
}

fn splitInput(buf: []const u8) InputContext {
    const cur_input = InputSplitTuple.split(buf);

    var last_word: ?[]const u8 = null;
    if (cur_input.hasLhs()) {
        const last_input = InputSplitTuple.split(cur_input.strippedLhs());

        if (last_input.hasRhs()) {
            last_word = last_input.rhs;
        }
    }

    return .{
        .kind = statementType(buf),
        .input = cur_input,
        .last_word = last_word
    };
}

