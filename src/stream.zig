const std = @import("std");
const h = @import("cheaders.zig");
const db = @import("db.zig");
const format = @import("format.zig");

const Allocator = std.mem.Allocator;

const PAD: usize = 2; //FIXME

pub const ColMetadata = struct {
    const Self = @This();

    name: []const u8,
    width: usize,
    typeof: h.c.ArrowType
};


fn checkAdbcStream(rcode: c_int) !void {
    if (rcode != 0) {
        return error.AdbcStreamError;
    }
}

fn checkNanoArrow(rcode: c_int) !void {
    if (rcode != h.c.NANOARROW_OK) {
        //err: *h.c.ArrowError
        //std.debug.print("{s}\n", .{err.message});

        return error.AdbcNanoArrowError;
    }
}

fn getHeader(
    alloc: Allocator,
    schema: *h.c.ArrowSchema,
    err: *h.c.ArrowError
) ![]ColMetadata {
    const n: usize = @intCast(schema.n_children);

    var result: []ColMetadata = try alloc.alloc(ColMetadata, n);
    var view: h.c.ArrowSchemaView = .{};

    for (0..n) |i| {
        const col: *h.c.ArrowSchema = schema.children[i];
        const name: []const u8 = if (col.*.name) |s| std.mem.span(s) else "column";

        try checkNanoArrow(h.c.ArrowSchemaViewInit(&view, col, err));

        result[i] = .{ .name = name, .width = name.len + PAD, .typeof = view.type };
    }

    return result;
}

fn extractValue(
    alloc: Allocator,
    view: *h.c.ArrowArrayView,
    idx: usize
) []const u8 {
    const row: i64 = @intCast(idx);

    if (h.c.ArrowArrayViewIsNull(view, row) != 0) {
        return "null";
    }

    switch(view.storage_type) {
        h.c.NANOARROW_TYPE_INT8,
        h.c.NANOARROW_TYPE_INT16,
        h.c.NANOARROW_TYPE_INT32,
        h.c.NANOARROW_TYPE_INT64,
        h.c.NANOARROW_TYPE_DATE32,
        h.c.NANOARROW_TYPE_DATE64,
        h.c.NANOARROW_TYPE_TIMESTAMP => {
            const val = h.c.ArrowArrayViewGetIntUnsafe(view, row);
            return std.fmt.allocPrint(alloc, "{d}", .{val}) catch "<err>";
        },
        h.c.NANOARROW_TYPE_UINT8,
        h.c.NANOARROW_TYPE_UINT16,
        h.c.NANOARROW_TYPE_UINT32,
        h.c.NANOARROW_TYPE_UINT64 => {
            const val = h.c.ArrowArrayViewGetUIntUnsafe(view, row);
            return std.fmt.allocPrint(alloc, "{d}", .{val}) catch "<err>";
        },
        //h.c.NANOARROW_TYPE_FLOAT,
        //h.c.NANOARROW_TYPE_DOUBLE => {
        //    const val = h.c.ArrowArrayViewGetDoubleUnsafe(view, row);
        //    return std.fmt.allocPrint(alloc, "{d:.5}", .{val}) catch "<err>";
        //},
        h.c.NANOARROW_TYPE_BOOL => {
            const val = h.c.ArrowArrayViewGetIntUnsafe(view, row);
            return std.fmt.allocPrint(alloc, "{d}", .{val}) catch "<err>";
        },
        h.c.NANOARROW_TYPE_STRING,
        h.c.NANOARROW_TYPE_LARGE_STRING => {
            const val = h.c.ArrowArrayViewGetStringUnsafe(view, row);
            const val_len: usize = @intCast(val.size_bytes);
            const val_str: []const u8 = val.data[0..val_len];
            //return val_str;
            return std.fmt.allocPrint(alloc, "{s}", .{val_str}) catch "<err>";
        },
        //h.c.NANOARROW_TYPE_BINARY,
        //h.c.NANOARROW_TYPE_LARGE_BINARY => {
        //    const val = h.c.ArrowArrayViewGetBytesUnsafe(view, row);
        //    const val_len: usize = @intCast(val.size_bytes);
        //    const val_str: []const u8 = val.data[0..val_len];
        //    return val_str;
        //},
        else => return std.fmt.allocPrint(alloc, "<unknown>", .{}) catch "<err>"
    }
}

fn slotWidth(view: *h.c.ArrowArrayView, idx: usize) usize {
    const row: i64 = @intCast(idx);

    if (h.c.ArrowArrayViewIsNull(view, row) != 0) {
        return 4;
    }

    switch(view.storage_type) {
        h.c.NANOARROW_TYPE_STRING,
        h.c.NANOARROW_TYPE_LARGE_STRING => {
            const val = h.c.ArrowArrayViewGetStringUnsafe(view, row);
            return @intCast(val.size_bytes);
        },
        else => return 9    // <unknown>
    }

}

pub fn readStream(
    alloc: Allocator,
    conn: *db.ConnManager,
    stream: *h.c.ArrowArrayStream
) ![]const u8 {
    const getSchema = stream.get_schema orelse return error.AdbcLibError;
    const getNext = stream.get_next orelse return error.AdbcLibError;

    var err: h.c.ArrowError = .{};

    var schema: h.c.ArrowSchema = .{};
    defer { if (schema.release) |release| release(&schema); }
    try checkAdbcStream(getSchema(stream, &schema));
    
    const header = try getHeader(alloc, &schema, &err);
    defer alloc.free(header);

    var batch: h.c.ArrowArray = .{};
    defer { if (batch.release) |release| release(&batch); }

    // Move this somewhere e.g. a struct or something. The goal here is really
    // to flatten the batched columns into single column structures. Idk over
    // thinking it
    var container: []std.ArrayList(h.c.ArrowArrayView) = try alloc.alloc(std.ArrayList(h.c.ArrowArrayView), header.len);

    for (container) |*cnt| {
        cnt.* = .empty;
    }

    defer alloc.free(container);
    defer { for (container) |*cnt| cnt.*.deinit(alloc); }

    // Read stream in batches
    var batch_meta: std.ArrayList(usize) = .empty;
    defer batch_meta.deinit(alloc);
    while (getNext(stream, &batch) == 0) {
        if (batch.release == null) break;

        for (0..header.len) |i| {
            const col: h.c.ArrowArray = batch.children[i].*;
            var view: h.c.ArrowArrayView = .{};
            h.c.ArrowArrayViewInitFromType(&view, header[i].typeof);
            try checkNanoArrow(h.c.ArrowArrayViewSetArray(&view, &col, &err));

            try container[i].append(alloc, view);
        }

        try batch_meta.append(alloc, @intCast(batch.length));
    }

    conn.*.last_row_count = 0;
    for (container, 0..) |*cnt, i| {
        for (cnt.*.items) |buf| {
            const buf_len: usize = @intCast(buf.length);

            if (i == 0) {
                conn.*.last_row_count += buf_len;
            }

            for (0..buf_len) |j| {
                header[i].width = @max(header[i].width, slotWidth(@constCast(&buf), j) + PAD);
            }
        }
    }


    const head = try format.printHeader(alloc, header);
    var buf: std.ArrayList(u8) = try .initCapacity(alloc, head.len);
    defer alloc.free(head);
    defer buf.deinit(alloc);

    try buf.appendSlice(alloc, head);

    var row: usize = 0;
    for (batch_meta.items, 0..) |bsize, i| {
        for (0..bsize) |j| {
            for (container, 0..) |*cnt, k| {
                const col_buf = cnt.*.items[i];

                if (k == 0) try buf.appendSlice(alloc, format.Box.VertSep);

                var fmt: []const u8 = undefined;
                if (h.c.ArrowArrayViewIsNull(&col_buf, @intCast(j)) != 0) {
                    fmt = try std.fmt.allocPrint(alloc, "{[color]s}{[value]s:<[width]}{[reset]s}{[sep]s}", .{
                        .color = format.GREY,
                        .value = " null",
                        .width = header[k].width,
                        .reset = format.RESET,
                        .sep = format.Box.VertSep});
                } else {
                    //const val = h.c.ArrowArrayViewGetStringUnsafe(&col_buf, @intCast(j));
                    //const val_len: usize = @intCast(val.size_bytes);
                    //const val_str: []const u8 = val.data[0..val_len];

                    const val_str = extractValue(alloc, @constCast(&col_buf), j);
                    defer alloc.free(val_str);

                    const pad_f = format.padValue(alloc, val_str, PAD) catch "<err>";
                    defer alloc.free(pad_f);

                    fmt = try std.fmt.allocPrint(alloc, "{[value]s:<[width]}{[sep]s}", .{
                        .value = pad_f,
                        .width = header[k].width,
                        .sep = format.Box.VertSep});
                }
                try buf.appendSlice(alloc, fmt);
                alloc.free(fmt);

            }
            row += 1;
            try buf.append(alloc, '\n');
        }
    }

    const bot = try format.printHorizSep(alloc, header, format.HorizontalSeparator.Bottom);
    defer alloc.free(bot);
    try buf.appendSlice(alloc, bot);

    try buf.append(alloc, '\n');

    return buf.toOwnedSlice(alloc);

    // Debug
    //for (header, 0..) |head, i| {
    //    std.debug.print("{s}: {} {d} {d}\n", .{head.name, head.typeof, head.width, container[i].items.len});
    //}
}


