//! NOTE: This is not a module currently, but it could be. We need to
//! confirm what the dependencies are, and whether it makes sense to
//! keep this code isolated.
const std = @import("std");
const adbc = @import("adbc");

pub const Color = @import("Color.zig");
pub const Shape = @import("Shape.zig");

const CsvWriter = @import("CsvWriter.zig");
const FixedBufferTableWriter = @import("FixedBufferTableWriter.zig");
const StreamingTableWriter = @import("StreamingTableWriter.zig");

const Allocator = std.mem.Allocator;
const Io = std.Io;

const assert = std.debug.assert;


pub const WriterType = enum {
    csv, ftable, table
};

pub const TableWriter = union(WriterType) {
    csv: CsvWriter,
    ftable: FixedBufferTableWriter,
    table: StreamingTableWriter,

    pub fn write(
        self: @This(),
        gpa: Allocator,
        asb: *adbc.TableBuffer
    ) !void {
        switch(self) {
            inline else => |t| return try t.write(gpa, asb)
        }
    }
};


pub fn fromWriterType(t: WriterType, iface: *Io.Writer) TableWriter {
    return switch(t) {
        .csv => TableWriter{ .csv = CsvWriter.init(iface) },
        .ftable => TableWriter{ .ftable = FixedBufferTableWriter.init(iface) },
        .table => TableWriter{ .table = StreamingTableWriter.init(iface) }
    };
}

/// Render a heirarchical structure as a tree. This function expects the
/// structure to have at least fields that represent the "name" and "children."
/// The field containing the child nodes should be a slice of T.
pub fn tree(
    comptime T: type,
    writer: *Io.Writer,
    gpa: Allocator,
    nodes: []T,
    comptime name_field: []const u8,
    comptime child_field: []const u8,
    leader: []const u8
) !void {
    assert(@hasField(T, name_field));
    assert(@hasField(T, child_field));

    for (nodes, 0..) |node, i| {
        const node_name = @field(node, name_field);
        const children = @field(node, child_field);

        const shape = if (i == nodes.len - 1) Shape.Box.LBotCor else Shape.Box.LJunc;

        const color:?[]const u8 = null;
        if (color) |clr| {
            try writer.print("{s}{s}{s} {s}{s}{s}\n", .{
                leader, shape, Shape.Tree.Leaf, clr, node_name, Color.Reset
            });
        } else {
            try writer.print("{s}{s}{s} {s}\n", .{
                leader, shape, Shape.Tree.Leaf, node_name
            });
        }

        if (children.len > 0) {
            const nextl = try std.mem.concat(gpa, u8, &.{
                leader,
                if (i == nodes.len - 1) Shape.Tree.Blank else Shape.Tree.Branch
            });
            defer gpa.free(nextl);

            try tree(T, writer, gpa, children, name_field, child_field, nextl);
        }
    }
}
