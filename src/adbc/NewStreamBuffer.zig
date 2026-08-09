const std = @import("std");
const c = @import("c");

const Allocator = std.mem.Allocator;
const Io = std.Io;

const Self = @This();

schema: c.ArrowSchema,
items: []c.ArrowArray,
err: c.ArrowError,
filled: u64,
growth: usize = 64,


/// Initialize an ArrowStreamBuffer container with an intial number of buffers.
/// The number of available buffers can be resized during `add` if additional
/// space is required. Call `addFixed` to avoid resizing. This call can return
/// an FixedBufferExceeded error if the buffer is full.
pub fn init(gpa: Allocator, capacity: u64) !Self {
    return .{
        .schema = std.mem.zeroInit(c.ArrowSchema, .{}),
        .items = try gpa.alloc(c.ArrowArray, capacity),
        .err = std.mem.zeroInit(c.ArrowError, .{}),
        .filled = 0};
}

pub fn deinit(self: *Self, gpa: Allocator) void {
    self.clear();    
    gpa.free(self.items);
}

pub fn add(self: *Self, gpa: Allocator, batch: c.ArrowArray) !void {
    if (!self.hasCapacity()) {
        try self.resize(gpa);
    }

    self.items[self.filled] = batch;
    self.filled += 1;
}

pub fn addFixed(self: *Self, batch: c.ArrowArray) !void {
    if (!self.hasCapacity()) {
        return error.FixedBufferExceeded;
    }

    self.items[self.filled] = batch;
    self.filled += 1;
}

pub fn clear(self: *Self) void {
    if (self.schema.release) |release| release(&self.schema);

    for (0..self.filled) |i| {
        var batch = self.items[i];
        if (batch.release) |release| release(&batch);
    }

    self.filled = 0;
}

fn countBatchRows(self: *Self, i: usize) u64 {
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

pub fn resize(self: *Self, gpa: Allocator) !void {
    const bufsize = self.items.len + self.growth;
    self.items = try gpa.realloc(self.items, bufsize);
}

