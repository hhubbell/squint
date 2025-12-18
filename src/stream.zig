const std = @import("std");
const h = @import("cheaders.zig");
const db = @import("db.zig");
const format = @import("format.zig");

const Allocator = std.mem.Allocator;


pub const ColMetadata = struct {
    const Self = @This();

    name: []const u8,
    width: usize,
    bytes: usize,
    color_slots: usize,
    typeof: h.c.ArrowType,
    // Decimal data
    decimal_width: ?i32,
    decimal_precision: ?i32,
    decimal_scale: ?i32
};

pub const ArrowStreamBuffer = struct {
    const Self = @This();

    schema: h.c.ArrowSchema,
    items: []h.c.ArrowArray,
    err: h.c.ArrowError,
    filled: u64,
    batch_sz: []u64,
    metadata: ?[]ColMetadata = null,

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

        if (self.metadata != null) alloc.free(self.metadata.?);
    }

    pub fn add(self: *Self, batch: h.c.ArrowArray) void {
        self.items[self.filled] = batch;

        self.filled += 1;
    }

    pub fn countRows(self: *Self) u64 {
        var accum: u64 = 0;

        for (0..self.filled) |i| {
            accum += self.batch_sz[i];
        }

        return accum;
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

pub fn checkNanoArrow(rcode: c_int) !void {
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

        // Store the decimal storage width if we are dealing with a DECIMAL
        const dec_width: ?i32 = switch(view.storage_type) {
            h.c.NANOARROW_TYPE_DECIMAL32 => 32,
            h.c.NANOARROW_TYPE_DECIMAL64 => 64,
            h.c.NANOARROW_TYPE_DECIMAL128 => 128,
            h.c.NANOARROW_TYPE_DECIMAL256 => 256,
            else => null
        };

        result[i] = .{
            .name = name,
            .width = name.len,
            .bytes = name.len,
            .color_slots = 0,
            .typeof = view.type,
            .decimal_width = dec_width,
            .decimal_precision = view.decimal_precision,
            .decimal_scale = view.decimal_scale};
    }

    return result;
}

/// FIXME Cannot handle all data types
pub fn extractValue(
    meta: *ColMetadata,
    buf: []u8,
    view: *h.c.ArrowArrayView,
    idx: usize
) []const u8 {
    const row: i64 = @intCast(idx);

    if (h.c.ArrowArrayViewIsNull(view, row) != 0) {
        return "null";
    }

    switch (view.storage_type) {
        h.c.NANOARROW_TYPE_INT8,
        h.c.NANOARROW_TYPE_INT16,
        h.c.NANOARROW_TYPE_INT32,
        h.c.NANOARROW_TYPE_INT64,
        h.c.NANOARROW_TYPE_DATE32,
        h.c.NANOARROW_TYPE_DATE64,
        h.c.NANOARROW_TYPE_TIMESTAMP => {
            const val = h.c.ArrowArrayViewGetIntUnsafe(view, row);
            return std.fmt.bufPrint(buf, "{d}", .{val}) catch "<err>";
        },
        h.c.NANOARROW_TYPE_UINT8,
        h.c.NANOARROW_TYPE_UINT16,
        h.c.NANOARROW_TYPE_UINT32,
        h.c.NANOARROW_TYPE_UINT64 => {
            const val = h.c.ArrowArrayViewGetUIntUnsafe(view, row);
            return std.fmt.bufPrint(buf, "{d}", .{val}) catch "<err>";
        },
        // XXX: Will not work until translate-c bug fixed
        //h.c.NANOARROW_TYPE_FLOAT,
        //h.c.NANOARROW_TYPE_DOUBLE => {
        //    const val = h.c.ArrowArrayViewGetDoubleUnsafe(view, row);
        //    return std.fmt.bufPrint(buf, "{d:.4}", .{val}) catch "<err>";
        //},
        h.c.NANOARROW_TYPE_BOOL => {
            const val = h.c.ArrowArrayViewGetIntUnsafe(view, row);
            return std.fmt.bufPrint(buf, "{d}", .{val}) catch "<err>";
        },
        h.c.NANOARROW_TYPE_STRING,
        h.c.NANOARROW_TYPE_LARGE_STRING => {
            const val = h.c.ArrowArrayViewGetStringUnsafe(view, row);
            const val_len: usize = @intCast(val.size_bytes);
            const val_str: []const u8 = val.data[0..val_len];
            return std.fmt.bufPrint(buf, "{s}", .{val_str}) catch "<err>";
        },
        //h.c.NANOARROW_TYPE_BINAR,
        //h.c.NANOARROW_TYPE_LARGE_BINARY => {
        //    const val = h.c.ArrowArrayViewGetBytesUnsafe(view, row);
        //    const val_len: usize = @intCast(val.size_bytes);
        //    const val_str: []const u8 = val.data[0..val_len];
        //    return val_str;
        //},
        h.c.NANOARROW_TYPE_DECIMAL32,
        h.c.NANOARROW_TYPE_DECIMAL64,
        h.c.NANOARROW_TYPE_DECIMAL128,
        h.c.NANOARROW_TYPE_DECIMAL256 => {
            var dec: h.c.ArrowDecimal = .{};
            h.c.ArrowDecimalInit(&dec,
                meta.decimal_width.?,
                meta.decimal_precision.?,
                meta.decimal_scale.?);

            var val: h.c.ArrowBuffer = .{};
            h.c.ArrowBufferInit(&val);

            h.c.ArrowArrayViewGetDecimalUnsafe(view, row, &dec);

            // FIXME:
            //  1. Error handling
            //  2. How many allocations does this make?
            //try checkNanoArrow(h.c.ArrowDecimalAppendDigitsToBuffer(&dec, &val));
            _ = h.c.ArrowDecimalAppendDigitsToBuffer(&dec, &val);

            const val_len: usize = @intCast(val.size_bytes);
            const val_str: []const u8 = val.data[0..val_len];
            return std.fmt.bufPrint(buf, "{s}", .{val_str}) catch "<err>";


        },
        else => return "<unknown>"
    }
}

/// Implement ArrowDecimalGetBytes in place of the NanoArrow library because
/// tranlate-c is breaking the implementation.
fn _tmpArrowDecimalGetBytes(decimal: *h.c.ArrowDecimal, buf: []u8) void {

    if (decimal.*.n_words == 0) {
        @memcpy(buf, decimal.*.words); // @sizeOf(i32));
    } else {
        @memcpy(buf, decimal.*.words); // decimal.*.n_words * @sizeOf(u64));
    }
}

/// Determine if an ArrowArray Slot is a null value
pub fn isNull(col: *h.c.ArrowArrayView, idx: u64) bool {
    const row: i64 = @intCast(idx);

    return h.c.ArrowArrayViewIsNull(col, row) != 0;
}

/// Determine if an ArrowArray is numeric
pub fn isNumeric(col: *h.c.ArrowArrayView) bool {
    switch (col.storage_type) {
        h.c.NANOARROW_TYPE_INT8,
        h.c.NANOARROW_TYPE_INT16,
        h.c.NANOARROW_TYPE_INT32,
        h.c.NANOARROW_TYPE_INT64,
        h.c.NANOARROW_TYPE_DATE32,
        h.c.NANOARROW_TYPE_DATE64,
        h.c.NANOARROW_TYPE_TIMESTAMP,
        h.c.NANOARROW_TYPE_UINT8,
        h.c.NANOARROW_TYPE_UINT16,
        h.c.NANOARROW_TYPE_UINT32,
        h.c.NANOARROW_TYPE_UINT64,
        h.c.NANOARROW_TYPE_FLOAT,
        h.c.NANOARROW_TYPE_DOUBLE,
        h.c.NANOARROW_TYPE_DECIMAL32,
        h.c.NANOARROW_TYPE_DECIMAL64,
        h.c.NANOARROW_TYPE_DECIMAL128,
        h.c.NANOARROW_TYPE_DECIMAL256 => return true,
        else => return false
    }
}

/// FIXME Cannot handle all data types
fn slotWidth(meta: *ColMetadata, col: *h.c.ArrowArrayView, idx: u64) usize {
    const row: i64 = @intCast(idx);

    if (isNull(col, idx)) {
        return comptime "null".len;
    }

    var buf: [64]u8 = undefined;

    switch (col.storage_type) {
        h.c.NANOARROW_TYPE_INT8,
        h.c.NANOARROW_TYPE_INT16,
        h.c.NANOARROW_TYPE_INT32,
        h.c.NANOARROW_TYPE_INT64,
        h.c.NANOARROW_TYPE_DATE32,
        h.c.NANOARROW_TYPE_DATE64,
        h.c.NANOARROW_TYPE_TIMESTAMP => {
            const val: i64 = h.c.ArrowArrayViewGetIntUnsafe(col, row);
            const str = std.fmt.bufPrint(&buf, "{d}", .{val}) catch "<err>";
            return str.len;
        },
        h.c.NANOARROW_TYPE_UINT8,
        h.c.NANOARROW_TYPE_UINT16,
        h.c.NANOARROW_TYPE_UINT32,
        h.c.NANOARROW_TYPE_UINT64 => {
            const val: u64 = h.c.ArrowArrayViewGetUIntUnsafe(col, row);
            const str = std.fmt.bufPrint(&buf, "{d}", .{val}) catch "<err>";
            return str.len;
        },
        // XXX: Will not work until translate-c bug fixed
        //h.c.NANOARROW_TYPE_FLOAT,
        //h.c.NANOARROW_TYPE_DOUBLE => {
        //    const val: f128 = h.c.ArrowArrayViewGetDoubleUnsafe(col, row);
        //    const str = std.fmt.bufPrint(&buf, "{d:.4}", .{val}) catch "<err>";
        //    return str.len;
        //},
        h.c.NANOARROW_TYPE_BOOL => {
            const val: i64 = h.c.ArrowArrayViewGetIntUnsafe(col, row);
            const str = std.fmt.bufPrint(&buf, "{d}", .{val}) catch "<err>";
            return str.len;
        },
        h.c.NANOARROW_TYPE_STRING,
        h.c.NANOARROW_TYPE_LARGE_STRING => {
            const val = h.c.ArrowArrayViewGetStringUnsafe(col, row);
            return @intCast(val.size_bytes);
        },
        h.c.NANOARROW_TYPE_DECIMAL32,
        h.c.NANOARROW_TYPE_DECIMAL64,
        h.c.NANOARROW_TYPE_DECIMAL128,
        h.c.NANOARROW_TYPE_DECIMAL256 => {
            var dec: h.c.ArrowDecimal = .{};
            h.c.ArrowDecimalInit(&dec,
                meta.decimal_width.?,
                meta.decimal_precision.?,
                meta.decimal_scale.?);

            var val: h.c.ArrowBuffer = .{};
            h.c.ArrowBufferInit(&val);

            h.c.ArrowArrayViewGetDecimalUnsafe(col, row, &dec);

            // FIXME:
            //  1. Error handling
            //  2. How many allocations does this make?
            //try checkNanoArrow(h.c.ArrowDecimalAppendDigitsToBuffer(&dec, &val));
            _ = h.c.ArrowDecimalAppendDigitsToBuffer(&dec, &val);

            return @intCast(val.size_bytes);
        },
        else => return 9    // <unknown>
    }
}

/// Basically useless at this point
///
/// DEPRECATED
fn byteWidth(meta: *ColMetadata, col: *h.c.ArrowArrayView, idx: u64) usize {
    //const row: i64 = @intCast(idx);

    // This only makes sense if we ever color an entire column. adding
    // the extra bytes for values in a column gets weird when some values
    // are colorable and some not. Nulls are the example. 
    //
    // We'll fix it later
    const color: usize = 0;

    //if (isNull(col, row)) {
    //    color = format.GREY.len + format.RESET.len;
    //}

    return slotWidth(meta, col, idx) + color;
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

    while (getNext(stream, &batch) == 0 and buffer.hasCapacity()) {
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

/// Generate a slice of ColMetadata
pub fn calcColumnMetadata(alloc: Allocator, buffer: *ArrowStreamBuffer) ![]ColMetadata {
    const header = try getHeader(alloc, &buffer.schema, &buffer.err);

    var view: h.c.ArrowArrayView = .{};
    try checkNanoArrow(h.c.ArrowArrayViewInitFromSchema(&view, &buffer.schema, &buffer.err));

    for (0..buffer.filled) |i| {
        const batch = buffer.items[i];
        try checkNanoArrow(h.c.ArrowArrayViewSetArray(&view, &batch, &buffer.err));

        // Each child of the buffer is a column array
        for (0..@intCast(view.n_children)) |j| {
            const col = view.children[j];

            for (0..@intCast(col.*.length)) |k| {
                header[j].width = @max(header[j].width, slotWidth(&header[j], col, k));
                header[j].bytes = @max(header[j].bytes, byteWidth(&header[j], col, k));
                header[j].color_slots += @intFromBool(isNull(col, k));
            }
        }
    }

    return header;
}

