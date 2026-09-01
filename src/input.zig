const std = @import("std");
const builtin = @import("builtin");
const adbc = @import("adbc");
const c = @import("c");
const parser = @import("parser");

const editor = @import("editor.zig");
const mesg = @import("message.zig");
const pager = @import("pager.zig");
const render = @import("render/root.zig");

const ConnectionCatalog = @import("ConnectionCatalog.zig");
const ConnectionIo = @import("ConnectionIo.zig");
const Color = @import("render/Color.zig");
const Shape = @import("render/Shape.zig");
const State = @import("State.zig");

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
    .{ ".format", DotCommand {
        // FIXME: I can generate this help message dynamically at comptime
        // based on known formatting options
        .help = "Set the output formatter to [ftable|table|csv]",
        .call = dcFormat }},
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

    const cats = catalog.catalogs();
    for (cats, 0..) |obj, i| {
        try treeLine(
            &writer.interface,
            obj.name,
            0, 
            if (i == catalog.current_database) Color.Yellow else null,
            i == cats.len - 1
        );

        for (obj.children, 0..) |sch, j| {
            try treeLine(
                &writer.interface,
                sch.name,
                1, 
                if (j == catalog.current_schema) Color.Yellow else null,
                j == obj.children.len - 1
            );

            for (sch.children, 0..) |tab, k| {
                try treeLine(
                    &writer.interface,
                    tab.name,
                    2, 
                    null,
                    k == sch.children.len - 1
                );
            }
        }
    }
    try writer.interface.flush();
}

fn treeLine(
    writer: *Io.Writer,
    val: []const u8,
    depth: usize,
    color: ?[]const u8,
    term: bool
) !void {
    const shape = if (term) Shape.Box.LBotCor else Shape.Box.LJunc;

    for (0..depth * 4) |i| {
        if (i % 4 == 0) {
            _ = try writer.write(Shape.Box.VertSep);
        } else {
            _ = try writer.writeByte(' ');
        }
    }

    if (color) |clr| {
        try writer.print("{s}{s}{s} {s}{s}{s}\n", .{
            shape, Shape.Box.HorizSep, Shape.Box.HorizSep, clr, val, Color.Reset
        });
    } else {
        try writer.print("{s}{s}{s} {s}\n", .{
            shape, Shape.Box.HorizSep, Shape.Box.HorizSep, val
        });
    }
}


fn dcEdit(args: *TokenIter, opts: DotCommandOptions) !void {
    const input: []const u8 = args.rest();

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

    if (input.len > 0) {
        writer.interface.writeAll(input) catch |e| {
            opts.msg.addErr("Could not write input {s}", .{@errorName(e)});
            return error.DotCommandError;
        };
    } else {
        writer.interface.writeAll(opts.state.conn.last_statement orelse "") catch |e| {
            opts.msg.addErr("Could not write last statement {s}", .{@errorName(e)});
            return error.DotCommandError;
        };
    }

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

fn dcFormat(args: *TokenIter, opts: DotCommandOptions) !void {
    const sel: []const u8 = args.next() orelse {
        opts.msg.addErr("Invalid .format invocation. "
            ++ "Call .format [ftable|table|csv]", .{});
        return error.DotCommandError;
    };

    opts.state.tbl_writer = std.meta.stringToEnum(render.WriterType, sel) orelse {
        opts.msg.addErr("Invalid .format invocation. "
            ++ "Call .format [ftable|table|csv]", .{});
        return error.DotCommandError;
    };
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

    const tw: render.TableWriter = render.fromWriterType(.csv, &writer.interface);
    tw.write(opts.gpa, &opts.state.conn.last_result) catch |e| {
        opts.msg.addErr(".save failed: {s}", .{@errorName(e)});
        return error.DotCommandError;
    };
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
    const buffer: [:0]u8 = try gpa.allocSentinel(u8, fsize, 0);
    defer gpa.free(buffer);

    var reader: Io.File.Reader = file.reader(io, buffer);
    try reader.interface.readSliceAll(buffer);

    try execStatements(io, gpa, state, msg, buffer);
}

/// This is a wrapper for execTokenBuffer which takes an arbitrary query string
/// containing one or many sql queries, and parses it into a token buffer as a
/// first step. This API is available for uses where the input has not already
/// been parsed into a token buffer.
pub fn execStatements(
    io: Io,
    gpa: Allocator,
    state: *State,
    msg: *mesg.MessageBuffer,
    query: [:0]const u8
) !void {
    // Memorialize the input
    _ = addHistory(query);

    var stmts: parser.TokenBuffer = try parser.FastScan.scan(gpa, query);
    defer stmts.deinit(gpa);

    try execTokenBuffer(io, gpa, state, msg, &stmts);
}

/// Given a TokenBuffer result from a Scanner's .scan(), execute one or many
/// sql queries that are reconstituted from the TokenBuffer, and print the
/// results.
pub fn execTokenBuffer(
    io: Io,
    gpa: Allocator,
    state: *State,
    msg: *mesg.MessageBuffer,
    toks: *parser.TokenBuffer
) !void {
    const stmts: []parser.TokenBuffer = try toks.split(gpa);
    defer gpa.free(stmts);

    for (stmts) |stmt| {
        const qstr: [:0]const u8 = try stmt.asStringZ(gpa);
        defer gpa.free(qstr);

        try execStatementPrint(io, gpa, state, msg, qstr);
    }
}

/// Execute one sql query and print the result to the pager. Print performance
/// data to stderr.
fn execStatementPrint(
    io: Io,
    gpa: Allocator,
    state: *State,
    msg: *mesg.MessageBuffer,
    query: [:0]const u8
) !void {
    // Clear the prior result set
    state.conn.clear(gpa);

    state.conn.execute(io, gpa, msg, query) catch {
        return error.ExecutionError;
    };

    var outbuf: [4096]u8 = undefined;
    var sink: pager.Pager = try pager.page(io, state.page, &outbuf);

    const tw: render.TableWriter = render.fromWriterType(
        state.tbl_writer,
        &sink.writer.interface);

    // WARNING: 
    //  When we close our pager without reading the full result set, less
    //  will attempt to issue a SIGPIPE which terminates the parent process.
    //  We are ignoring these signals. As a result, incomplete reading of
    //  inputs results in a WriteFailed error due to a broken pipe. In this
    //  case, we are just ignoring the error and returning.
    tw.write(gpa, &state.conn.last_result) catch |err| {
        if (err != error.WriteFailed) {
            return err;
        }
    };

    try sink.close(io);

    // Diagnostics
    var stderr: Io.File.Writer = Io.File.stderr().writer(io, &outbuf);
    try stderr.interface.print("{f}\n", .{ state.conn.pmon });
    try stderr.interface.flush();
}


const InputType = enum {
    blank, canceled, continued, dot, execute, exit
};

pub fn inputType(gpa: Allocator, query: [*c]u8) InputType {
    // A Null value here indicates a ctrl-c or ctrl-d keypress. If ctrl-c,
    // then reset and continue. Otherwise exit the main loop.
    if (query == null) {
        if (std.c.errno(-1) == std.c.E.AGAIN) {
            return .canceled;
        } else {
            return .exit;
        }
    }

    // For debugging purposes, print the input given verbatim
    if (builtin.mode == .debug) {
        std.debug.print("{s}\n", .{query});
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

    // At this point, the input from the user (if valid) is a full sql query
    // or part of a full query. Scan the query to determine more confidently
    // if it is semicolon terminated.
    var inpt: parser.TokenBuffer = parser.FastScan.scan(gpa, std.mem.span(query)) catch {
        // If scanning failed we just quit from here, which isn't ideal long
        // term, but there's not really anything useful we can do if this
        // fails. It's likely an OOM error anyway.
        return .exit;
    };
    // FIXME: Ideally we store this already partially scanned input in InputQuery
    // instead of having to re-scan during exec. So this is temporary.
    defer inpt.deinit(gpa);

    // If the user entered a string that is not semicolon terminated,
    // mark the input as continued
    if (!inpt.lastTokenNonWs().is(.SEMICOLON)) {
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

/// Return an array of keywords that the parser knows
fn iterKeywords() [parser.Token.KeywordLookup.keys().len][]const u8 {
    const keys = comptime parser.Token.KeywordLookup.keys();
    var kcopy: [keys.len][]const u8 = undefined;

    @memcpy(&kcopy, keys);

    // https://ziggit.dev/t/what-is-the-eval-branch-quota/7852
    @setEvalBranchQuota(4000);
    std.mem.sort([] const u8, &kcopy, {}, struct {
        fn lessThan(_: void, lhs: []const u8, rhs: []const u8) bool {
            return std.mem.order(u8, lhs, rhs) == .lt;
        }
    }.lessThan);

    return kcopy;
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
    const keywords = comptime iterKeywords();
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
