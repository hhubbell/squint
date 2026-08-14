const std = @import("std");
const c = @import("c");

const errs = @import("err.zig");
const meta = @import("meta.zig");

const Allocator = std.mem.Allocator;
const Io = std.Io;

const Self = @This();

schema: c.ArrowSchema,
items: []c.ArrowArray,
err: c.ArrowError,
filled: u64,
growth: usize = 16,


/// Initialize a StreamBuffer container with an intial number of buffers.
/// The number of available buffers can be resized during `add` if additional
/// space is required. Call `addFixed` to avoid resizing. This call can return
/// a FixedBufferExceeded error if the buffer is full.
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

pub fn countBatchRows(self: *Self, i: usize) u64 {
    // NOTE: We specifically don't bounds check here because we expect the
    // caller to ensure that `i` is within `self.items.len`.
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

/// Return a StreamBuffer record as an ArrowArrayView
pub fn asArrayView(self: *Self, buffer_i: usize) !c.ArrowArrayView {
    if (buffer_i >= self.filled) {
        return error.IndexOutOfBounds;
    }

    var view: c.ArrowArrayView = std.mem.zeroInit(c.ArrowArrayView, .{});
    // TODO: Should this be initialized once initially, and then used
    // by this function to generate a view as-needed? 
    // Need to evaluate how expensive this Init call is.
    try errs.checkNanoArrow(c.ArrowArrayViewInitFromSchema(
        &view,
        &self.schema,
        &self.err));
    try errs.checkNanoArrow(c.ArrowArrayViewSetArray(
        &view,
        &self.items[buffer_i],
        &self.err));

    return view;
}

/// In some very specific cases, a StreamBuffer represents just one single
/// string value. This is a helper function to make it easier to get the
/// value.
pub fn asOneString(self: *Self) !?[]const u8 {
    const view = try self.asArrayView(0);

    if (view.n_children < 1) {
        return error.EmptySet;
    }

    const child: *c.ArrowArrayView = view.children[0];
    if (meta.isNull(child, 0)) {
        return null;
    }

    const raw = c.ArrowArrayViewGetStringUnsafe(child, 0);
    const len: usize = @intCast(raw.size_bytes);

    return raw.data[0..len];
}
