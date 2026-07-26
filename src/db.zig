const std = @import("std");
const c = @import("c");
const config = @import("config");

const Allocator = std.mem.Allocator;
const Io = std.Io;
const posix = std.posix;

var cancelExecAtom = std.atomic.Value(bool).init(false);


pub const ConnManager = struct {
    const Self = @This();

    db: c.AdbcDatabase,
    conn: c.AdbcConnection,
    err: c.AdbcError,
    rows_affected: i64 = 0,
    // NOTE: Default row limit is 10 buffers of 1024 rows
    row_limit: ?u64 = 10_240,

    pub fn init() Self {
        return .{
            .db = std.mem.zeroInit(c.AdbcDatabase, .{}),
            .conn = std.mem.zeroInit(c.AdbcConnection, .{}),
            .err = std.mem.zeroInit(c.AdbcError, .{}),
        };
    }

    pub fn deinit(self: *Self) !void {
       try checkAdbc(c.AdbcConnectionRelease(&self.conn, &self.err));
       try checkAdbc(c.AdbcDatabaseRelease(&self.db, &self.err));
    }

    pub fn lastErrMsg(self: *Self) []const u8 {
        if (self.err.message != null) {
            return std.mem.span(self.err.message);
        } else {
            return "No error message provided.";
        }
    }
};


/// Wraps an Arrow ADBC function call in error handling
pub fn checkAdbc(rcode: c_int) !void {
    if (rcode != c.ADBC_STATUS_OK) {
        return error.AdbcError;
    }
}

pub fn connectDriver(alloc: Allocator, mgr: *ConnManager, cfg: config.Config) !void {
    const c_drv: [:0]const u8 = try alloc.dupeSentinel(u8, cfg.driver, 0);
    defer alloc.free(c_drv);

    try checkAdbc(c.AdbcDatabaseNew(&mgr.db, &mgr.err));
    try checkAdbc(c.AdbcDatabaseSetOption(&mgr.db, "driver", @ptrCast(c_drv), &mgr.err));
    try checkAdbc(c.AdbcDriverManagerDatabaseSetLoadFlags(&mgr.db, c.ADBC_LOAD_FLAG_DEFAULT, &mgr.err));

    // We guarantee that at least uri is part of the config, so we do not need
    // to explicitly set this option. Instead we just iterate over every field
    // and set the option on the connection.
    //
    // XXX:
    // The duckdb docs say use "path" but URI also works. Presumably URI could
    // add additional things but IDK what that would be. It doesn't matter
    // because we just iterate over the struct. This comment is kind of
    // pointless, but I think I'll need to remember this someday.
    const cfg_iter = try cfg.iterFields(alloc);
    defer alloc.free(cfg_iter);

    for (cfg_iter) |kv| {
        if (kv.val == null) {
            continue;
        }

        const c_k: [:0]const u8 = try alloc.dupeSentinel(u8, kv.key, 0);
        const c_v: [:0]const u8 = try alloc.dupeSentinel(u8, kv.val.?, 0);

        defer alloc.free(c_k);
        defer alloc.free(c_v);

        try checkAdbc(c.AdbcDatabaseSetOption(&mgr.db, @ptrCast(c_k), @ptrCast(c_v), &mgr.err));
    }

    try checkAdbc(c.AdbcDatabaseInit(&mgr.db, &mgr.err));

    try checkAdbc(c.AdbcConnectionNew(&mgr.conn, &mgr.err));
    try checkAdbc(c.AdbcConnectionInit(&mgr.conn, &mgr.db, &mgr.err));
}

pub fn prepareStatement(mgr: *ConnManager, query: []const u8) !c.AdbcStatement {
    const c_query: [*:0]const u8 = @ptrCast(query.ptr);

    var stmt: c.AdbcStatement = std.mem.zeroInit(c.AdbcStatement, .{});

    try checkAdbc(c.AdbcStatementNew(&mgr.conn, &stmt, &mgr.err));

    // NOTE: Errors at this point usually indicate user-inflicted problems,
    // however, it will up to the caller how best to handle them.
    try checkAdbc(c.AdbcStatementSetSqlQuery(&stmt, c_query, &mgr.err));

    return stmt;
}

/// Execute an AdbcStatement with cancelation by running the query concurrently
/// and listening for a possible SIGINT to cancel. If the query returns or
/// SIGINT is received, then clean up and return. If SIGINT is received, then
/// also cancel the execution and return error.Cancelable
pub fn executeStatementWithCancel(
    io: Io,
    mgr: *ConnManager,
    stmt: *c.AdbcStatement
) !c.ArrowArrayStream {
    cancelExecAtom.store(false, .release);

    const Branch = union(enum) {
        runner: anyerror!void,
        cancel: anyerror!void
    };

    var buf: [2]Branch = undefined;
    var sel: Io.Select(Branch) = .init(io, &buf);

    var stream: c.ArrowArrayStream = std.mem.zeroInit(c.ArrowArrayStream, .{});

    sel.async(.runner, executeStatement, .{mgr, stmt, &stream});

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

    sel.async(.cancel, cancelExecution, .{io, mgr, stmt});

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

pub fn releaseStatement(mgr: *ConnManager, stmt: *c.AdbcStatement) !void {
    try checkAdbc(c.AdbcStatementRelease(stmt, &mgr.err));
}

/// Wrap AdbcStatementExecuteQuery in error handling
fn executeStatement(
    mgr: *ConnManager,
    stmt: *c.AdbcStatement,
    stream: *c.ArrowArrayStream
) !void {
    try checkAdbc(c.AdbcStatementExecuteQuery(
        stmt,
        stream,
        &mgr.rows_affected,
        &mgr.err
    ));
}

/// If SIGINT is received, set the global `cancelExecution` atomic to true
fn handleSigIntCancel(sig: posix.SIG) callconv(.c) void {
    _ = sig;
    cancelExecAtom.store(true, .release);
}

/// Cancels execution of a query if `cancelExecAtom` is set to true in a
/// different thread.
fn cancelExecution(io: Io, mgr: *ConnManager, stmt: *c.AdbcStatement) !void {
    while (!cancelExecAtom.load(.acquire)) {
        try io.sleep(Io.Duration.fromMilliseconds(1), .real);
    }

    // We got a request for cancelation. Clean up the running query
    try checkAdbc(c.AdbcStatementCancel(stmt, &mgr.err));
}
