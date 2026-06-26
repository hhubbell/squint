const std = @import("std");
const c = @import("c");
const errors = @import("errors.zig");


pub const ConnManager = struct {
    const Self = @This();

    db: c.AdbcDatabase,
    conn: c.AdbcConnection,
    err: c.AdbcError,
    last_row_count: u64,

    pub fn init() Self {
        return .{
            .db = std.mem.zeroInit(c.AdbcDatabase, .{}),
            .conn = std.mem.zeroInit(c.AdbcConnection, .{}),
            .err = std.mem.zeroInit(c.AdbcError, .{}),
            .last_row_count = 0
        };
    }

    pub fn deinit(self: *Self) !void {
       try self.checkAdbc(c.AdbcConnectionRelease(self.conn, self.err));
       try self.checkAdbc(c.AdbcDatabaseRelease(self.db, self.err));
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
/// FIXME: No longer necessary that we use a newer adbc spec, which defines
/// a directory structure and toml config entry point. We can refer to drivers
/// by name instead of by their static library
pub const AdbcDriverMap = std.StaticStringMap([]const u8).initComptime(.{
    .{ "duckdb", "duckdb" },
    .{ "postgres", "postgres" },
    .{ "sqlite",  "sqlite" },
    .{ "snowflake", "snowflake" }
});


/// Wraps an Arrow ADBC function call in error handling
pub fn checkAdbc(rcode: c_int) !void {
    if (rcode != c.ADBC_STATUS_OK) {
        return error.AdbcError;
    }
}


pub fn connectSqlite(mgr: *ConnManager, driver: []const u8, uri: []const u8) !void {
    const adbc_drv = AdbcDriverMap.get(driver) orelse return error.InvalidDriver;

    const c_drv: [*:0]const u8 = @ptrCast(adbc_drv.ptr);
    const c_uri: [*:0]const u8 = @ptrCast(uri.ptr);

    // XXX:
    // The duckdb docs say use "path" but URI also works. Presumably URI could
    // add additional things but IDK what that would be
    // const c_psc: [*:0]const u8 = if (std.mem.eql(u8, adbc_drv, "duckdb")) "path" else "uri";
    const c_psc: [*:0]const u8 = "uri"; 

    try checkAdbc(c.AdbcDatabaseNew(&mgr.db, &mgr.err));
    try checkAdbc(c.AdbcDriverManagerDatabaseSetLoadFlags(&mgr.db, c.ADBC_LOAD_FLAG_DEFAULT, &mgr.err));
    try checkAdbc(c.AdbcDatabaseSetOption(&mgr.db, "driver", c_drv, &mgr.err));
    try checkAdbc(c.AdbcDatabaseSetOption(&mgr.db, c_psc, c_uri, &mgr.err));
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

pub fn executeStatement(mgr: *ConnManager, stmt: *c.AdbcStatement) !c.ArrowArrayStream {
    var stream: c.ArrowArrayStream = std.mem.zeroInit(c.ArrowArrayStream, .{});

    try checkAdbc(c.AdbcStatementExecuteQuery(stmt, &stream, null, &mgr.err));

    return stream;
}

pub fn releaseStatement(mgr: *ConnManager, stmt: *c.AdbcStatement) !void {
    try checkAdbc(c.AdbcStatementRelease(stmt, &mgr.err));
}

