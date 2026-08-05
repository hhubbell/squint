const std = @import("std");
const c = @import("c");

const err = @import("err.zig");
const root = @import("root.zig");

const Allocator = std.mem.Allocator;


pub const Catalog = struct {
    const Self = @This();

    name: []const u8,
    children: []Schema,

    pub fn deinit(self: *Self, gpa: Allocator) void {
        for (self.children) |*s| s.deinit(gpa);
        gpa.free(self.children);
    }
};

pub const Schema = struct {
    const Self = @This();

    name: []const u8,
    children: []Table,

    pub fn deinit(self: *Self, gpa: Allocator) void {
        for (self.children) |*s| s.deinit(gpa);
        gpa.free(self.children);
    }
};

pub const Table = struct {
    const Self = @This();

    name: []const u8,
    children: []Column,

    pub fn deinit(self: *Self, gpa: Allocator) void {
        gpa.free(self.children);
    }
};

pub const Column = struct {
    name: []const u8
};


pub fn readCatalog(
    gpa: Allocator,
    conn: *root.ConnectionIo
) ![]Catalog {
    var stream: c.ArrowArrayStream = std.mem.zeroInit(c.ArrowArrayStream, .{});

    try err.checkAdbc(c.AdbcConnectionGetObjects(&conn.conn,
        c.ADBC_OBJECT_DEPTH_ALL, null, null, null, null, null,
        &stream, conn.errPtr()));
    defer if (stream.release) |release| release(&stream);

    const getSchema = stream.get_schema orelse return error.AdbcLibError;
    const getNext = stream.get_next orelse return error.AdbcLibError;

    var schema: c.ArrowSchema = std.mem.zeroInit(c.ArrowSchema, .{});

    try err.checkArrowStream(getSchema(&stream, &schema));

    var a_err: c.ArrowError = std.mem.zeroInit(c.ArrowError, .{});
    var view: c.ArrowArrayView = std.mem.zeroInit(c.ArrowArrayView, .{});

    try err.checkArrowStream(c.ArrowArrayViewInitFromSchema(&view, &schema, &a_err));

    var obj: std.ArrayList(Catalog) = .empty;
    defer obj.deinit(gpa);

    var batch: c.ArrowArray = std.mem.zeroInit(c.ArrowArray, .{});
    while (getNext(&stream, &batch) == 0) {
        if (batch.release == null) break;

        try err.checkArrowStream(c.ArrowArrayViewSetArray(&view, &batch, &a_err));   
        const content = try readList(Catalog, gpa, &view, 0, view.length);
        defer gpa.free(content);

        try obj.appendSlice(gpa, content);
    }
 
    return obj.toOwnedSlice(gpa);
}

fn readList(
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

            const children: []next_t = try readList(
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
