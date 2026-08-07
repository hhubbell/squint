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
    decimal: ?DecimalFmt,
    // Time data
    time_unit: c.ArrowTimeUnit
};

const DecimalFmt = struct {
    width: i32,
    precision: i32,
    scale: i32
};

const ColFmt = struct {
    width: usize,
    bytes: usize,
    color_slots: usize,
    col_i: usize
};

const BufferIndexTuple = struct {
    const Self = @This();

    buffer_i: usize,
    header_i: usize,

    pub fn initSlice(gpa: Allocator, buffers: usize, columns: usize) ![]Self {
        var tuples = try gpa.alloc(Self, buffers * columns);

        if (buffers == 0) {
            return tuples;
        }

        const off: usize = @divFloor(tuples.len, buffers);
        
        for (0..buffers) |i| {
            for (0..columns) |j| {
                tuples[off * i + j].buffer_i = i;
                tuples[off * i + j].header_i = j;
            }
        }

        return tuples;
    }
};

/// Generate a slice of ColMetadata
pub fn calcColumnMetadata(io: Io, alloc: Allocator, buffer: *ArrowStreamBuffer) ![]ColMetadata {
    const header = try getHeader(alloc, &buffer.schema);

    const indexes = try BufferIndexTuple.initSlice(alloc, buffer.filled, header.len);
    defer alloc.free(indexes);

    const n_tasks: usize = indexes.len;

    // TODO: Does the queue have to be the size of the total number of items?
    // Or should we keep it smaller and some threads will be blocked until the
    // consumer can clear them out?
    const q_buf = try alloc.alloc(ColFmt, n_tasks);
    defer alloc.free(q_buf);

    var queue: Io.Queue(ColFmt) = .init(q_buf);

    var consumer = try io.concurrent(consumeResult, .{
        io, &queue, n_tasks, header
    });
    defer _ = consumer.cancel(io) catch {};

    var grp: Io.Group = .init;
    defer grp.cancel(io);

    // If we got an empty result set, we need to ensure we have at
    // least one thread
    const res_set: usize = @max(buffer.filled, 1);
    const threads: usize = @min(res_set, 16);
    const chunks: usize = try std.math.divCeil(usize, n_tasks, threads);

    for (0..threads) |i| {
        const beg: usize = i * chunks;
        const end: usize = @min((i + 1) * chunks, n_tasks);

        const chunk_idx = indexes[beg..end];

        grp.concurrent(io, produceBatchMaximums, .{
            io, &queue, chunk_idx, buffer, header
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
    // TODO: Rather than iterating over a known fixed number of results,
    // could we instead just keep pulling from the queue until the queue
    // is closed?
    for (0..count) |_| {
        const res = try queue.getOne(io);
        const j = res.col_i;

        header[j].width = @max(header[j].width, res.width);
        header[j].bytes = @max(header[j].bytes, res.bytes);
        header[j].color_slots += res.color_slots;
    }
}

pub fn produceBatchMaximums(
    io: Io,
    queue: *Io.Queue(ColFmt),
    indexes: []BufferIndexTuple,
    buffer: *ArrowStreamBuffer,
    //FIXME:
    header: []ColMetadata
) !void {
    for (indexes) |i| {
        var view: c.ArrowArrayView = std.mem.zeroInit(c.ArrowArrayView, .{});
        err.checkNanoArrow(c.ArrowArrayViewInitFromSchema(
            &view,
            &buffer.schema,
            &buffer.err
        )) catch {
            std.debug.print("!!PRODUCER ERROR: {s}\n", .{buffer.err.message});
            std.debug.print("Process likely deadlocked\n", .{});
            return error.Canceled;
        };

        var batch: c.ArrowArray = buffer.items[i.buffer_i];

        err.checkNanoArrow(c.ArrowArrayViewSetArray(&view, &batch, &buffer.err)) catch {
            std.debug.print("!!PRODUCER ERROR: {s}\n", .{buffer.err.message});
            std.debug.print("Process likely deadlocked\n", .{});
            return error.Canceled;
        };

        const col = view.children[i.header_i];

        var c_fmt: ColFmt = .{
            .width = 0,
            .bytes = 0,
            .color_slots = 0,
            .col_i = i.header_i};

        for (0..@intCast(col.*.length)) |k| {
            const sw = slotWidth(&header[i.header_i], col, k) catch return error.Canceled;
            const bw = byteWidth(&header[i.header_i], col, k) catch return error.Canceled;

            c_fmt.width = @max(c_fmt.width, sw);
            c_fmt.bytes = @max(c_fmt.bytes, bw);
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
    const n_cols: usize = @intCast(schema.n_children);

    var result: []ColMetadata = try alloc.alloc(ColMetadata, n_cols);

    for (0..n_cols) |i| {
        const col: *c.ArrowSchema = schema.children[i];
        const name: []const u8 = if (col.*.name) |s| std.mem.span(s) else "column";

        var view: c.ArrowSchemaView = std.mem.zeroInit(c.ArrowSchemaView, .{});
        try err.checkNanoArrow(c.ArrowSchemaViewInit(&view, col, &a_err));

        // Store the decimal storage width if we are dealing with a DECIMAL
        var dec: ?DecimalFmt = null;
        if (isDecimal(&view)) {
            dec = .{
                .width = switch(view.type) {
                    c.NANOARROW_TYPE_DECIMAL32 => 32,
                    c.NANOARROW_TYPE_DECIMAL64 => 64,
                    c.NANOARROW_TYPE_DECIMAL128 => 128,
                    c.NANOARROW_TYPE_DECIMAL256 => 256,
                    else => unreachable
                },
                .precision = view.decimal_precision,
                .scale = view.decimal_scale
            };
        }

        result[i] = .{
            .name = name,
            .width = name.len,
            .bytes = name.len,
            .color_slots = 0,
            .typeof = view.type,
            .decimal = dec,
            .time_unit = view.time_unit
        };
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
            return dt.asDateString(buf) catch "<err>";
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
            return dt.asDateTimeString(buf) catch "<err>";
        },
        c.NANOARROW_TYPE_TIME32,
        c.NANOARROW_TYPE_TIME64 => {
            const val = c.ArrowArrayViewGetIntUnsafe(view, row);
            const ts: date.Time = switch (meta.time_unit) {
                c.NANOARROW_TIME_UNIT_SECOND => .fromMidnightSec(@intCast(val)),
                c.NANOARROW_TIME_UNIT_MILLI => .fromMidnightMs(@intCast(val)),
                c.NANOARROW_TIME_UNIT_MICRO => .fromMidnightMicro(@intCast(val)),
                c.NANOARROW_TIME_UNIT_NANO => .fromMidnightNano(@intCast(val)),
                else => unreachable
            };
            return ts.asTimeString(buf) catch "<err>";
        },
        c.NANOARROW_TYPE_INTERVAL_MONTHS,
        c.NANOARROW_TYPE_INTERVAL_DAY_TIME,
        c.NANOARROW_TYPE_INTERVAL_MONTH_DAY_NANO => |t| {
            var inter: c.ArrowInterval = std.mem.zeroInit(c.ArrowInterval, .{});
            c. ArrowIntervalInit(&inter, t);
            c. ArrowArrayViewGetIntervalUnsafe(view, row, &inter);

            switch (t) {
                c.NANOARROW_TYPE_INTERVAL_MONTHS => {
                    return std.fmt.bufPrint(buf, "{d} months", .{
                        inter.months
                    }) catch "<err>";
                },
                c.NANOARROW_TYPE_INTERVAL_DAY_TIME => {
                    return std.fmt.bufPrint(buf, "{d} days {d} ms", .{
                        inter.days,
                        inter.ms
                    }) catch "<err>";
                },
                c.NANOARROW_TYPE_INTERVAL_MONTH_DAY_NANO => {
                    return std.fmt.bufPrint(buf, "{d} months {d} days {d} ns", .{
                        inter.months,
                        inter.days,
                        inter.ns
                    }) catch "<err>";
                },
                else => unreachable
            }
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
                meta.decimal.?.width,
                meta.decimal.?.precision,
                meta.decimal.?.scale);
            c.ArrowArrayViewGetDecimalUnsafe(view, row, &dec);

            var val: c.ArrowBuffer = std.mem.zeroInit(c.ArrowBuffer, .{});
            c.ArrowBufferInit(&val);

            err.checkNanoArrow(c.ArrowDecimalAppendStringToBuffer(&dec, &val)) catch return "<err>";

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
    return switch (col.storage_type) {
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
        c.NANOARROW_TYPE_DECIMAL256 => true,
        else => false
    };
}

fn isDecimal(col: *c.ArrowSchemaView) bool {
    return switch (col.type) {
            c.NANOARROW_TYPE_DECIMAL32,
            c.NANOARROW_TYPE_DECIMAL64,
            c.NANOARROW_TYPE_DECIMAL128,
            c.NANOARROW_TYPE_DECIMAL256 => true,
        else => false
    };
}

/// FIXME Cannot handle all data types
fn slotWidth(meta: *ColMetadata, col: *c.ArrowArrayView, idx: u64) !usize {
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
            const str = try std.fmt.bufPrint(&buf, "{d}", .{val});
            return str.len;
        },
        c.NANOARROW_TYPE_DATE32 => {
            // YYYY-MM-DD
            return 10;
        },
        c.NANOARROW_TYPE_DATE64,
        c.NANOARROW_TYPE_TIMESTAMP => {
            // YYYY-MM-DD HH:MM:SS.mmm
            return 23;
        },
        c.NANOARROW_TYPE_TIME32,
        c.NANOARROW_TYPE_TIME64 => {
            // HH:MM:SS.mmm
            return 12;
        },
        c.NANOARROW_TYPE_INTERVAL_MONTHS,
        c.NANOARROW_TYPE_INTERVAL_DAY_TIME,
        c.NANOARROW_TYPE_INTERVAL_MONTH_DAY_NANO => |t| {
            // TODO: We can move some of this to the `date` module to better
            // handle the representation of intervals in different grains
            var inter: c.ArrowInterval = std.mem.zeroInit(c.ArrowInterval, .{});
            c. ArrowIntervalInit(&inter, t);
            c. ArrowArrayViewGetIntervalUnsafe(col, row, &inter);

            const str = switch (t) {
                c.NANOARROW_TYPE_INTERVAL_MONTHS =>
                    try std.fmt.bufPrint(&buf, "{d} months", .{inter.months}),
                c.NANOARROW_TYPE_INTERVAL_DAY_TIME =>
                    try std.fmt.bufPrint(&buf, "{d} days {d} ms", .{
                        inter.days,
                        inter.ms
                    }),
                c.NANOARROW_TYPE_INTERVAL_MONTH_DAY_NANO =>
                    try std.fmt.bufPrint(&buf, "{d} months {d} days {d} ns", .{
                        inter.months,
                        inter.days,
                        inter.ns
                    }),
                else => unreachable
            };

            return str.len;
        },
        c.NANOARROW_TYPE_FLOAT,
        c.NANOARROW_TYPE_DOUBLE => {
            const val: f128 = c.ArrowArrayViewGetDoubleUnsafe(col, row);
            const str = try std.fmt.bufPrint(&buf, "{d:.4}", .{val});
            return str.len;
        },
        c.NANOARROW_TYPE_BOOL => {
            const val: i64 = c.ArrowArrayViewGetIntUnsafe(col, row);
            const str = try std.fmt.bufPrint(&buf, "{d}", .{val});
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
                meta.decimal.?.width,
                meta.decimal.?.precision,
                meta.decimal.?.scale);
            c.ArrowArrayViewGetDecimalUnsafe(col, row, &dec);

            var val: c.ArrowBuffer = std.mem.zeroInit(c.ArrowBuffer, .{});
            c.ArrowBufferInit(&val);

            try err.checkNanoArrow(c.ArrowDecimalAppendDigitsToBuffer(&dec, &val)) ;

            return @intCast(val.size_bytes);
        },
        else => return 9    // <unknown>
    }
}

/// Basically useless at this point
///
/// DEPRECATED
fn byteWidth(meta: *ColMetadata, col: *c.ArrowArrayView, idx: u64) !usize {
    // This only makes sense if we ever color an entire column. adding
    // the extra bytes for values in a column gets weird when some values
    // are colorable and some not. Nulls are the example. 
    const color: usize = 0;

    return try slotWidth(meta, col, idx) + color;
}

