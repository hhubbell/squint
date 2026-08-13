const std = @import("std");
const adbc = @import("adbc");
const c = @import("c");

const mesg = @import("message.zig");
const pager = @import("pager.zig");

const ConnectionCatalog = @import("ConnectionCatalog.zig");
const ConnectionIo = @import("ConnectionIo.zig");
const Color = @import("render/Color.zig");
const CsvWriter = @import("render/CsvWriter.zig");
const TableWriter = @import("render/TableWriter.zig");

const Allocator = std.mem.Allocator;
const Dir = std.Io.Dir;
const Io = std.Io;
const TokenIter = std.mem.SplitIterator(u8, .scalar);

const assert = std.debug.assert;

const Completions = c.linenoiseCompletions;

pub const readline = c.linenoise;
pub const addHistory = c.linenoiseHistoryAdd;
pub const setCompletionCallback = c.linenoiseSetCompletionCallback;
pub const setMultiLine = c.linenoiseSetMultiLine;

// FIXME: Is this the right idiom?
pub var active_query: InputQuery = undefined;
pub var catalog: ConnectionCatalog = .empty;

pub const DotCommandOptions = struct {
    msg: *mesg.MessageBuffer,
    conn: *ConnectionIo,
    gpa: Allocator,
    io: Io,
    pager: *pager.PagerType
};

const DotCommand = struct {
    help: []const u8,
    call: *const fn (args: *TokenIter, opts: DotCommandOptions) anyerror!void
};

const DotCommandMap = std.StaticStringMap(DotCommand).initComptime(.{
    .{ ".catalog", DotCommand {
        .help = "List the connection catalogs",
        .call = dcCatalogs }},
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
    .{ ".pager", DotCommand {
        .help = "Change the pager to [less|more|nopager]",
        .call = dcPager }},
    .{ ".save", DotCommand {
        .help = "Write the result set to file",
        .call = dcSave }},
    .{ ".source", DotCommand {
        .help = "Read a file and execute its contents",
        .call = dcSource }}
});


/// Handle dotcommands such as .help or .exit
pub fn dotCommand(cmd: []const u8, opts: DotCommandOptions) !void {
    var iter = std.mem.splitScalar(u8, cmd, ' ');
    const dotc = DotCommandMap.get(iter.first()) orelse {
        opts.msg.addErr("Invalid dot command.", .{});
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

fn dcCatalogs(args: *TokenIter, opts: DotCommandOptions) !void {
    _ = args;
    var buffer: [4096]u8 = undefined;
    var writer = Io.File.stderr().writer(opts.io, &buffer);
    
    for (catalog.catalogs(), 0..) |obj, i| {
        if (i == catalog.current_database) {
            try writer.interface.print("* {s}{s}{s}\n", .{
                Color.Yellow, obj.name, Color.Reset
            });
        } else {
            try writer.interface.print("{s}\n", .{obj.name});
        }
        try writer.interface.flush();
    }
}

fn dcErrors(args: *TokenIter, opts: DotCommandOptions) !void {
    _ = args;
    var buffer: [4096]u8 = undefined;
    var writer = Io.File.stderr().writer(opts.io, &buffer);
    try opts.msg.printAllErrs(&writer.interface);
}

fn dcExit(args: *TokenIter, opts: DotCommandOptions) !void {
    _ = args;
    _ = opts;

    std.process.exit(0);
}

fn dcHelp(args: *TokenIter, opts: DotCommandOptions) !void {
    _ = args;
    var buffer: [4096]u8 = undefined;
    var writer = Io.File.stderr().writer(opts.io, &buffer);

    for (iterDotCommands()) |k| {
        const v = DotCommandMap.get(k) orelse unreachable;

        try writer.interface.print("{[key]s:<[kwid]} : {[val]s}\n", .{
            .key = k,
            .kwid = DotCommandMap.max_len,
            .val = v.help
        });
    }

    try writer.interface.print("\n", .{});
    try writer.interface.flush();
}

fn dcLimit(args: *TokenIter, opts: DotCommandOptions) !void {
    const cur: ?u64 = opts.conn.row_limit;
    const new: ?[]const u8 = args.next();
    var buffer: [4096]u8 = undefined;
    var writer = Io.File.stderr().writer(opts.io, &buffer);

    if (new == null) {
        if (cur == null) {
            try writer.interface.print("Unlimited\n", .{});
        } else {
            try writer.interface.print("{d}\n", .{cur.?});
        }
        try writer.interface.flush();

        return;
    }

    opts.conn.row_limit = std.fmt.parseInt(u64, new.?, 10) catch {
        opts.msg.addErr("Invalid limit.", .{});
        return error.DotCommandError;
    };
}

fn dcNoLimit(args: *TokenIter, opts: DotCommandOptions) !void {
    _ = args;
    opts.conn.row_limit = null;
}

fn dcPager(args: *TokenIter, opts: DotCommandOptions) !void {
    const page: ?[]const u8 = args.next();

    if (page == null) {
        opts.msg.addErr("Invalid .pager invocation. "
            ++ "Call .pager [less|more|nopager]", .{});
        return error.DotCommandError;
    }

    const typ: ?pager.PagerType = std.meta.stringToEnum(pager.PagerType, page.?);

    if (typ == null) {
        opts.msg.addErr("{s} is not a supported pager. "
            ++ "Call .pager [less|more|nopager]", .{page.?});
        return error.DotCommandError;
    }

    opts.pager.* = typ.?;
}

fn dcSave(args: *TokenIter, opts: DotCommandOptions) !void {
    var file: Io.File = undefined; 
    if (args.next()) |fname| {
        file = Dir.cwd().createFile(opts.io, fname, .{}) catch |e| {
            //FIXME: add `e` when we support this in addErr
            opts.msg.addErr("File IO error: {s}", .{@errorName(e)});  
            return error.DotCommandError;
        };
    } else {
        file = Io.File.stdout();
    }
    defer {
        if (file.handle != Io.File.stdout().handle) file.close(opts.io);
    }

    var buffer: [4096]u8 = undefined;
    var writer: Io.File.Writer = file.writer(opts.io, &buffer);

    CsvWriter.write(&writer.interface, opts.gpa, &opts.conn.last_result) catch |e| {
        opts.msg.addErr(".save failed: {s}", .{@errorName(e)});
        return error.DotCommandError;
    };

    try writer.interface.flush();
}

fn dcSource(args: *TokenIter, opts: DotCommandOptions) !void {
    const fname: []const u8 = args.next() orelse {
        opts.msg.addErr("Invalid command invocation.", .{});
        return error.DotCommandError;
    };

    const file = Dir.cwd().openFile(opts.io, fname, .{}) catch {
        opts.msg.addErr(
            "Cannot access '{s}': No such file or directory",
            .{ fname }
        );
        return error.DotCommandError;
    };
    defer file.close(opts.io);

    const fsize = try file.length(opts.io);
    const buffer: [:0]u8 = try opts.gpa.allocSentinel(u8, fsize, 0);
    defer opts.gpa.free(buffer);

    var reader: Io.File.Reader = file.reader(opts.io, buffer);
    try reader.interface.readSliceAll(buffer);

    // Clear the prior result set
    opts.conn.last_result.clear(opts.gpa);

    const prntbuf = opts.conn.execute(
        opts.io,
        opts.gpa,
        opts.msg,
        buffer
    ) catch {
        opts.msg.addErr("{s}", .{opts.conn.lastErrMsg()});
        return error.DotCommandError;
    };
    defer opts.gpa.free(prntbuf);
    
    try pager.page(opts.io, opts.pager.*, prntbuf);

    // Diagnostics
    var outbuf: [4096]u8 = undefined;
    var stderr: Io.File.Writer = Io.File.stderr().writer(opts.io, &outbuf);
    try stderr.interface.print("{f}\n", .{ opts.conn.pmon });
    try stderr.interface.flush();
}


const InputType = enum {
    blank, canceled, continued, dot, execute, exit
};

pub fn inputType(query: [*c]u8) InputType {
    // A Null value here indicates a ctrl-c or ctrl-d keypress. If ctrl-c,
    // then reset and continue. Otherwise exit the main loop.
    if (query == null) {
        if (std.c.errno(-1) == std.c.E.AGAIN) {
            return .canceled;
        } else {
            return .exit;
        }
    }

    const query_len = std.mem.len(query);

    // If the user entered a blank string, give a new prompt
    if (query_len == 0) {
        return .blank;
    }

    // Dot commands are meta commands for interacting with the session.
    if (query[0] == '.') {
        return .dot;
    }

    // If the user entered a string that is not semicolon terminated,
    // mark the input as continued
    if (query[query_len - 1] != ';') {
        return .continued;
    }

    return .execute;
}


pub const InputQuery = struct {
    const Self = @This();
    const buf_incr = 1;

    parts: [][]const u8,
    head: usize,

    pub fn init(gpa: Allocator, size: usize) !Self {
        const parts = try gpa.alloc([]const u8, size);

        return .{
            .parts = parts,
            .head = 0
        };
    }

    pub fn deinit(self: *Self, gpa: Allocator) void {
        for (self.parts[0..self.head]) |p| gpa.free(p);
        gpa.free(self.parts);
    }

    pub fn add(self: *Self, gpa: Allocator, val: []const u8) !void {
        if (self.head >= self.parts.len) {
            self.parts = try gpa.realloc(self.parts, self.parts.len + Self.buf_incr);
        }

        self.parts[self.head] = try gpa.dupe(u8, val);
        self.head += 1;
    }

    pub fn clear(self: *Self, gpa: Allocator) void {
        for (self.parts[0..self.head]) |p| gpa.free(p);
        self.head = 0;
        @memset(self.parts, "");
    }

    pub fn asStringZ(self: *Self, gpa: Allocator) ![:0]const u8 {
        return try std.mem.joinZ(gpa, " ", self.parts[0..self.head]);
    }

    pub fn isEmpty(self: *Self) bool {
        return self.head == 0;
    }
};

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

    pub fn expectObjectNext(self: Self) bool {
        if (self.last_word == null) return false;

        return std.mem.eql(u8, self.last_word.?, "from")
            or std.mem.eql(u8, self.last_word.?, "join");
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

    if (inpt_ctx.kind == null and active_query.isEmpty()) {
        const letter: ?u8 = inpt_ctx.firstLetter();

        // Enumerate dotcommands
        if (letter == '.') {
            const dots = comptime iterDotCommands();
            var indexes: [dots.len]usize = undefined;
            const idx = matchFromPrefix(inpt_ctx.input.rhs, &dots, &indexes);

            for (0..idx) |i| {
                const dc = dots[indexes[i]];
                c.linenoiseAddCompletion(compl, @ptrCast(dc));
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

    // TODO
    if (inpt_ctx.expectObjectNext()) {
        const objects: []ConnectionCatalog.Table = catalog.currentConnTables() catch return;

        for (objects) |obj| {
            const req: [:0]const u8 = std.mem.concatWithSentinel(gpa,
                u8,
                &.{ inpt_ctx.input.lhs, obj.name },
                '\x00'
            ) catch return;
            defer gpa.free(req);
            c.linenoiseAddCompletion(compl, @ptrCast(req));
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

