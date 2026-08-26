const std = @import("std");
const adbc = @import("adbc");
const c = @import("c");
const parser = @import("parser");

const editor = @import("editor.zig");
const mesg = @import("message.zig");
const pager = @import("pager.zig");

const ConnectionCatalog = @import("ConnectionCatalog.zig");
const ConnectionIo = @import("ConnectionIo.zig");
const Color = @import("render/Color.zig");
const CsvWriter = @import("render/CsvWriter.zig");
const State = @import("State.zig");
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
    gpa: Allocator,
    io: Io,
    state: *State,
    msg: *mesg.MessageBuffer
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
    .{ ".edit", DotCommand {
        .help = "Edit the last statement using env EDITOR",
        .call = dcEdit }},
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

fn dcEdit(args: *TokenIter, opts: DotCommandOptions) !void {
    _ = args;

    if (opts.state.edit == null) {
        opts.msg.addErr("Editor not available", .{});  
        return error.DotCommandError;
    }

    var file: Io.File = Dir.createFileAbsolute(opts.io, editor.tmp_buffer, .{}) catch |e| {
        opts.msg.addErr("File IO error: {s}", .{@errorName(e)});  
        return error.DotCommandError;
    };
    defer file.close(opts.io);

    var buffer: [4096]u8 = undefined;
    var writer: Io.File.Writer = file.writer(opts.io, &buffer);

    writer.interface.writeAll(opts.state.conn.last_statement orelse "") catch |e| {
        opts.msg.addErr("Could not write last statement {s}", .{@errorName(e)});
        return error.DotCommandError;
    };

    try writer.interface.flush();

    try editor.edit(opts.io, opts.state.edit.?, editor.tmp_buffer);

    try sourceFile(opts.io, opts.gpa, opts.state, opts.msg, editor.tmp_buffer);
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
    const cur: ?u64 = opts.state.conn.row_limit;
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

    opts.state.conn.row_limit = std.fmt.parseInt(u64, new.?, 10) catch {
        opts.msg.addErr("Invalid limit.", .{});
        return error.DotCommandError;
    };
}

fn dcNoLimit(args: *TokenIter, opts: DotCommandOptions) !void {
    _ = args;
    opts.state.conn.row_limit = null;
}

fn dcPager(args: *TokenIter, opts: DotCommandOptions) !void {
    const page: ?[]const u8 = args.next();

    if (page == null) {
        opts.msg.addErr("Invalid .pager invocation. "
            ++ "Call .pager [less|more|nopager]", .{});
        return error.DotCommandError;
    }

    opts.state.page = pager.fromString(page.?) catch {
        opts.msg.addErr("{s} is not a supported pager. "
            ++ "Call .pager [less|more|nopager]", .{page.?});
        return error.DotCommandError;
    };
}

fn dcSave(args: *TokenIter, opts: DotCommandOptions) !void {
    var file: Io.File = undefined; 
    if (args.next()) |fname| {
        file = Dir.cwd().createFile(opts.io, fname, .{}) catch |e| {
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

    CsvWriter.write(&writer.interface, opts.gpa, &opts.state.conn.last_result) catch |e| {
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

    try sourceFile(opts.io, opts.gpa, opts.state, opts.msg, fname);
}

pub fn sourceFile(
    io: Io,
    gpa: Allocator,
    state: *State,
    msg: *mesg.MessageBuffer,
    path: []const u8
) !void {
    const file = Dir.cwd().openFile(io, path, .{}) catch {
        msg.addErr(
            "Cannot access '{s}': No such file or directory",
            .{ path }
        );
        return error.SourceFileError;
    };
    defer file.close(io);

    const fsize = try file.length(io);
    const buffer: []u8 = try gpa.alloc(u8, fsize);
    defer gpa.free(buffer);

    var reader: Io.File.Reader = file.reader(io, buffer);
    try reader.interface.readSliceAll(buffer);

    try execStatements(io, gpa, state, msg, buffer);
}

pub fn execStatement(
    io: Io,
    gpa: Allocator,
    state: *State,
    msg: *mesg.MessageBuffer,
    query: [:0]const u8
) !void {
    // Clear the prior result set
    state.conn.clear(gpa);

    const prntbuf = state.conn.execute(io, gpa, msg, query) catch {
        return error.ExecutionError;
    };
    defer gpa.free(prntbuf);

    var source: Io.Reader = .fixed(prntbuf);

    try pager.page(io, state.page, &source);

    // Diagnostics
    var outbuf: [4096]u8 = undefined;
    var stderr: Io.File.Writer = Io.File.stderr().writer(io, &outbuf);
    try stderr.interface.print("{f}\n", .{ state.conn.pmon });
    try stderr.interface.flush();
}

pub fn execStatements(
    io: Io,
    gpa: Allocator,
    state: *State,
    msg: *mesg.MessageBuffer,
    query: []const u8
) !void {
    var stmts: parser.TokenBuffer = try parser.FastScan.scan(gpa, query);
    defer stmts.deinit(gpa);
    
    const stmt_lst: []parser.TokenBuffer = try stmts.split(gpa);
    defer gpa.free(stmt_lst);

    for (stmt_lst) |stmt| {
        const qstr: [:0]const u8 = try stmt.asStringZ(gpa);
        defer gpa.free(qstr);

        try execStatement(io, gpa, state, msg, qstr);
    }
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

    pub fn asString(self: *Self, gpa: Allocator) ![]const u8 {
        return try std.mem.join(gpa, "\n", self.parts[0..self.head]);
    }

    pub fn asStringZ(self: *Self, gpa: Allocator) ![:0]const u8 {
        return try std.mem.joinZ(gpa, "\n", self.parts[0..self.head]);
    }

    pub fn isEmpty(self: *Self) bool {
        return self.head == 0;
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

    const inpt: []const u8 = std.mem.span(buf);

    // Case: We got an empty input. Provide completions which are keywords
    // which start a sql query, e.g. create, select, etc.
    if (inpt.len == 0) {
        inline for (comptime tagNames(parser.StatementType)) |kw| {
            c.linenoiseAddCompletion(compl, @ptrCast(kw));
        }

        return;
    }

    // Case: We got a dotcommand. Enumerate dotcommands that match input
    // thus far.
    if (active_query.isEmpty() and inpt.len > 0 and inpt[0] == '.') {
        const dots = comptime iterDotCommands();
        var indexes: [dots.len]usize = undefined;
        const idx = matchFromPrefix(inpt, &dots, &indexes);

        for (0..idx) |i| {
            const dc = dots[indexes[i]];
            // FIXME: Is the use of ptrCast here a possible bug? Why does this
            // sometimes work and sometimes not? Is the difference whether a
            // string is comptime known?
            c.linenoiseAddCompletion(compl, @ptrCast(dc));
        }

        return;
    }

    // We have some unknown input that is likely a sql query. To properly
    // identify the best possible completions, we need to scan the input into
    // tokens.
    const ctx: parser.TokenBuffer = parser.FastScan.scan(gpa, inpt) catch return;

    const rhs: []const u8 = ctx.asStringRange(gpa, 0, ctx.items.len - 1) catch return;
    defer gpa.free(rhs);

    // Case: We just passed a token which indicates a special behavior: the
    // next completion should be an object from the database catalog.
    if (expectObjectNext(ctx)) {
        const objects: []ConnectionCatalog.Table = catalog.currentConnTables() catch return;
        const indexes: []usize = gpa.alloc(usize, objects.len) catch return;
        defer gpa.free(indexes);

        const idx = if (ctx.lastToken().isWhitespace()) blk: {
            break :blk fillSequential(indexes);
        } else blk: {
            // NOTE: Usage of matchObjectFromPrefix is used here specifically
            // to avoid allocating a buffer just to copy .name from objects
            // for comparison.
            break :blk matchObjectFromPrefix(
                @typeInfo(@TypeOf(objects)).pointer.child,
                ctx.tokenString(ctx.lastToken()),
                objects,
                indexes);
        };

        for (0..idx) |i| {
            // This is extremely clunky trying to preseve a possible trailing
            // space. There is surely a cleaner way to do this.
            const req: [:0]const u8 = if (ctx.lastToken().isWhitespace()) blk: {
                break :blk std.mem.concatWithSentinel(gpa,
                    u8,
                    &.{ rhs, " ", objects[indexes[i]].name },
                    '\x00'
                ) catch return;
            } else blk: {
                break :blk std.mem.concatWithSentinel(gpa,
                    u8,
                    &.{ rhs, objects[indexes[i]].name },
                    '\x00'
                ) catch return;
            };
            defer gpa.free(req);
            c.linenoiseAddCompletion(compl, @ptrCast(req));
        }

        return;
    }

    // Case: We have at least one token but it is not whitespace, therefore we
    // are still on the word being typed. Try to complete that word.
    if (!ctx.lastToken().isWhitespace()) {
        const sugs = completionSuggestions(gpa,
            ctx.tokenString(ctx.lastToken())
        ) catch return;
        defer gpa.free(sugs);

        for (sugs) |sug| {
            const req: [:0]const u8 = std.mem.concatWithSentinel(gpa,
                u8,
                &.{ rhs, sug },
                '\x00'
            ) catch return;
            defer gpa.free(req);

            c.linenoiseAddCompletion(compl, @ptrCast(req));
        }

        return;
    }
}

/// Provide unrestricted suggestions by filling the match index buffer with
/// a sequence from 0 to length;
fn fillSequential(
    matches: []usize
) usize {
    for (0..matches.len) |i| {
        matches[i] = i;
    }

    return matches.len;
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

/// Provide suggestions based on the strings matching T.name so far. Requires
/// that T have a `name` field. Returns the number of potential matches.
/// Provides the indexes of these matches from the `completions` input slice
/// on the `matches` input slice. 
///
/// FIXME: Perhaps we can pass in the field name to make this more generic
fn matchObjectFromPrefix(
    comptime T: type,
    term: []const u8,
    completions: []T,
    matches: []usize
) usize {
    // Both completions and matches must be the same length
    assert(completions.len == matches.len);

    var idx: usize = 0;

    for (completions, 0..) |cmp, i| {
        if (cmp.name.len < term.len) {
            continue;
        }

        if (std.mem.eql(u8, term, cmp.name[0..term.len])) {
            matches[idx] = i;
            idx += 1;
        }
    }

    return idx;
}

fn completionSuggestions(
    gpa: Allocator,
    term: []const u8
) ![][]const u8 {

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

/// Returns true if the object to be completed is expected to be a database
/// object. E.g. select ... from m[y_table]. This function searches backwards
/// from the input context to check the last non-ws token and the penultimate
/// non-ws token to determine if it is a token which should be followed by a
/// database object.
fn expectObjectNext(context: parser.TokenBuffer) bool {
    var tries: u8 = 2;
    var i: usize = context.items.len - 1;

    while (tries > 0 and i >= 0) : (i -= 1) {
        const tok: parser.Token = context.items[i];

        if (tok.isWhitespace()) continue;

        if (
            std.mem.eql(u8, context.tokenString(tok), "from")
            or std.mem.eql(u8, context.tokenString(tok), "join")
        ) return true;

        tries -= 1;

        if (i == 0) break;
    }

    return false;
}

fn tagNames(comptime E: type) [std.meta.fieldNames(E).len][]const u8 {
    return comptime blk: {
        const names = std.meta.fieldNames(E);
        var res: [names.len][]const u8 = undefined;

        for (names, 0..) |f, i| {
            res[i] = f;
        }

        break :blk res;
    };
}
