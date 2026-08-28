const std = @import("std");
const adbc = @import("adbc");

const Allocator = std.mem.Allocator;
const Io = std.Io;

const Self = @This();


interface: *Io.Writer,


pub fn init(interface: *Io.Writer) Self {
    return .{ .interface = interface };
}

fn needsQuote(slot: []const u8) bool {
    for (slot) |a| {
        if (a == ',' or a == '"' or a == '\n' or a == '\r') return true;
    }

    return false;
}

/// Write a TableBuffer to an Io.Writer interface as a csv table. Requires
/// an allocator to make one allocation for a buffer as wide as the widest
/// column. Will flush.
pub fn write(
    self: Self,
    gpa: Allocator,
    asb: *adbc.TableBuffer
) !void {
    if (asb.metadata == null) {
        return error.NoResultSetError;
    }

    var maxw: usize = 0;
    for (asb.metadata.?, 0..) |col, i| {
        _ = try self.interface.write(col.name);

        if (i < asb.countCols() - 1) _ = try self.interface.write(",");

        maxw = @max(maxw, col.data.width);
    }

    _ = try self.interface.write("\n");

    const backing = try gpa.alloc(u8, maxw);
    defer gpa.free(backing);

    var iter: adbc.TableBuffer.Iterator = try asb.iter(.colwise);
    while (iter.next()) |slot| {
        _ = try self.interface.write(adbc.meta.extractValue(
            slot.meta,
            backing,
            slot.view,
            slot.row
        ));

        if (slot.col < iter.table.countCols() - 1) {
            _ = try self.interface.write(",");
        } else {
            _ = try self.interface.write("\n");
        }
    }

    try self.interface.flush();
}
