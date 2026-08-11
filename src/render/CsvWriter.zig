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

pub fn write(w: *Io.Writer, gpa: Allocator, asb: *adbc.ArrowStreamBuffer) !void {
    var maxw: usize = 0;
    for (asb.metadata.?, 0..) |col, i| {
        _ = try w.write(col.name);

        if (i < asb.metadata.?.len - 1) _ = try w.write(",");

        maxw = @max(maxw, col.width);
    }

    _ = try w.write("\n");

    const backing = try gpa.alloc(u8, maxw);
    defer gpa.free(backing);

    for (0..asb.filled) |i| {
        var view = try asb.asArrayView(i);
        defer _ = c.ArrowArrayViewReset(&view);

        for (0..asb.countBatchRows(i)) |r_i| {
            for (0..@intCast(view.n_children)) |c_i| {
                const col = view.children[c_i];

                if (!adbc.meta.isNull(col, r_i)) {
                    const val_str = adbc.meta.extractValue(
                        &asb.metadata.?[c_i],
                        backing,
                        col,
                        r_i);
                    _ = try w.write(val_str);
                }
                if (c_i < view.n_children - 1) _ = try w.write(",");
            }
            _ = try w.write("\n");
        }
    }
}
