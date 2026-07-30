const std = @import("std");
const c = @import("c");
const date = @import("date");

const err = @import("err.zig");

const ArrowStreamBuffer = @import("StreamBuffer.zig");

const Allocator = std.mem.Allocator;
const Io = std.Io;


pub const ColMetadata = struct {
    name: []const u8,
    width: usize,
    bytes: usize,
    color_slots: usize,
    typeof: c.ArrowType,
    // Decimal data
    decimal_width: ?i32,
    decimal_precision: ?i32,
    decimal_scale: ?i32,
    // Time data
    time_unit: c.ArrowTimeUnit
};

const ColFmt = struct {
    width: usize,
    bytes: usize,
    color_slots: usize,
    col_i: usize
};


/// Generate a slice of ColMetadata
pub fn calcColumnMetadata(io: Io, alloc: Allocator, buffer: *ArrowStreamBuffer) ![]ColMetadata {
    const header = try getHeader(alloc, &buffer.schema);

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

    return header;
}

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
    err.checkNanoArrow(c.ArrowArrayViewInitFromSchema(&view, &buffer.schema, &buffer.err)) catch {
        std.debug.print("!!PRODUCER ERROR: {s}\n", .{buffer.err.message});
        std.debug.print("Process likely deadlocked\n", .{});
        return error.Canceled;
    };

    var batch: c.ArrowArray = buffer.items[index];

    err.checkNanoArrow(c.ArrowArrayViewSetArray(&view, &batch, &buffer.err)) catch {
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

fn getHeader(
    alloc: Allocator,
    schema: *c.ArrowSchema,
) ![]ColMetadata {
    var a_err: c.ArrowError = std.mem.zeroInit(c.ArrowError, .{});
    const n: usize = @intCast(schema.n_children);

    var result: []ColMetadata = try alloc.alloc(ColMetadata, n);
    var view: c.ArrowSchemaView = std.mem.zeroInit(c.ArrowSchemaView, .{});

    for (0..n) |i| {
        const col: *c.ArrowSchema = schema.children[i];
        const name: []const u8 = if (col.*.name) |s| std.mem.span(s) else "column";

        try err.checkNanoArrow(c.ArrowSchemaViewInit(&view, col, &a_err));

        // Store the decimal storage width if we are dealing with a DECIMAL
        const dec_width: ?i32 = switch(view.type) {
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
            .decimal_scale = view.decimal_scale,
            .time_unit = view.time_unit};
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

    switch (meta.typeof) {
        c.NANOARROW_TYPE_INT8,
        c.NANOARROW_TYPE_INT16,
        c.NANOARROW_TYPE_INT32,
        c.NANOARROW_TYPE_INT64,
        c.NANOARROW_TYPE_UINT8,
        c.NANOARROW_TYPE_UINT16,
        c.NANOARROW_TYPE_UINT32,
        c.NANOARROW_TYPE_UINT64 => {
            const val = c.ArrowArrayViewGetUIntUnsafe(view, row);
            return std.fmt.bufPrint(buf, "{d}", .{val}) catch "<err>";
        },
        c.NANOARROW_TYPE_DATE32 => {
            // Arrow DATE32: int32_t days since UNIX Epoch
            const val = c.ArrowArrayViewGetIntUnsafe(view, row);
            const dt = date.DateTime.fromEpochDays(val);
            return std.fmt.bufPrint(buf,
                "{d:0>4}-{d:0>2}-{d:0>2}", .{
                    dt.year,
                    dt.month,
                    dt.day
            }) catch "<err>";
        },
        c.NANOARROW_TYPE_DATE64,
        c.NANOARROW_TYPE_TIMESTAMP => {
            // Arrow DATE64/TIMESTAMP: int64_t units since UNIX Epoch
            const val = c.ArrowArrayViewGetIntUnsafe(view, row);
            const dt: date.DateTime = switch (meta.time_unit) {
                c.NANOARROW_TIME_UNIT_SECOND => .fromEpochSec(val),
                c.NANOARROW_TIME_UNIT_MILLI => .fromEpochMs(val),
                c.NANOARROW_TIME_UNIT_MICRO => .fromEpochMicro(val),
                c.NANOARROW_TIME_UNIT_NANO => .fromEpochNano(val),
                else => unreachable
            };
            
            return std.fmt.bufPrint(buf,
                "{d:0>4}-{d:0>2}-{d:0>2}T{d:0>2}:{d:0>2}:{d:0>2}.{d:0>3}Z", .{
                    dt.year,
                    dt.month,
                    dt.day,
                    dt.hour,
                    dt.minute,
                    dt.second,
                    dt.millisecond
                }) catch "<err>";
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
            //try err.checkNanoArrow(c.ArrowDecimalAppendDigitsToBuffer(&dec, &val));
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
/// FIXME: Avoid using ArrowArrayView.storage_type in favor of the
/// ArrowSchema.type instead. The storage_type may lose fidelity if
/// the schema type is backed by a less descriptive type, e.g. DATE
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

    switch (meta.typeof) {
        c.NANOARROW_TYPE_INT8,
        c.NANOARROW_TYPE_INT16,
        c.NANOARROW_TYPE_INT32,
        c.NANOARROW_TYPE_INT64,
        c.NANOARROW_TYPE_UINT8,
        c.NANOARROW_TYPE_UINT16,
        c.NANOARROW_TYPE_UINT32,
        c.NANOARROW_TYPE_UINT64 => {
            const val: u64 = c.ArrowArrayViewGetUIntUnsafe(col, row);
            const str = std.fmt.bufPrint(&buf, "{d}", .{val}) catch "<err>";
            return str.len;
        },
        c.NANOARROW_TYPE_DATE32 => {
            // YYYY-MM-DD
            return 10;
        },
        c.NANOARROW_TYPE_DATE64,
        c.NANOARROW_TYPE_TIMESTAMP => {
            // YYYY-MM-DDTHH:MM:SS.mmmZ
            return 24;
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
            //try err.checkNanoArrow(c.ArrowDecimalAppendDigitsToBuffer(&dec, &val));
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
    // This only makes sense if we ever color an entire column. adding
    // the extra bytes for values in a column gets weird when some values
    // are colorable and some not. Nulls are the example. 
    const color: usize = 0;

    return slotWidth(meta, col, idx) + color;
}
