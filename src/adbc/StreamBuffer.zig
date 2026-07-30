const std = @import("std");
const c = @import("c");

const ColMetadata = @import("meta.zig").ColMetadata;

const Allocator = std.mem.Allocator;
const Io = std.Io;

const Self = @This();
const buf_growth: usize = 64;

schema: c.ArrowSchema,
items: []c.ArrowArray,
err: c.ArrowError,
filled: u64,
fixed: bool,
metadata: ?[]ColMetadata = null,



/// Initialize an ArrowStreamBuffer container based on a row count ceiling
/// capacity. This buffer will NOT be resized if the stream yields more than
/// the initialized buffers can hold.
///
/// The following is INCORRECT:
/// Generally, an ArrowArray batch from an ArrowStream is 1024 rows. Given
/// an initial capacity row value, the number of buffers initialized is the
/// ceiling of that value divided by 1024.
///
/// This assumption was true for SQLite but not DuckDB. Other database
/// drivers are unknown. This is not a dealbreaker, but we need to make the
/// behavior of this consistent. E.g. can we set the driver page size? And
/// should we refer to the limit in terms of pages?
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
        .filled = 0,
        .fixed = true};
}

/// Initialize an ArrowStreamBuffer container using a set number of buffers
/// the can be resized. This initializer is slightly more simple than
/// initRows.
pub fn initBuffers(alloc: Allocator, capacity: u64) !Self {
    const batch_buf: []c.ArrowArray = try alloc.alloc(c.ArrowArray, capacity);

    return .{
        .schema = std.mem.zeroInit(c.ArrowSchema, .{}),
        .items = batch_buf,
        .err = std.mem.zeroInit(c.ArrowError, .{}),
        .filled = 0,
        .fixed = false};
}

pub fn deinit(self: *Self, alloc: Allocator) void {
    if (self.schema.release) |release| release(&self.schema);

    for (0..self.filled) |i| {
        var batch = self.items[i];
        if (batch.release) |release| release(&batch);
    }

    alloc.free(self.items);

    if (self.metadata != null) alloc.free(self.metadata.?);
}

pub fn add(self: *Self, batch: c.ArrowArray) void {
    self.items[self.filled] = batch;

    self.filled += 1;
}

pub fn canResize(self: *Self) bool {
    return !self.fixed;
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

