const std = @import("std");
const builtin = @import("builtin");
const c = @import("c");

pub const err = @import("err.zig");
pub const meta = @import("meta.zig");

pub const calcColumnMetadata = meta.calcColumnMetadata;
pub const ColMetadata = meta.ColMetadata;

pub const StreamBuffer = @import("StreamBuffer.zig");
pub const TableBuffer = @import("TableBuffer.zig");

const Allocator = std.mem.Allocator;
const Io = std.Io;
const posix = std.posix;

var cancelExecAtom = std.atomic.Value(bool).init(false);


/// WARNING: The order of these fields matter. If driver/uri are set, then they
/// can override whatever is in profile
pub const AdbcConfig = struct {
    profile: ?[]const u8,
    driver: ?[]const u8,
    uri: ?[]const u8,

    /// This is kind of a weird API, but basically if `profile` is set, then
    /// leave `driver` and `uri` null unless explicitly overridden. Otherwise,
    /// set default values for `driver` and `uri` to open a :memory: sqlite
    /// connection.
    pub fn init(
        profile: ?[]const u8,
        driver: ?[]const u8,
        uri: ?[]const u8
    ) AdbcConfig {
        return .{
            .profile = profile,
            .driver = if (driver == null and profile == null) "sqlite" else driver,
            .uri = if (uri == null and profile == null) ":memory:" else uri
        };
    }
};


pub fn executeWithCancel(
    io: Io,
    stmt: *c.AdbcStatement,
    errs: *c.AdbcError
) !c.ArrowArrayStream {
    cancelExecAtom.store(false, .release);

    const Branch = union(enum) {
        runner: anyerror!void,
        cancel: anyerror!void
    };

    var buf: [2]Branch = undefined;
    var sel: Io.Select(Branch) = .init(io, &buf);

    var stream: c.ArrowArrayStream = std.mem.zeroInit(c.ArrowArrayStream, .{});

    sel.async(.runner, executeStatement, .{stmt, &stream, errs});

    // Install a temporary signal handler to capture ctrl-c and cancel
    // the query being executed.
    posix.sigaction(
        posix.SIG.INT,
        &posix.Sigaction {
            .handler = .{ .handler = handleSigIntCancel },
            .mask = std.mem.zeroes(posix.sigset_t),
            .flags = 0
        },
        null
    );   

    sel.async(.cancel, cancelExecution, .{io, stmt, errs});

    const res = try sel.await();
    _ = sel.cancel();

    // Restore the signal handler to the default
    posix.sigaction(
        posix.SIG.INT,
        &posix.Sigaction {
            .handler = .{ .handler = posix.SIG.DFL },
            .mask = std.mem.zeroes(posix.sigset_t),
            .flags = 0
        },
        null
    );

    switch (res) {
        .runner => |r| { try r; return stream; },
        .cancel => return error.Canceled
    }

}

pub fn getInfo(
    gpa: Allocator,
    conn: *c.AdbcConnection,
    opt: u32,
    errs: *c.AdbcError
) !?[]const u8 {
    var stream: c.ArrowArrayStream = std.mem.zeroInit(c.ArrowArrayStream, .{});

    const n_opt = 1;

    try err.checkAdbc(c.AdbcConnectionGetInfo(conn,
        &[_]u32{ opt },
        n_opt,
        &stream,
        errs));
    defer if (stream.release) |release| release(&stream);

    var buf: StreamBuffer = try .init(gpa, 1);
    defer buf.deinit(gpa);

    try readStream(gpa, &stream, &buf);

    // Currently we assume that getInfo only returns one value, and therefore
    // one buffer. This is unlikely to be true long term, so to remind myself
    // of this later we will panic if the call returned more data so we can
    // write code to handle it.
    if (builtin.mode == .debug) {
        if (buf.filled > 1) {
            @panic("getInfo call returned more buffers (>1) than expected");
        }
    }

    var view: c.ArrowArrayView = std.mem.zeroInit(c.ArrowArrayView, .{});
    try err.checkNanoArrow(c.ArrowArrayViewInitFromSchema(&view, &buf.schema, &buf.err));
    try err.checkNanoArrowStream(c.ArrowArrayViewSetArray(
        &view,
        &buf.items[0],
        &buf.err
    ));

    const info_val_c = view.children[1];

    const type_id = c.ArrowArrayViewUnionTypeId(info_val_c, 0);
    const offset = c.ArrowArrayViewUnionChildOffset(info_val_c, 0);
    const child_i = c.ArrowArrayViewUnionChildIndex(info_val_c, 0);
    const child = info_val_c.*.children[@intCast(child_i)];

    switch (type_id) {
        0 => {
            const name_val = c.ArrowArrayViewGetStringUnsafe(child, offset);
            const name_len: usize = @intCast(name_val.size_bytes);
            if (name_len > 0) {
                return try gpa.dupe(u8, name_val.data[0..name_len]);
            }
        },
        // Not really, but I don't care right now.
        else => unreachable
    }

    return null;
}

pub fn getOption(
    gpa: Allocator,
    conn: *c.AdbcConnection,
    opt: []const u8,
    errs: *c.AdbcError
) !?[]const u8 {
    var opt_len: usize = 0;

    err.checkAdbc(c.AdbcConnectionGetOption(conn,
        @ptrCast(opt),
        null,
        &opt_len,
        errs
    )) catch return null;

    if (opt_len == 0) {
        return null;
    }

    var opt_buf: []u8 = try gpa.alloc(u8, opt_len);
    defer gpa.free(opt_buf);

    err.checkAdbc(c.AdbcConnectionGetOption(conn,
        @ptrCast(opt),
        opt_buf.ptr,
        &opt_len,
        errs
    )) catch return null;

    // NOTE: opt_buf is a null-terminated char buffer, so take the
    // entire buffer, minus the null terminator
    return try gpa.dupe(u8, opt_buf[0..opt_len - 1]);
}

pub fn setDatabaseOption(
    gpa: Allocator,
    db: *c.AdbcDatabase,
    errs: *c.AdbcError,
    key: []const u8,
    val: []const u8
) !void {
    const kz: [:0]const u8 = try gpa.dupeSentinel(u8, key, 0);
    const vz: [:0]const u8 = try gpa.dupeSentinel(u8, val, 0);

    defer {
        gpa.free(kz);
        gpa.free(vz);
    }

    try err.checkAdbc(c.AdbcDatabaseSetOption(db,
        @ptrCast(kz),
        @ptrCast(vz),
        errs));
}

/// Read an ArrowArrayStream into a storage buffer
pub fn readStream(
    gpa: Allocator,
    stream: *c.ArrowArrayStream,
    buffer: *StreamBuffer
) anyerror!void {
    const getSchema = stream.get_schema orelse return error.AdbcLibError;
    const getNext = stream.get_next orelse return error.AdbcLibError;

    try err.checkNanoArrowStream(getSchema(stream, &buffer.schema));

    var batch: c.ArrowArray = std.mem.zeroInit(c.ArrowArray, .{});
    while (getNext(stream, &batch) == 0) {
        if (batch.release == null) break;
        try buffer.add(gpa, batch);
    }
}

pub fn prepareStatement(
    c_query: [*c]const u8,
    conn: *c.AdbcConnection,
    errs: *c.AdbcError
) !c.AdbcStatement {
    var stmt: c.AdbcStatement = std.mem.zeroInit(c.AdbcStatement, .{});

    try err.checkAdbc(c.AdbcStatementNew(conn, &stmt, errs));

    // NOTE: Errors at this point usually indicate user-inflicted problems,
    // however, it will up to the caller how best to handle them.
    try err.checkAdbc(c.AdbcStatementSetSqlQuery(&stmt, c_query, errs));

    return stmt;
}

/// Wrap AdbcStatementExecuteQuery in error handling
pub fn executeStatement(
    stmt: *c.AdbcStatement,
    stream: *c.ArrowArrayStream,
    errs: *c.AdbcError
) !void {
    try err.checkAdbc(c.AdbcStatementExecuteQuery(
        stmt,
        stream,
        null, // Disable this for now &conn.rows_affected,
        errs
    ));
}

/// If SIGINT is received, set the global `cancelExecution` atomic to true
fn handleSigIntCancel(sig: posix.SIG) callconv(.c) void {
    _ = sig;
    cancelExecAtom.store(true, .release);
}

/// Cancels execution of a query if `cancelExecAtom` is set to true in a
/// different thread.
fn cancelExecution(
    io: Io,
    stmt: *c.AdbcStatement,
    errs: *c.AdbcError
) !void {
    while (!cancelExecAtom.load(.acquire)) {
        try io.sleep(Io.Duration.fromMilliseconds(1), .real);
    }

    // We got a request for cancelation. Clean up the running query
    try err.checkAdbc(c.AdbcStatementCancel(stmt, errs));
}

test {
    std.testing.refAllDecls(@This());
}
