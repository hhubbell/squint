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

pub const ArrowStreamBuffer = struct {
    const Self = @This();

    schema: h.c.ArrowSchema,
    items: []h.c.ArrowArray,
    err: h.c.ArrowError,
    filled: u64,
    batch_sz: []u64,

    pub fn initRows(alloc: Allocator, capacity: u64) !Self {
        // We assume that an ArrowArrayStream batch is 1024 rows. Based on the
        // number of rows we wish to consume (`until`), calculate the max number
        // of batches we could consume and allocate a buffer for the ArrowArrays.
        const assumed_batch: u64 = 1024;
        const max_batches: u64 = try std.math.divCeil(u64, capacity, assumed_batch);
        const batch_buffer: []h.c.ArrowArray = try alloc.alloc(h.c.ArrowArray, max_batches);
        const batch_sz_mon: []u64 = try alloc.alloc(u64, max_batches);

        return .{
            .schema = .{},
            .items = batch_buffer,
            .err = .{},
            .filled = 0,
            .batch_sz = batch_sz_mon};
    }

    pub fn initBuffers(alloc: Allocator, capacity: u64) !Self {
        const batch_buffer: []h.c.ArrowArray = try alloc.alloc(h.c.ArrowArray, capacity);
        const batch_sz_mon: []u64 = try alloc.alloc(u64, capacity);

        return .{
            .schema = .{},
            .items = batch_buffer,
            .err = .{},
            .filled = 0,
            .batch_sz = batch_sz_mon};
    }

    pub fn deinit(self: *Self, alloc: Allocator) void {
        alloc.free(self.items);
        alloc.free(self.batch_sz);
    }

    pub fn add(self: *Self, batch: h.c.ArrowArray) void {
        self.items[self.filled] = batch;

        self.filled += 1;
    }

    pub fn hasCapacity(self: *Self) bool {
        return self.filled < self.items.len;
    }

    pub fn setBatchSize(self: *Self, len: u64) void {
        self.batch_sz[self.filled] = len;
    }

    pub fn shrinkToFit(self: *Self, alloc: Allocator) void {
        // FIXME: Error handling?
        const res = alloc.resize(self.items, self.filled);

        std.debug.print("{any}", .{res});
    }
};


fn checkAdbcStream(rcode: c_int) !void {
    if (rcode != 0) {
        return error.AdbcStreamError;
    }
}

fn checkNanoArrow(rcode: c_int) !void {
    if (rcode != h.c.NANOARROW_OK) {
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

fn slotWidth(col: *h.c.ArrowArrayView, idx: u64) usize {
    const row: i64 = @intCast(idx);

    if (h.c.ArrowArrayViewIsNull(col, row) != 0) {
        return 4;
    }

    switch(col.storage_type) {
        h.c.NANOARROW_TYPE_STRING,
        h.c.NANOARROW_TYPE_LARGE_STRING => {
            const val = h.c.ArrowArrayViewGetStringUnsafe(col, row);
            return @intCast(val.size_bytes);
        },
        else => return 9    // <unknown>
    }

}

/// Read and format a stream into a string buffer until reaching
/// a soft limit. The stream can be consumed later to continue
/// past this limit if desired, but any data read will be unavailable.
pub fn readStream(
    conn: *db.ConnManager,
    stream: *h.c.ArrowArrayStream,
    buffer: *ArrowStreamBuffer
) anyerror!void {
    const getSchema = stream.get_schema orelse return error.AdbcLibError;
    const getNext = stream.get_next orelse return error.AdbcLibError;

    try checkAdbcStream(getSchema(stream, &buffer.schema));
    //defer { if (&buffer.schema.release) |release| release(&buffer.schema); }

    var batch: h.c.ArrowArray = .{};
    //defer { if (batch.release) |release| release(&batch); }

    conn.*.last_row_count = 0;

    while(getNext(stream, &batch) == 0 and buffer.hasCapacity()) {
        if (batch.release == null) break;

        const batch_sz: u64 = @intCast(batch.children[0].*.length);

        // Use the first column to determine batch metadata, such as row count
        conn.*.last_row_count += batch_sz;

        // Maybe rethink this. It's highly dependent on the order because
        // `add` increments the slot. Add batch sizing as part of add? Or
        // something else?
        buffer.setBatchSize(batch_sz);
        buffer.add(batch);
    }
}


pub fn renderStreamBuffer(alloc: Allocator, buffer: *ArrowStreamBuffer) ![]const u8 {

    const header = try getHeader(alloc, &buffer.schema, &buffer.err);
    defer alloc.free(header);

    var view: h.c.ArrowArrayView = .{};
    try checkNanoArrow(h.c.ArrowArrayViewInitFromSchema(&view, &buffer.schema, &buffer.err));

    for (0..buffer.filled) |i| {
        const batch = buffer.items[i];
        try checkNanoArrow(h.c.ArrowArrayViewSetArray(&view, &batch, &buffer.err));

        // Each child of the buffer is a column array
        for (0..@intCast(view.n_children)) |j| {
            const col = view.children[j];

            for (0..@intCast(col.*.length)) |k| {
                header[j].width = @max(header[j].width, slotWidth(col, k));
            }
        }
        
    }

    const head = try format.printHeader(alloc, header);
    var fmtbuf: std.ArrayList(u8) = try .initCapacity(alloc, head.len);
    defer alloc.free(head);
    defer fmtbuf.deinit(alloc);

    try fmtbuf.appendSlice(alloc, head);

    for (0..buffer.filled) |i| {
        const batch = buffer.items[i];
        try checkNanoArrow(h.c.ArrowArrayViewSetArray(&view, &batch, &buffer.err));

        for (0..buffer.batch_sz[i]) |r_i| {
            // Left side of table border
            try fmtbuf.appendSlice(alloc, format.Box.VertSep);

            for (0..@intCast(view.n_children)) |c_i| {
                const col = view.children[c_i];

                var fmt: []const u8 = undefined;
                if (h.c.ArrowArrayViewIsNull(col, @intCast(r_i)) != 0) {
                    fmt = try std.fmt.allocPrint(alloc,
                        "{[color]s}{[value]s:<[width]}{[reset]s}{[sep]s}",
                        .{
                            .color = format.GREY,
                            .value = " null",
                            .width = header[c_i].width + PAD,
                            .reset = format.RESET,
                            .sep = format.Box.VertSep});
                } else {
                    const val_str = extractValue(alloc, col, r_i);
                    defer alloc.free(val_str);

                    const pad_f = format.padValue(alloc, val_str, PAD) catch "<err>";
                    defer alloc.free(pad_f);

                    fmt = try std.fmt.allocPrint(alloc,
                        "{[value]s:<[width]}{[sep]s}",
                        .{
                            .value = pad_f,
                            .width = header[c_i].width + PAD,
                            .sep = format.Box.VertSep});
                }

                try fmtbuf.appendSlice(alloc, fmt);
                alloc.free(fmt);
            }

            try fmtbuf.appendSlice(alloc, "\n");
        }
    }

    const bot = try format.printHorizSep(alloc, header, format.HorizontalSeparator.Bottom);
    defer alloc.free(bot);
    try fmtbuf.appendSlice(alloc, bot);

    try fmtbuf.append(alloc, '\n');

    return fmtbuf.toOwnedSlice(alloc);

}


    //for (container, 0..) |*cnt, i| {
    //    for (cnt.*.items) |buf| {
    //        const buf_len: usize = @intCast(buf.length);

    //        if (i == 0) {
    //            conn.*.last_row_count += buf_len;
    //        }

    //        for (0..buf_len) |j| {
    //            header[i].width = @max(header[i].width, slotWidth(@constCast(&buf), j) + PAD);
    //        }
    //    }
    //}


//    //    var row: usize = 0;
//    for (batch_meta.items, 0..) |bsize, i| {
//        for (0..bsize) |j| {
//            for (container, 0..) |*cnt, k| {
//                const col_buf = cnt.*.items[i];
//
//                if (k == 0) try buf.appendSlice(alloc, format.Box.VertSep);
//
//                var fmt: []const u8 = undefined;
//                if (h.c.ArrowArrayViewIsNull(&col_buf, @intCast(j)) != 0) {
//                    fmt = try std.fmt.allocPrint(alloc, "{[color]s}{[value]s:<[width]}{[reset]s}{[sep]s}", .{
//                        .color = format.GREY,
//                        .value = " null",
//                        .width = header[k].width,
//                        .reset = format.RESET,
//                        .sep = format.Box.VertSep});
//                } else {
//                    //const val = h.c.ArrowArrayViewGetStringUnsafe(&col_buf, @intCast(j));
//                    //const val_len: usize = @intCast(val.size_bytes);
//                    //const val_str: []const u8 = val.data[0..val_len];
//
//                    const val_str = extractValue(alloc, @constCast(&col_buf), j);
//                    defer alloc.free(val_str);
//
//                    const pad_f = format.padValue(alloc, val_str, PAD) catch "<err>";
//                    defer alloc.free(pad_f);
//
//                    fmt = try std.fmt.allocPrint(alloc, "{[value]s:<[width]}{[sep]s}", .{
//                        .value = pad_f,
//                        .width = header[k].width,
//                        .sep = format.Box.VertSep});
//                }
//                try buf.appendSlice(alloc, fmt);
//                alloc.free(fmt);
//
//            }
//            row += 1;
//            try buf.append(alloc, '\n');
//        }
//    }
//
//    const bot = try format.printHorizSep(alloc, header, format.HorizontalSeparator.Bottom);
//    defer alloc.free(bot);
//    try buf.appendSlice(alloc, bot);
//
//    try buf.append(alloc, '\n');
//
//    return buf.toOwnedSlice(alloc);
//
//    // Debug
//    //for (header, 0..) |head, i| {
//    //    std.debug.print("{s}: {} {d} {d}\n", .{head.name, head.typeof, head.width, container[i].items.len});
//    //}
//}


