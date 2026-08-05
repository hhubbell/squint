const std = @import("std");
const c = @import("c");

pub const err = @import("err.zig");
pub const meta = @import("meta.zig");
pub const schema = @import("schema.zig");

pub const calcColumnMetadata = meta.calcColumnMetadata;
pub const ColMetadata = meta.ColMetadata;

pub const ArrowStreamBuffer = @import("StreamBuffer.zig");

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

pub const ConnectionIo = struct {
    const Self = @This();

    db: c.AdbcDatabase,
    conn: c.AdbcConnection,
    err: c.AdbcError,
    rows_affected: i64 = 0,
    row_limit: ?u64 = 10_240,

    pub fn init() Self {
        return .{
            .db = std.mem.zeroInit(c.AdbcDatabase, .{}),
            .conn = std.mem.zeroInit(c.AdbcConnection, .{}),
            .err = std.mem.zeroInit(c.AdbcError, .{}),
        };
    }

    pub fn deinit(self: *Self) !void {
       try err.checkAdbc(c.AdbcConnectionRelease(&self.conn, &self.err));
       try err.checkAdbc(c.AdbcDatabaseRelease(&self.db, &self.err));
    }

    pub fn errPtr(self: *Self) *c.AdbcError {
        // If an error already exists, free it before returning a fresh
        // struct pointer. I think this may warrant rethinking how error
        // handling happens generally. E.g. an independent error wrapper
        // with explicit init
        if (self.err.release) |release| release(&self.err);

        self.err = std.mem.zeroInit(c.AdbcError, .{});

        return &self.err;
    }

    pub fn lastErrMsg(self: *Self) []const u8 {
        if (self.err.message != null) {
            return std.mem.span(self.err.message);
        } else {
            return "No error message provided.";
        }
    }
};

pub const ConnectionCatalog = struct {
    const Self = @This();
    const Filter = struct {
        catalog: ?[]const u8 = null,
        schema: ?[]const u8 = null,
        table: ?[]const u8 = null
    };

    items: []schema.Catalog,

    pub fn deinit(self: Self, gpa: Allocator) void {
        for (self.items) |*i| i.deinit(gpa);
        gpa.free(self.items);
    }

    pub fn catalogs(self: *Self) []schema.Catalog {
        return self.items;
    }

    pub fn schemas(
        self: *Self,
        gpa: Allocator,
        filter: Self.Filter
    ) ![]schema.Schema {
        var collector: std.ArrayList(schema.Schema) = .empty;
        defer collector.deinit(gpa);

        for (self.catalogs()) |obj| {
            var match: bool = true;

            if (filter.catalog != null) {
                match = std.mem.eql(u8, obj.name, filter.catalog.?);
            }

            if (match) {
                try collector.appendSlice(gpa, obj.children);
            }
        }

        return try collector.toOwnedSlice(gpa);
    }

    pub fn tables(
        self: *Self,
        gpa: Allocator,
        filter: Self.Filter
    ) ![]schema.Table {
        var collector: std.ArrayList(schema.Table) = .empty;
        defer collector.deinit(gpa);

        const parents = try self.schemas(gpa, filter);
        defer gpa.free(parents);

        for (parents) |obj| {
            var match: bool = true;

            if (filter.schema != null) {
                match = std.mem.eql(u8, obj.name, filter.schema.?);
            }

            if (match) {
                try collector.appendSlice(gpa, obj.children);
            }
        }

        return try collector.toOwnedSlice(gpa);
    }
};


pub fn connect(
    alloc: Allocator,
    conn: *ConnectionIo,
    cfg: AdbcConfig
) !void {
    try err.checkAdbc(c.AdbcDatabaseNew(&conn.db, conn.errPtr()));
    try err.checkAdbc(c.AdbcDriverManagerDatabaseSetLoadFlags(&conn.db,
        c.ADBC_LOAD_FLAG_DEFAULT,
        conn.errPtr()
    ));

    inline for (@typeInfo(@TypeOf(cfg)).@"struct".field_names) |f| {
        const v = @field(cfg, f);

        if (v != null) {
            const c_f: [:0]const u8 = try alloc.dupeSentinel(u8, f, 0);
            const c_v: [:0]const u8 = try alloc.dupeSentinel(u8, v.?, 0);

            defer alloc.free(c_f);
            defer alloc.free(c_v);

            try err.checkAdbc(c.AdbcDatabaseSetOption(&conn.db,
                @ptrCast(c_f),
                @ptrCast(c_v),
                conn.errPtr()));
        }
    }

    try err.checkAdbc(c.AdbcDatabaseInit(&conn.db, conn.errPtr()));

    try err.checkAdbc(c.AdbcConnectionNew(&conn.conn, conn.errPtr()));
    try err.checkAdbc(c.AdbcConnectionInit(&conn.conn, &conn.db, conn.errPtr()));
}

pub fn executeWithCancel(
    io: Io,
    conn: *ConnectionIo,
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

    sel.async(.runner, executeStatement, .{conn, stmt, &stream});

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

    sel.async(.cancel, cancelExecution, .{io, conn, stmt});

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

pub fn prepareStatement(
    conn: *ConnectionIo,
    c_query: [*c]const u8
) !c.AdbcStatement {
    var stmt: c.AdbcStatement = std.mem.zeroInit(c.AdbcStatement, .{});

    try err.checkAdbc(c.AdbcStatementNew(&conn.conn, &stmt, conn.errPtr()));

    // NOTE: Errors at this point usually indicate user-inflicted problems,
    // however, it will up to the caller how best to handle them.
    try err.checkAdbc(c.AdbcStatementSetSqlQuery(&stmt, c_query, conn.errPtr()));

    return stmt;
}

/// Wrap AdbcStatementExecuteQuery in error handling
fn executeStatement(
    conn: *ConnectionIo,
    stmt: *c.AdbcStatement,
    stream: *c.ArrowArrayStream
) !void {
    try err.checkAdbc(c.AdbcStatementExecuteQuery(
        stmt,
        stream,
        &conn.rows_affected,
        conn.errPtr()
    ));
}

/// If SIGINT is received, set the global `cancelExecution` atomic to true
fn handleSigIntCancel(sig: posix.SIG) callconv(.c) void {
    _ = sig;
    cancelExecAtom.store(true, .release);
}

/// Cancels execution of a query if `cancelExecAtom` is set to true in a
/// different thread.
fn cancelExecution(io: Io, conn: *ConnectionIo, stmt: *c.AdbcStatement) !void {
    while (!cancelExecAtom.load(.acquire)) {
        try io.sleep(Io.Duration.fromMilliseconds(1), .real);
    }

    // We got a request for cancelation. Clean up the running query
    try err.checkAdbc(c.AdbcStatementCancel(stmt, conn.errPtr()));
}

/// Read an ArrowArrayStream into a storage buffer
pub fn readStream(
    alloc: Allocator,
    stream: *c.ArrowArrayStream,
    buffer: *ArrowStreamBuffer
) anyerror!void {
    const getSchema = stream.get_schema orelse return error.AdbcLibError;
    const getNext = stream.get_next orelse return error.AdbcLibError;

    try err.checkArrowStream(getSchema(stream, &buffer.schema));

    var batch: c.ArrowArray = std.mem.zeroInit(c.ArrowArray, .{});
    while (getNext(stream, &batch) == 0) {
        if (batch.release == null) break;

        if (!buffer.hasCapacity()) {
            if (!buffer.canResize()) {
                break;
            }
            try buffer.resize(alloc);
        }

        buffer.add(batch);
    }
}

/// Discover objects from a connection
pub fn discoverObjects(gpa: Allocator, conn: *ConnectionIo) !ConnectionCatalog {
    return .{ .items = try schema.readCatalog(gpa, conn) };

    //for (cat.items) |w| {
    //    std.debug.print("{s}\n", .{w.name});
    //    for (w.children) |x| {
    //        std.debug.print("  {s}\n", .{x.name});
    //        for (x.children) |y| {
    //            std.debug.print("    {s}\n", .{y.name});
    //            for (y.children) |z| {
    //                std.debug.print("      {s}\n", .{z.name});
    //            }
    //        }
    //    }
    //}

    //const x = try cat.tables(gpa, .{.catalog = "oil"});
    //defer gpa.free(x);
    //for (x) |t| {
    //    std.debug.print("{s}\n", .{t.name});
    //}
}


test {
    std.testing.refAllDecls(@This());
}
