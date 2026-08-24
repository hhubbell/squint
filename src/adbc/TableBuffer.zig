const std = @import("std");
const c = @import("c");

const errs = @import("err.zig");
const ColMetadata = @import("meta.zig").ColMetadata;
const StreamBuffer = @import("StreamBuffer.zig");

const Allocator = std.mem.Allocator;
const Io = std.Io;

const Self = @This();

pub const Iterator = struct {
    pub const Direction = enum { colwise, rowwise };
    pub const Slot = struct {
        meta: *ColMetadata,
        view: [*c]c.ArrowArrayView,
        col: usize,
        row: usize
    };

    table: *Self,
    view: c.ArrowArrayView,
    batch: usize,
    col_i: ?usize,
    row_i: usize,
    adv: Direction,
    n_batches: usize,
    n_rows: usize,

    pub fn init(table: *Self, dir: Direction) !@This() {
        const init_batch: usize = 0;
        const n_batches: usize = table.countBatches();

        if (n_batches <= init_batch) {
            return error.InvalidIterator;
        }

        const view = table.asArrayView(init_batch) catch {
            return error.InvalidIterator;
        };

        return .{
            .table = table,
            .view = view,
            .batch = init_batch,
            .col_i = null,
            .row_i = 0,
            .adv = dir,
            .n_batches = n_batches,
            .n_rows = table.countBatchRows(init_batch),
        };
    }

    pub fn deinit(self: *@This()) void {
        _ = c.ArrowArrayViewReset(&self.view);
    }

    pub fn next(self: *@This()) ?Slot {
        switch (self.adv) {
            .colwise => self.nextColWise() catch return null,
            .rowwise => self.nextRowWise()
        }

        // The iterator was exhausted during our last call to `next`
        if (self.batch >= self.table.countBatches()) {
            return null;
        }

        const res: Slot = .{
            .meta = &self.table.metadata.?[self.col_i.?],
            .view = self.view.children[self.col_i.?],
            .col = self.col_i.?,
            .row = self.row_i
        };


        return res;
    }

    /// Advance the iterators batch/col/row, iterating over each column in a
    /// row before advancing the row.
    fn nextColWise(self: *@This()) !void {
        if (self.col_i == null) {
            self.col_i = 0;
            return;
        }

        self.col_i.? += 1;

        if (self.col_i.? >= self.table.countCols()) {
            self.col_i = 0;
            self.row_i += 1;
        }

        if (self.row_i >= self.n_rows) {
            self.batch += 1;
            self.col_i = 0;
            self.row_i = 0;

            if (self.batch < self.n_batches) {
                //c.ArrowArrayViewReset(&self.view);
                self.view = self.table.asArrayView(self.batch) catch {
                    return error.InvalidIterator;
                };

                self.n_rows = self.table.countBatchRows(self.batch);
            }
        }
    }

    /// Advance the iterators batch/col/row, iterating over each row in a
    /// column before advancing the column.
    fn nextRowWise(self: *@This()) void {
        _ = self;
        @panic("Not implemented.\n");
    }
};


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

pub fn countCols(self: *Self) u64 {
    return self.metadata.?.len;
}

/// Count the total number of rows stored across all underlying StreamBuffer
/// buffers. 
pub fn countRows(self: *Self) u64 {
    return self.buffer.countRows();
}

pub fn iter(self: *Self, dir: Iterator.Direction) !Iterator {
    return try .init(self, dir);
}

/// Get the last error message from the underlying StreamBuffer
pub fn lastErrMsg(self: *Self) []const u8 {
    return &self.buffer.err.message;
}
