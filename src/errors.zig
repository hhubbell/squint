const std = @import("std");

const Allocator = std.mem.Allocator;


/// Omg is this a ring buffer???
///
pub const ErrorSingleton = struct {
    const Self = @This();

    alloc: Allocator,
    stack: []?[]const u8,
    head: usize,
    fill: usize,

    pub fn init(alloc: Allocator, size: usize) !Self {
        const stack = try alloc.alloc(?[]const u8, size);
        @memset(stack, null);

        return .{
            .alloc = alloc,
            .stack = stack,
            .head = 0,
            .fill = 0};
    }

    pub fn deinit(self: *Self, alloc: Allocator) void {
        for (self.stack) |itm| { if (itm != null) alloc.free(itm.?);}
        alloc.free(self.stack);
    }

    pub fn addErr(self: *Self, msg: []const u8) void {
        // Base case: stack is empty
        if (self.fill == 0) {
            self.stack[self.head] = self.alloc.dupe(u8, msg) catch "<err>";
            self.fill += 1;
            return;
        }

        self.head += 1;

        // Case: We've reached the capacity of the stack, so
        // start rolling over
        if (self.head >= self.stack.len) {
            self.head = 0;
        }

        if (self.stack[self.head] != null) {
            self.alloc.free(self.stack[self.head].?);
        }

        self.stack[self.head] = self.alloc.dupe(u8, msg) catch "<err>";

        // Track the capacity of the stack
        if (self.fill < self.stack.len) {
            self.fill += 1;
        }

    }

    fn idxErr(self: *Self, i: usize) []const u8 {
        return self.stack[i].?;
    }

    fn lastErr(self: *Self) []const u8 {
        return self.idxErr(self.head);
    }

    pub fn printLastErr(self: *Self, writer: *std.Io.Writer) !void {
        if (self.fill == 0) {
            try writer.print("No error messages.\n", .{});
            return;
        }

        try writer.print("{s}\n", .{ self.lastErr() });
    }

    pub fn printAllErrs(self: *Self, writer: *std.Io.Writer) !void {
        if (self.fill == 0) {
            try writer.print("No error messages.\n", .{});
            return;
        }

        var i: usize = 0;
        var pt: usize = self.head;

        while (i < self.fill) {
            try writer.print("{d} {s}\n", .{ i, self.idxErr(pt) });


            if (pt == 0) {
                pt = self.fill - 1;
            } else {
                pt -= 1;
            }

            i += 1;
        }
    }
};
