const std = @import("std");
const adbc = @import("adbc");
const c = @import("c");

const Allocator = std.mem.Allocator;
const Io = std.Io;


fn needsQuote(slot: []const u8) bool {
    for (slot) |a| {
        if (a == ',' or a == '"' or a == '\n' or a == '\r') return true;
    }

    return false;
}

pub fn write(w: *Io.Writer, gpa: Allocator, asb: *adbc.TableBuffer) !void {
    if (asb.metadata == null) {
        return error.NoResultSetError;
    }

    var maxw: usize = 0;
    for (asb.metadata.?, 0..) |col, i| {
        _ = try w.write(col.name);

        if (i < asb.countCols() - 1) _ = try w.write(",");

        maxw = @max(maxw, col.data.width);
    }

    _ = try w.write("\n");

    const backing = try gpa.alloc(u8, maxw);
    defer gpa.free(backing);

    var iter: adbc.TableBuffer.Iterator = try asb.iter(.colwise);
    while (iter.next()) |slot| {
        _ = try w.write(adbc.meta.extractValue(
            slot.meta,
            backing,
            slot.view,
            slot.row
        ));

        if (slot.col < iter.table.countCols() - 1) {
            _ = try w.write(",");
        } else {
            _ = try w.write("\n");
        }
    }
}
