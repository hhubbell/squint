const std = @import("std");
const c = @import("c");

const root = @import("root.zig");

const assert = std.debug.assert;

const Allocator = std.mem.Allocator;
const ConnectionIo = root.ConnectionIo;

const Self = @This();

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
    var self: Self = .{
        .items = try root.readCatalog(gpa, conn,
            c.ADBC_OBJECT_DEPTH_CATALOGS, .{}),
        .current_database = -1,
        .current_schema = -1
    };

    try self.refresh(gpa, conn);

    return self;  
}

/// Free the catalog slice and child schema/table slices
pub fn deinit(self: Self, gpa: Allocator) void {
    for (self.items) |*i| i.deinit(gpa);
    gpa.free(self.items);
}

/// Refresh the current connection cache
pub fn refresh(self: *Self, gpa: Allocator, conn: *ConnectionIo) !void {
    const cur_cat = try root.getOption(gpa, conn,
        c.ADBC_CONNECTION_OPTION_CURRENT_CATALOG
    ) orelse try gpa.dupe(u8, "main");
    defer gpa.free(cur_cat);

    self.current_database = indexInCatalog(Catalog,
        .{ .name = cur_cat, .children = &.{} },
        self.items);

    // If we failed to set a database index for whatever reason, perhaps
    // the connection does not specify it, return early and do not do any
    // analysis of catalog schemas.
    if (self.current_database < 0) {
        return;
    }

    const cat_i: usize = @intCast(self.current_database);

    const schms = try root.readCatalog(gpa, conn,
        c.ADBC_OBJECT_DEPTH_DB_SCHEMAS,
        .{ .catalog = cur_cat });
    defer gpa.free(schms);
    defer for (schms) |*obj| obj.deinit(gpa);

    const cur_sch = try root.getOption(gpa, conn,
        c.ADBC_CONNECTION_OPTION_CURRENT_DB_SCHEMA
    ) orelse try gpa.dupe(u8, "none");
    defer gpa.free(cur_sch);

    // FIXME: This is fine if `schms` is always a slice of ONE catalog. If we
    // ever get a many-catalog result, this will not behave as expected.
    try insertSlice(Catalog, gpa, &self.items[cat_i], schms[0].children);

    self.current_schema = indexInCatalog(Schema,
        .{ .name = cur_sch, .children = &.{} },
        self.items[cat_i].children);

    // If we fail to set a schema index for whatever reason, return early
    if (self.current_schema < 0) {
        return;
    }

    const sch_i: usize = @intCast(self.current_schema);

    const tabls = try root.readCatalog(gpa, conn,
        c.ADBC_OBJECT_DEPTH_TABLES,
        .{ .catalog = cur_cat, .schema = cur_sch });
    defer gpa.free(tabls); 
    defer for (tabls) |*obj| obj.deinit(gpa);

    // FIXME: This is fine if `tbls` is always a slice of ONE catalog and
    // ONE schema. If we ever get a many-catalog or many-schema result, this
    // will not behave as expected.
    try insertSlice(Schema, gpa,
        &self.items[cat_i].children[sch_i],
        tabls[0].children[0].children);
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
