const std = @import("std");
const c = @import("c");

const root = @import("root.zig");

const Allocator = std.mem.Allocator;
const ConnectionIo = root.ConnectionIo;

const Self = @This();

const Filter = struct {
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
current_database: []const u8,
current_schema: []const u8,


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
    const db = try root.getOption(
        gpa,
        conn,
        c.ADBC_CONNECTION_OPTION_CURRENT_CATALOG
    ) orelse try gpa.dupe(u8, "main");

    const sch = try root.getOption(
        gpa,
        conn,
        c.ADBC_CONNECTION_OPTION_CURRENT_DB_SCHEMA
    ) orelse try gpa.dupe(u8, "none");

    return .{
        .items = try root.readCatalog(gpa, conn),
        .current_database = db,
        .current_schema = sch
    };  
}

/// Free the catalog slice and child schema/table slices
pub fn deinit(self: Self, gpa: Allocator) void {
    for (self.items) |*i| i.deinit(gpa);
    gpa.free(self.items);

    gpa.free(self.current_database);
    gpa.free(self.current_schema);
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
    for (self.items) |obj| {
        if (std.mem.eql(u8, obj.name, self.current_database)) {
            return obj;
        }
    }

    return error.InvalidConnectionOption;
}

/// Return a slice of database schemas, based on the connection's
/// current_db_schema.
pub fn currentConnSchema(self: *Self) !Schema {
    const parent: Catalog = try self.currentConnCatalog();

    for (parent.children) |obj| {
        if (std.mem.eql(u8, obj.name, self.current_schema)) {
            return obj;
        }
    }

    return error.InvalidConnectionOption;
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
