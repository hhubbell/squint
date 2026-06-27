const std = @import("std");
const c = @import("c");
const db = @import("db.zig");
const format = @import("format.zig");

const Allocator = std.mem.Allocator;
const Io = std.Io;


pub const ColMetadata = struct {
    const Self = @This();

    name: []const u8,
    width: usize,
    bytes: usize,
    color_slots: usize,
    typeof: c.ArrowType,
    // Decimal data
    decimal_width: ?i32,
    decimal_precision: ?i32,
    decimal_scale: ?i32
};


pub const ArrowStreamBuffer = struct {
    const Self = @This();
    const buf_growth: usize = 64;

    schema: c.ArrowSchema,
    items: []c.ArrowArray,
    err: c.ArrowError,
    filled: u64,
    metadata: ?[]ColMetadata = null,

    /// Initialize an ArrowStreamBuffer container based on a row count ceiling
    /// capacity. This buffer will be resized if the stream yields more than
    /// the initialized buffers can hold.
    /// Generally, an ArrowArray batch from an ArrowStream is 1024 rows. Given
    /// an initial capacity row value, the number of buffers initialized is the
    /// ceiling of that value divided by 1024.
    pub fn initRows(alloc: Allocator, capacity: u64) !Self {
        // We assume that an ArrowArrayStream batch is 1024 rows. Based on the
        // number of rows we wish to consume (`until`), calculate the max number
        // of batches we could consume and allocate a buffer for the ArrowArrays.
        const assumed_batch: u64 = 1024;
        const max_batches: u64 = try std.math.divCeil(u64, capacity, assumed_batch);
        const batch_buf: []c.ArrowArray = try alloc.alloc(c.ArrowArray, max_batches);

        return .{
            .schema = std.mem.zeroInit(c.ArrowSchema, .{}),
            .items = batch_buf,
            .err = std.mem.zeroInit(c.ArrowError, .{}),
            .filled = 0};
    }

    /// Initialize an ArrowStreamBuffer container using a set number of buffers.
    /// Generally, an ArrowArray batch from an ArrowStream is 1024 rows. This
    /// initializer is slightly more simple than initRows.
    pub fn initBuffers(alloc: Allocator, capacity: u64) !Self {
        const batch_buf: []c.ArrowArray = try alloc.alloc(c.ArrowArray, capacity);

        return .{
            .schema = std.mem.zeroInit(c.ArrowSchema, .{}),
            .items = batch_buf,
            .err = std.mem.zeroInit(c.ArrowError, .{}),
            .filled = 0};
    }

    pub fn deinit(self: *Self, alloc: Allocator) void {
        alloc.free(self.items);

        if (self.metadata != null) alloc.free(self.metadata.?);
    }

    pub fn add(self: *Self, batch: c.ArrowArray) void {
        self.items[self.filled] = batch;

        self.filled += 1;
    }

    pub fn countBatchRows(self: *Self, i: usize) u64 {
        // FIXME: Bounds check?
        return @intCast(self.items[i].children[0].*.length);
    }

    pub fn countRows(self: *Self) u64 {
        var accum: u64 = 0;

        for (0..self.filled) |i| {
            accum += self.countBatchRows(i);
        }

        return accum;
    }

    pub fn hasCapacity(self: *Self) bool {
        return self.filled < self.items.len;
    }

    pub fn setBatchSize(self: *Self, len: u64) void {
        self.batch_sz[self.filled] = len;
    }

    pub fn resize(self: *Self, alloc: Allocator) !void {
        const bufsize = self.items.len + Self.buf_growth;
        self.items = try alloc.realloc(self.items, bufsize);
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
    if (rcode != c.NANOARROW_OK) {
        return error.AdbcNanoArrowError;
    }
}

fn getHeader(
    alloc: Allocator,
    schema: *c.ArrowSchema,
    err: *c.ArrowError
) ![]ColMetadata {
    const n: usize = @intCast(schema.n_children);

    var result: []ColMetadata = try alloc.alloc(ColMetadata, n);
    var view: c.ArrowSchemaView = std.mem.zeroInit(c.ArrowSchemaView, .{});

    for (0..n) |i| {
        const col: *c.ArrowSchema = schema.children[i];
        const name: []const u8 = if (col.*.name) |s| std.mem.span(s) else "column";

        try checkNanoArrow(c.ArrowSchemaViewInit(&view, col, err));

        // Store the decimal storage width if we are dealing with a DECIMAL
        const dec_width: ?i32 = switch(view.storage_type) {
            c.NANOARROW_TYPE_DECIMAL32 => 32,
            c.NANOARROW_TYPE_DECIMAL64 => 64,
            c.NANOARROW_TYPE_DECIMAL128 => 128,
            c.NANOARROW_TYPE_DECIMAL256 => 256,
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


pub fn extractValue(
    meta: *ColMetadata,
    buf: []u8,
    view: *c.ArrowArrayView,
    idx: usize
) []const u8 {
    const row: i64 = @intCast(idx);

    if (c.ArrowArrayViewIsNull(view, row) != 0) {
        return "null";
    }

    switch (view.storage_type) {
        c.NANOARROW_TYPE_INT8,
        c.NANOARROW_TYPE_INT16,
        c.NANOARROW_TYPE_INT32,
        c.NANOARROW_TYPE_INT64,
        c.NANOARROW_TYPE_DATE32,
        c.NANOARROW_TYPE_DATE64,
        c.NANOARROW_TYPE_TIMESTAMP => {
            const val = c.ArrowArrayViewGetIntUnsafe(view, row);
            return std.fmt.bufPrint(buf, "{d}", .{val}) catch "<err>";
        },
        c.NANOARROW_TYPE_UINT8,
        c.NANOARROW_TYPE_UINT16,
        c.NANOARROW_TYPE_UINT32,
        c.NANOARROW_TYPE_UINT64 => {
            const val = c.ArrowArrayViewGetUIntUnsafe(view, row);
            return std.fmt.bufPrint(buf, "{d}", .{val}) catch "<err>";
        },
        c.NANOARROW_TYPE_FLOAT,
        c.NANOARROW_TYPE_DOUBLE => {
            const val = c.ArrowArrayViewGetDoubleUnsafe(view, row);
            return std.fmt.bufPrint(buf, "{d:.4}", .{val}) catch "<err>";
        },
        c.NANOARROW_TYPE_BOOL => {
            const val = c.ArrowArrayViewGetIntUnsafe(view, row);
            return std.fmt.bufPrint(buf, "{d}", .{val}) catch "<err>";
        },
        c.NANOARROW_TYPE_STRING,
        c.NANOARROW_TYPE_LARGE_STRING => {
            const val = c.ArrowArrayViewGetStringUnsafe(view, row);
            const val_len: usize = @intCast(val.size_bytes);
            const val_str: []const u8 = val.data[0..val_len];
            return std.fmt.bufPrint(buf, "{s}", .{val_str}) catch "<err>";
        },
        c.NANOARROW_TYPE_BINARY,
        c.NANOARROW_TYPE_LARGE_BINARY => {
            const val = c.ArrowArrayViewGetBytesUnsafe(view, row);
            const val_len: usize = @intCast(val.size_bytes);
            const val_str: []const u8 = val.data.as_char[0..val_len];
            return std.fmt.bufPrint(buf, "{s}", .{val_str}) catch "<err>";
        },
        c.NANOARROW_TYPE_DECIMAL32,
        c.NANOARROW_TYPE_DECIMAL64,
        c.NANOARROW_TYPE_DECIMAL128,
        c.NANOARROW_TYPE_DECIMAL256 => {
            var dec: c.ArrowDecimal = std.mem.zeroInit(c.ArrowDecimal, .{});
            c.ArrowDecimalInit(&dec,
                meta.decimal_width.?,
                meta.decimal_precision.?,
                meta.decimal_scale.?);

            var val: c.ArrowBuffer = std.mem.zeroInit(c.ArrowBuffer, .{});
            c.ArrowBufferInit(&val);

            c.ArrowArrayViewGetDecimalUnsafe(view, row, &dec);

            // FIXME:
            //  1. Error handling
            //  2. How many allocations does this make?
            //try checkNanoArrow(c.ArrowDecimalAppendDigitsToBuffer(&dec, &val));
            _ = c.ArrowDecimalAppendDigitsToBuffer(&dec, &val);

            const val_len: usize = @intCast(val.size_bytes);
            const val_str: []const u8 = val.data[0..val_len];
            return std.fmt.bufPrint(buf, "{s}", .{val_str}) catch "<err>";


        },
        else => return "<unknown>"
    }
}

/// Determine if an ArrowArray Slot is a null value
pub fn isNull(col: *c.ArrowArrayView, idx: u64) bool {
    const row: i64 = @intCast(idx);

    return c.ArrowArrayViewIsNull(col, row) != 0;
}

/// Determine if an ArrowArray is numeric
pub fn isNumeric(col: *c.ArrowArrayView) bool {
    switch (col.storage_type) {
        c.NANOARROW_TYPE_INT8,
        c.NANOARROW_TYPE_INT16,
        c.NANOARROW_TYPE_INT32,
        c.NANOARROW_TYPE_INT64,
        c.NANOARROW_TYPE_DATE32,
        c.NANOARROW_TYPE_DATE64,
        c.NANOARROW_TYPE_TIMESTAMP,
        c.NANOARROW_TYPE_UINT8,
        c.NANOARROW_TYPE_UINT16,
        c.NANOARROW_TYPE_UINT32,
        c.NANOARROW_TYPE_UINT64,
        c.NANOARROW_TYPE_FLOAT,
        c.NANOARROW_TYPE_DOUBLE,
        c.NANOARROW_TYPE_DECIMAL32,
        c.NANOARROW_TYPE_DECIMAL64,
        c.NANOARROW_TYPE_DECIMAL128,
        c.NANOARROW_TYPE_DECIMAL256 => return true,
        else => return false
    }
}

/// FIXME Cannot handle all data types
fn slotWidth(meta: *ColMetadata, col: *c.ArrowArrayView, idx: u64) usize {
    const row: i64 = @intCast(idx);

    if (isNull(col, idx)) {
        return comptime "null".len;
    }

    var buf: [64]u8 = undefined;

    switch (col.storage_type) {
        c.NANOARROW_TYPE_INT8,
        c.NANOARROW_TYPE_INT16,
        c.NANOARROW_TYPE_INT32,
        c.NANOARROW_TYPE_INT64,
        c.NANOARROW_TYPE_DATE32,
        c.NANOARROW_TYPE_DATE64,
        c.NANOARROW_TYPE_TIMESTAMP => {
            const val: i64 = c.ArrowArrayViewGetIntUnsafe(col, row);
            const str = std.fmt.bufPrint(&buf, "{d}", .{val}) catch "<err>";
            return str.len;
        },
        c.NANOARROW_TYPE_UINT8,
        c.NANOARROW_TYPE_UINT16,
        c.NANOARROW_TYPE_UINT32,
        c.NANOARROW_TYPE_UINT64 => {
            const val: u64 = c.ArrowArrayViewGetUIntUnsafe(col, row);
            const str = std.fmt.bufPrint(&buf, "{d}", .{val}) catch "<err>";
            return str.len;
        },
        c.NANOARROW_TYPE_FLOAT,
        c.NANOARROW_TYPE_DOUBLE => {
            const val: f128 = c.ArrowArrayViewGetDoubleUnsafe(col, row);
            const str = std.fmt.bufPrint(&buf, "{d:.4}", .{val}) catch "<err>";
            return str.len;
        },
        c.NANOARROW_TYPE_BOOL => {
            const val: i64 = c.ArrowArrayViewGetIntUnsafe(col, row);
            const str = std.fmt.bufPrint(&buf, "{d}", .{val}) catch "<err>";
            return str.len;
        },
        c.NANOARROW_TYPE_STRING,
        c.NANOARROW_TYPE_LARGE_STRING => {
            const val = c.ArrowArrayViewGetStringUnsafe(col, row);
            return @intCast(val.size_bytes);
        },
        c.NANOARROW_TYPE_BINARY,
        c.NANOARROW_TYPE_LARGE_BINARY => {
            const val = c.ArrowArrayViewGetBytesUnsafe(col, row);
            return @intCast(val.size_bytes);
        },
        c.NANOARROW_TYPE_DECIMAL32,
        c.NANOARROW_TYPE_DECIMAL64,
        c.NANOARROW_TYPE_DECIMAL128,
        c.NANOARROW_TYPE_DECIMAL256 => {
            var dec: c.ArrowDecimal = std.mem.zeroInit(c.ArrowDecimal, .{});
            c.ArrowDecimalInit(&dec,
                meta.decimal_width.?,
                meta.decimal_precision.?,
                meta.decimal_scale.?);

            var val: c.ArrowBuffer = std.mem.zeroInit(c.ArrowBuffer, .{});
            c.ArrowBufferInit(&val);

            c.ArrowArrayViewGetDecimalUnsafe(col, row, &dec);

            // FIXME:
            //  1. Error handling
            //  2. How many allocations does this make?
            //try checkNanoArrow(c.ArrowDecimalAppendDigitsToBuffer(&dec, &val));
            _ = c.ArrowDecimalAppendDigitsToBuffer(&dec, &val);

            return @intCast(val.size_bytes);
        },
        else => return 9    // <unknown>
    }
}

/// Basically useless at this point
///
/// DEPRECATED
fn byteWidth(meta: *ColMetadata, col: *c.ArrowArrayView, idx: u64) usize {
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
    alloc: Allocator,
    stream: *c.ArrowArrayStream,
    buffer: *ArrowStreamBuffer
) anyerror!void {
    const getSchema = stream.get_schema orelse return error.AdbcLibError;
    const getNext = stream.get_next orelse return error.AdbcLibError;

    try checkAdbcStream(getSchema(stream, &buffer.schema));
    //defer { if (&buffer.schema.release) |release| release(&buffer.schema); }

    var batch: c.ArrowArray = std.mem.zeroInit(c.ArrowArray, .{});
    //defer { if (batch.release) |release| release(&batch); }

    while (getNext(stream, &batch) == 0) {
        if (batch.release == null) break;

        if (!buffer.hasCapacity()) {
            try buffer.resize(alloc);
        }

        buffer.add(batch);
    }
}

/// Generate a slice of ColMetadata
pub fn calcColumnMetadata(io: Io, alloc: Allocator, buffer: *ArrowStreamBuffer) ![]ColMetadata {
    const header = try getHeader(alloc, &buffer.schema, &buffer.err);

    //const cols: usize = header.len;
    const chunks: usize = header.len * buffer.filled;

    const q_buf = try alloc.alloc(ColFmt, chunks);
    defer alloc.free(q_buf);

    var queue: Io.Queue(ColFmt) = .init(q_buf);

    var consumer = try io.concurrent(consumeResult, .{
        io, &queue, chunks, header
    });
    defer _ = consumer.cancel(io) catch {};

    var grp: Io.Group = .init;
    defer grp.cancel(io);

    for (0..buffer.filled) |i| {

        grp.concurrent(io, produceBatchMaximums, .{
            io, &queue, i, buffer, header
        }) catch |e| {
            _ = try consumer.cancel(io);
            return e;
        };
    }

    try consumer.await(io);
    try grp.await(io);

    //for (0..buffer.filled) |i| {
    //    for (0..cols) |j| {
    //        std.debug.print("{d} {d} {d} {d}\n", .{result.len, i, j, cols});
    //        std.debug.print("{d} {d} {d}\n", .{
    //            result[0], 0, 0});
    //            //result[i * cols + j].bytes,
    //            //result[i * cols + j].color_slots});

    //        //header[j].width = @max(header[j].width, result[i * cols + j].width);
    //        //header[j].bytes = @max(header[j].bytes, result[i * cols + j].bytes);
    //        //header[j].color_slots += result[i * cols + j].color_slots;
    //    }
    //}

    return header;
}

const ColFmt = struct {
    width: usize,
    bytes: usize,
    color_slots: usize,
    col_i: usize
};

fn consumeResult(
    io: Io,
    queue: *Io.Queue(ColFmt),
    count: usize,
    header: []ColMetadata
) !void {
    for (0..count) |_| {
        const res = try queue.getOne(io);
        const j = res.col_i;

        //std.debug.print("{d}, {d}, {d}\n", .{header.len, count, j});

        header[j].width = @max(header[j].width, res.width);
        header[j].bytes = @max(header[j].bytes, res.bytes);
        header[j].color_slots += res.color_slots;
    }
}

pub fn produceBatchMaximums(
    io: Io,
    queue: *Io.Queue(ColFmt),
    index: usize,
    buffer: *ArrowStreamBuffer,
    //FIXME:
    header: []ColMetadata
) !void {
    var view: c.ArrowArrayView = std.mem.zeroInit(c.ArrowArrayView, .{});
    checkNanoArrow(c.ArrowArrayViewInitFromSchema(&view, &buffer.schema, &buffer.err)) catch {
        std.debug.print("!!PRODUCER ERROR: {s}\n", .{buffer.err.message});
        std.debug.print("Process likely deadlocked\n", .{});
        return error.Canceled;
    };

    var batch: c.ArrowArray = buffer.items[index];

    checkNanoArrow(c.ArrowArrayViewSetArray(&view, &batch, &buffer.err)) catch {
        std.debug.print("!!PRODUCER ERROR: {s}\n", .{buffer.err.message});
        std.debug.print("Process likely deadlocked\n", .{});
        return error.Canceled;
    };

    // Each child of the buffer is a column array
    for (0..@intCast(view.n_children)) |j| {
        const col = view.children[j];

        var c_fmt: ColFmt = .{
            .width = 0,
            .bytes = 0,
            .color_slots = 0,
            .col_i = j};

        for (0..@intCast(col.*.length)) |k| {
            c_fmt.width = @max(c_fmt.width, slotWidth(&header[j], col, k));
            c_fmt.bytes = @max(c_fmt.bytes, byteWidth(&header[j], col, k));
            c_fmt.color_slots += @intFromBool(isNull(col, k));
        }

        queue.putOne(io, c_fmt) catch {
            return error.Canceled;
        };
    }
}
