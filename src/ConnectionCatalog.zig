const std = @import("std");
const adbc = @import("adbc");
const c = @import("c");

const ConnectionIo = @import("ConnectionIo.zig");

const assert = std.debug.assert;

const Allocator = std.mem.Allocator;
const Io = std.Io;

pub const Filter = struct {
    catalog: ?[]const u8 = null,
    schema: ?[]const u8 = null,
    table: ?[]const u8 = null
};

pub const Catalog = struct {
    name: []const u8,
    children: []Schema,

    pub fn deinit(self: *@This(), gpa: Allocator) void {
        for (self.children) |*s| s.deinit(gpa);
        gpa.free(self.children);
    }
};

pub const Schema = struct {
    name: []const u8,
    children: []Table,

    pub fn deinit(self: *@This(), gpa: Allocator) void {
        for (self.children) |*s| s.deinit(gpa);
        gpa.free(self.children);
    }
};

pub const Table = struct {
    name: []const u8,
    children: []Column,

    pub fn deinit(self: *@This(), gpa: Allocator) void {
        gpa.free(self.children);
    }
};

pub const Column = struct {
    name: []const u8
};

const RefreshHandler = *const fn (s: *Self, g: Allocator, c: *ConnectionIo) anyerror!void;
const RefreshHandlerMap = std.StaticStringMap(RefreshHandler).initComptime(.{
    .{ "ADBC SQLite Driver", &refreshHandlerSqlite },
    .{ "ADBC Driver Foundry Driver for Snowflake", &refreshHandlerSnowflake }
});

const Self = @This();

pub const empty: Self = .{
    .items = &.{},
    .current_database = -1,
    .current_schema = -1
};


items: []Catalog,
current_database: i64,
current_schema: i64,


/// Initialize a ConnectionCatalog struct.
///
/// Calls to the database to get current connection option values, and also
/// loads the database catalog into a hierarchical structure.
///
/// NOTE:
/// Some drivers do not set adbc.connection.current_catalog or
/// adbc.connection.current_db_schema. In these instances, fall back to a known
/// SQLite default. This may cause issues with other drivers and needs to be
/// tested
pub fn init(gpa: Allocator, conn: *ConnectionIo) !Self {
    var self: Self = .empty;

    try self.refresh(gpa, conn);

    return self;  
}

/// Free the catalog slice and child schema/table slices
pub fn deinit(self: Self, gpa: Allocator) void {
    for (self.items) |*i| i.deinit(gpa);
    gpa.free(self.items);
}

pub fn read(
    gpa: Allocator,
    conn: *ConnectionIo,
    depth: c_int,
    filter: Filter
) ![]Catalog {
    var stream: c.ArrowArrayStream = std.mem.zeroInit(c.ArrowArrayStream, .{});

    const f_cat: [*c]const u8 = if (filter.catalog) |f| try gpa.dupeSentinel(u8, f, 0) else null;
    const f_sch: [*c]const u8 = if (filter.schema) |f| try gpa.dupeSentinel(u8, f, 0) else null;
    const f_tab: [*c]const u8 = if (filter.table) |f| try gpa.dupeSentinel(u8, f, 0) else null;

    defer {
        if (f_cat) |f| gpa.free(f[0..std.mem.len(f) + 1]);
        if (f_sch) |f| gpa.free(f[0..std.mem.len(f) + 1]);
        if (f_tab) |f| gpa.free(f[0..std.mem.len(f) + 1]);
    }

    try adbc.err.checkAdbc(c.AdbcConnectionGetObjects(&conn.conn, depth,
        f_cat, f_sch, f_tab, null, null, &stream, conn.errPtr()));
    defer if (stream.release) |release| release(&stream);

    const getSchema = stream.get_schema orelse return error.AdbcLibError;
    const getNext = stream.get_next orelse return error.AdbcLibError;

    var schema: c.ArrowSchema = std.mem.zeroInit(c.ArrowSchema, .{});

    try adbc.err.checkNanoArrowStream(getSchema(&stream, &schema));

    var a_err: c.ArrowError = std.mem.zeroInit(c.ArrowError, .{});
    var view: c.ArrowArrayView = std.mem.zeroInit(c.ArrowArrayView, .{});

    try adbc.err.checkNanoArrowStream(c.ArrowArrayViewInitFromSchema(&view, &schema, &a_err));

    var obj: std.ArrayList(Catalog) = .empty;
    defer obj.deinit(gpa);

    var batch: c.ArrowArray = std.mem.zeroInit(c.ArrowArray, .{});
    while (getNext(&stream, &batch) == 0) {
        if (batch.release == null) break;

        try adbc.err.checkNanoArrowStream(c.ArrowArrayViewSetArray(&view, &batch, &a_err));   
        const content = try readCatalogArrayList(
            Catalog,
            gpa, &view, 0, view.length);
        defer gpa.free(content);

        try obj.appendSlice(gpa, content);

        //batch.release.?(&batch);
    }
 
    return obj.toOwnedSlice(gpa);
}

fn refreshCatalogList(self: *Self, gpa: Allocator, conn: *ConnectionIo) !void {
    self.items = try read(gpa, conn,
        c.ADBC_OBJECT_DEPTH_CATALOGS,
        .{});
}

fn refreshCatalogIndex(self: *Self, gpa: Allocator, conn: *ConnectionIo) !void {
    const opt = try adbc.getOption(gpa, &conn.conn,
        c.ADBC_CONNECTION_OPTION_CURRENT_CATALOG,
        conn.errPtr()
    ) orelse return;
    defer gpa.free(opt);

    self.current_database = indexInCatalog(Catalog,
        .{ .name = opt, .children = &.{} },
        self.items);
}

fn refreshSchemaList(self: *Self, gpa: Allocator, conn: *ConnectionIo) !void {
    if (self.current_database < 0) return;
    const cat_i: usize = @intCast(self.current_database);

    const objs = try read(gpa, conn,
        c.ADBC_OBJECT_DEPTH_DB_SCHEMAS,
        .{ .catalog = self.items[cat_i].name });
    defer gpa.free(objs);
    defer for (objs) |*obj| obj.deinit(gpa);

    if (objs.len > 0) {
        // FIXME: This is fine if `schms` is always a slice of ONE catalog. If we
        // ever get a many-catalog result, this will not behave as expected.
        try insertSlice(Catalog, gpa, &self.items[cat_i], objs[0].children);
    }
}

fn refreshSchemaIndex(self: *Self, gpa: Allocator, conn: *ConnectionIo) !void {
    if (self.current_database < 0) return;
    const cat_i: usize = @intCast(self.current_database);

    const opt = try adbc.getOption(gpa, &conn.conn,
        c.ADBC_CONNECTION_OPTION_CURRENT_DB_SCHEMA,
        conn.errPtr()
    ) orelse return;
    defer gpa.free(opt);

    self.current_schema = indexInCatalog(Schema,
        .{ .name = opt, .children = &.{} },
        self.items[cat_i].children);
}

fn refreshTables(self: *Self, gpa: Allocator, conn: *ConnectionIo) !void {
    if (self.current_database < 0) return;
    if (self.current_schema < 0) return;

    const cat_i: usize = @intCast(self.current_database);
    const sch_i: usize = @intCast(self.current_schema);

    const objs = try read(gpa, conn,
        c.ADBC_OBJECT_DEPTH_TABLES,
        .{ .catalog = self.items[cat_i].name,
            .schema = self.items[cat_i].children[sch_i].name
        });
    defer gpa.free(objs);
    defer for (objs) |*obj| obj.deinit(gpa);

    if (
        objs.len > 0
        and objs[0].children.len > 0
    ) {
        try insertSlice(Schema, gpa,
            &self.items[cat_i].children[sch_i],
            objs[0].children[0].children);
    }
}

/// Refresh the current connection cache
pub fn refresh(self: *Self, gpa: Allocator, conn: *ConnectionIo) !void {
    // TODO. Should I just memoize this rather than checking each time?
    const driver = try adbc.getInfo(gpa, &conn.conn,
        c.ADBC_INFO_DRIVER_NAME,
        conn.errPtr()
    ) orelse return error.AdbcDriverError;
    defer gpa.free(driver);

    // Some drivers have slightly different behavior that needs to be taken
    // into account when checking the current catalog/schema
    const refresh_handler = RefreshHandlerMap.get(driver) orelse refreshHandlerDefault;

    try refresh_handler(self, gpa, conn);
}

fn refreshHandlerDefault(self: *Self, gpa: Allocator, conn: *ConnectionIo) !void {
    try self.refreshCatalogList(gpa, conn);
    try self.refreshCatalogIndex(gpa, conn);
    try self.refreshSchemaList(gpa, conn);
    try self.refreshSchemaIndex(gpa, conn);
    try self.refreshTables(gpa, conn);
}

/// Refresh handler for sqlite, which does not have schemas.
fn refreshHandlerSqlite(self: *Self, gpa: Allocator, conn: *ConnectionIo) !void {
    self.items = try read(gpa, conn,
        c.ADBC_OBJECT_DEPTH_ALL,
        .{});

    try self.refreshCatalogIndex(gpa, conn);

    // Refresh the schema index using the "none" fallback value
    if (self.current_database < 0) return;
    const cat_i: usize = @intCast(self.current_database);

    self.current_schema = indexInCatalog(Schema,
        .{ .name = "none", .children = &.{} },
        self.items[cat_i].children);
}

/// Refresh handler for snowflake, which may crash if CURRENT_SCHEMA() is not
/// set. As a workaround, set the CURRENT_DATABASE()/CURRENT_SCHEMA() to a
/// default value which exists in all client environments.
///
/// XXX:
/// AdbcConnectionGetOption is not behaving as expected for the snowflake
/// driver. Instead, execute queries directly to get the desired connection
/// parameters.
fn refreshHandlerSnowflake(self: *Self, gpa: Allocator, conn: *ConnectionIo) !void {
    // Catalog
    try self.refreshCatalogList(gpa, conn);

    var buf: adbc.StreamBuffer = try .init(gpa, 1);
    defer buf.deinit(gpa);

    var stream: c.ArrowArrayStream = std.mem.zeroInit(c.ArrowArrayStream, .{});
    var stmt: c.AdbcStatement = try adbc.prepareStatement(
        "select current_database()",
        &conn.conn,
        conn.errPtr());

    try adbc.executeStatement(&stmt, &stream, conn.errPtr());
    try adbc.readStream(gpa, &stream, &buf);

    var catalog = try buf.asOneString();

    // The connection profile did not specify a database, so we fallback to a
    // known database that exists for all client systems.
    if (catalog == null) {
        try adbc.err.checkAdbc(c.AdbcConnectionSetOption(&conn.conn,
            c.ADBC_CONNECTION_OPTION_CURRENT_CATALOG,
            "SNOWFLAKE",
            conn.errPtr()));

        buf.clear();
        try adbc.err.checkAdbc(c.AdbcStatementRelease(&stmt, null));

        stream = std.mem.zeroInit(c.ArrowArrayStream, .{});
        stmt = try adbc.prepareStatement(
            "select current_database()",
            &conn.conn,
            conn.errPtr());

        try adbc.executeStatement(&stmt, &stream, conn.errPtr());
        try adbc.readStream(gpa, &stream, &buf);

        catalog = try buf.asOneString();
    }

    if (catalog) |cat| {
        self.current_database = indexInCatalog(Catalog,
            .{ .name = cat, .children = &.{} },
            self.items);
    }

    // Reuse some stuff so clear it out to go again
    buf.clear();
    try adbc.err.checkAdbc(c.AdbcStatementRelease(&stmt, null));

    // Schema
    try self.refreshSchemaList(gpa, conn);

    stream = std.mem.zeroInit(c.ArrowArrayStream, .{});
    stmt = try adbc.prepareStatement(
        "select current_schema()",
        &conn.conn,
        conn.errPtr());

    try adbc.executeStatement(&stmt, &stream, conn.errPtr());
    try adbc.readStream(gpa, &stream, &buf);

    var schema = try buf.asOneString();

    // The connection profile did not specify a schema, so we fallback to a
    // known database that exists for all client systems.
    if (schema == null) {
        try adbc.err.checkAdbc(c.AdbcConnectionSetOption(&conn.conn,
            c.ADBC_CONNECTION_OPTION_CURRENT_DB_SCHEMA,
            "INFORMATION_SCHEMA",
            conn.errPtr()));

        buf.clear();
        try adbc.err.checkAdbc(c.AdbcStatementRelease(&stmt, null));

        stream = std.mem.zeroInit(c.ArrowArrayStream, .{});
        stmt = try adbc.prepareStatement(
            "select current_schema()",
            &conn.conn,
            conn.errPtr());

        try adbc.executeStatement(&stmt, &stream, conn.errPtr());
        try adbc.readStream(gpa, &stream, &buf);

        schema = try buf.asOneString();
    }

    if (self.current_database < 0) return;
    const cat_i: usize = @intCast(self.current_database);

    if (schema) |sch| {
        self.current_schema = indexInCatalog(Schema,
            .{ .name = sch, .children = &.{} },
            self.items[cat_i].children);
    }

    try self.refreshTables(gpa, conn);
}

/// Return a slice of database catalogs
pub fn catalogs(self: *Self) []Catalog {
    return self.items;
}

/// Return a slice of database schemas, optionally filtering on a catalog.
pub fn schemas(
    self: *Self,
    gpa: Allocator,
    filter: Self.Filter
) ![]Schema {
    var collector: std.ArrayList(Schema) = .empty;
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

/// Return a slice of database tables, optionally filtering on a catalog
/// and schema.
pub fn tables(
    self: *Self,
    gpa: Allocator,
    filter: Self.Filter
) ![]Table {
    var collector: std.ArrayList(Table) = .empty;
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

/// Return a slice of database catalogs, based on the connection's
/// current_catalog.
pub fn currentConnCatalog(self: *Self) !Catalog {
    if (self.current_database < 0) {
        return error.InvalidConnectionOption;
    }

    return self.items[@intCast(self.current_database)];
}

/// Return a slice of database schemas, based on the connection's
/// current_db_schema.
pub fn currentConnSchema(self: *Self) !Schema {
    if (self.current_schema < 0) {
        return error.InvalidConnectionOption;
    }

    const parent: Catalog = try self.currentConnCatalog();

    return parent.children[@intCast(self.current_schema)];
}

/// Return a slice of database tables, based on the connection's
/// current_catalog and current_db_schema.
pub fn currentConnTables(self: *Self) ![]Table {
    const parent: Schema = try self.currentConnSchema();

    return parent.children;
}

pub fn readCatalogArrayList(
    comptime T: type,
    gpa: Allocator,
    list: *c.ArrowArrayView,
    beg: i64,
    end: i64
) ![]T {
    var obj: std.ArrayList(T) = .empty;
    defer obj.deinit(gpa);

    // FIXME: Must also support list.storage_type LARGE_LIST -> as_int64
    const offsets = list.children[1].*.buffer_views[1].data.as_int32;

    for (@intCast(beg)..@intCast(end)) |i| {
        const name_val = c.ArrowArrayViewGetStringUnsafe(
            list.children[0],
            @intCast(i));
        const name_len: usize = @intCast(name_val.size_bytes);
        const name_str: []const u8 = if (name_len > 0) name_val.data[0..name_len]
            else "none";

        if (list.n_children == 0) {
            continue;
        }

        if (@hasField(T, "children")) {
            const next_list: *c.ArrowArrayView = list.children[1];

            if (next_list.n_children == 0) {
                try obj.append(gpa, T{.name = name_str, .children = &.{}});
                continue;
            }

            const next_t: type = @typeInfo(@FieldType(T, "children")).pointer.child;
            const next_children = next_list.*.children[0];

            const children: []next_t = try readCatalogArrayList(
                next_t,
                gpa,
                next_children,
                offsets[@intCast(i)],
                offsets[@intCast(i + 1)]);

            try obj.append(gpa, T{.name = name_str, .children = children});
        } else {
            try obj.append(gpa, T{.name = name_str});
        }
    }

    return try obj.toOwnedSlice(gpa);
}

// Checks if an item of a  catalog type exists in the connection catalog
fn existsInCatalog(comptime T: type, needle: T, haystack: []T) bool {
    return indexInCatalog(T, needle, haystack) >= 0;
}

fn indexInCatalog(comptime T: type, needle: T, haystack: []T) i64 {
    for (haystack, 0..) |hay, i| {
        if (std.mem.eql(u8, needle.name, hay.name)) return @intCast(i);
    }

    return -1;
}

pub fn insertSlice(
    comptime T: type,
    gpa: Allocator,
    obj: *T,
    children: @FieldType(T, "children")
) !void {
    // Is this necessary if the function signature mandates children's type?
    assert(@hasField(T, "children"));

    // FIXME: Can we optimize this?

    const ex_len: usize = obj.children.len;
    const child_T: type = @typeInfo(@FieldType(T, "children")).pointer.child;

    // First check the possible number of NEW children so we can realloc
    // our children buffer
    var counter: usize = 0;
    for (children) |child| {
        counter += @intFromBool(!existsInCatalog(
            child_T,
            child,
            obj.children));
    }

    if (counter > 0) {
        obj.children = try gpa.realloc(
            obj.children,
            obj.children.len + counter
        );

        const new_len: usize = obj.children.len;
        for (ex_len..new_len) |i| {
            obj.children[i] = std.mem.zeroInit(child_T, .{});
        }
    }

    var open_block: usize = ex_len;
    for (children) |child| {
        const i: i64 = indexInCatalog(child_T, child, obj.children);

        if (i < 0) {
            obj.children[open_block] = child;
            open_block += 1;
        } else {
            //gpa.free(obj.children[@intCast(i)]);
            obj.children[@intCast(i)] = child;
        }
    }
}
