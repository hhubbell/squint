const std = @import("std");
const c = @import("c");

const errs = @import("err.zig");
const ColMetadata = @import("meta.zig").ColMetadata;
const StreamBuffer = @import("StreamBuffer.zig");

const Allocator = std.mem.Allocator;
const Io = std.Io;

const Self = @This();

buffer: StreamBuffer,
metadata: ?[]ColMetadata,


/// Initialize a TableBuffer, which is backed by a StreamBuffer, with an
/// initial number of buffers. A TableBuffer is similar to a StreamBuffer, but
/// carries additional column metadata which is calculated on load.
pub fn init(gpa: Allocator, capacity: u64) !Self {
    return .{
        .buffer = try .init(gpa, capacity),
        .metadata = null
    };
}

pub fn deinit(self: *Self, gpa: Allocator) void {
    self.buffer.deinit(gpa);

    if (self.metadata != null) gpa.free(self.metadata.?);
    self.metadata = null;
}

/// Add an ArrowArray to the backing StreamBuffer.
pub fn add(self: *Self, gpa: Allocator, batch: c.ArrowArray) !void {
    try self.buffer.add(gpa, batch);
}

/// Return an underlying StreamBuffer record as an ArrowArrayView
pub fn asArrayView(self: *Self, i: usize) !c.ArrowArrayView {
    return try self.buffer.asArrayView(i);
}

/// Empty the content of the TableBuffer, freeing all memory except for the
/// containers. Prepares the TableBuffer to be reused.
pub fn clear(self: *Self, gpa: Allocator) void {
    self.buffer.clear();

    if (self.metadata != null) gpa.free(self.metadata.?);
    self.metadata = null;
}

pub fn countBatches(self: *Self) u64 {
    return self.buffer.filled;
}

/// Count the number of rows stored in the `i`th StreamBuffer buffer.
pub fn countBatchRows(self: *Self, i: usize) u64 {
    return self.buffer.countBatchRows(i);
}

/// Count the total number of rows stored across all underlying StreamBuffer
/// buffers. 
pub fn countRows(self: *Self) u64 {
    return self.buffer.countRows();
}

/// Get the last error message from the underlying StreamBuffer
pub fn lastErrMsg(self: *Self) []const u8 {
    return &self.buffer.err.message;
}
