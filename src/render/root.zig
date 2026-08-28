//! NOTE: This is not a module currently, but it could be. We need to
//! confirm what the dependencies are, and whether it makes sense to
//! keep this code isolated.
const std = @import("std");
const adbc = @import("adbc");

const Allocator = std.mem.Allocator;
const Io = std.Io;

pub const Color = @import("Color.zig");
pub const Shape = @import("Shape.zig");

const CsvWriter = @import("CsvWriter.zig");
const FixedBufferTableWriter = @import("FixedBufferTableWriter.zig");
const StreamingTableWriter = @import("StreamingTableWriter.zig");


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
