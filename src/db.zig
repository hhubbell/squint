const std = @import("std");
const errors = @import("errors.zig");
const h = @import("cheaders.zig");


pub const ConnManager = struct {
    const Self = @This();

    db: h.c.AdbcDatabase,
    conn: h.c.AdbcConnection,
    err: h.c.AdbcError,
    last_row_count: u64,

    pub fn init() Self {
        return .{
            .db = .{},
            .conn = .{},
            .err = .{},
            .last_row_count = 0
        };
    }

    pub fn deinit(self: *Self) !void {
       try self.checkAdbc(h.c.AdbcConnectionRelease(self.conn, self.err));
       try self.checkAdbc(h.c.AdbcDatabaseRelease(self.db, self.err));
    }

    pub fn lastErrMsg(self: *Self) []const u8 {
        if (self.err.message != null) {
            return std.mem.span(self.err.message);
        } else {
            return "No error message provided.";
        }
    }
};


/// WARNING: This currently only works for ADBC built drivers made available
/// through the adbc driver manager interface.
pub const AdbcDriverMap = std.StaticStringMap([]const u8).initComptime(.{
    .{ "postgres", "adbc_driver_postgres" },
    .{ "sqlite",  "adbc_driver_sqlite" },
    .{ "snowflake", "adbc_driver_snowflake" }
});


/// Wraps an Arrow ADBC function call in error handling
pub fn checkAdbc(rcode: c_int) !void {
    if (rcode != h.c.ADBC_STATUS_OK) {
        return error.AdbcError;
    }
}


pub fn connectSqlite(mgr: *ConnManager, driver: []const u8, uri: []const u8) !void {
    const adbc_drv = AdbcDriverMap.get(driver) orelse return error.InvalidDriver;

    const c_drv: [*:0]const u8 = @ptrCast(adbc_drv.ptr);
    const c_uri: [*:0]const u8 = @ptrCast(uri.ptr);

    try checkAdbc(h.c.AdbcDatabaseNew(&mgr.db, &mgr.err));
    try checkAdbc(h.c.AdbcDatabaseSetOption(&mgr.db, "driver", c_drv, &mgr.err));
    try checkAdbc(h.c.AdbcDatabaseSetOption(&mgr.db, "uri", c_uri, &mgr.err));
    try checkAdbc(h.c.AdbcDatabaseInit(&mgr.db, &mgr.err));

    try checkAdbc(h.c.AdbcConnectionNew(&mgr.conn, &mgr.err));
    try checkAdbc(h.c.AdbcConnectionInit(&mgr.conn, &mgr.db, &mgr.err));
}

pub fn prepareStatement(mgr: *ConnManager, query: []const u8) !h.c.AdbcStatement {
    const c_query: [*:0]const u8 = @ptrCast(query.ptr);

    var stmt: h.c.AdbcStatement = .{};

    try checkAdbc(h.c.AdbcStatementNew(&mgr.conn, &stmt, &mgr.err));

    // NOTE: Errors at this point usually indicate user-inflicted problems,
    // however, it will up to the caller how best to handle them.
    try checkAdbc(h.c.AdbcStatementSetSqlQuery(&stmt, c_query, &mgr.err));

    return stmt;
}

pub fn executeStatement(mgr: *ConnManager, stmt: *h.c.AdbcStatement) !h.c.ArrowArrayStream {
    var stream: h.c.ArrowArrayStream = .{};

    try checkAdbc(h.c.AdbcStatementExecuteQuery(stmt, &stream, null, &mgr.err));

    return stream;
}

pub fn releaseStatement(mgr: *ConnManager, stmt: *h.c.AdbcStatement) !void {
    try checkAdbc(h.c.AdbcStatementRelease(stmt, &mgr.err));
}

