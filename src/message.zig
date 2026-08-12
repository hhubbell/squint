const std = @import("std");

const format = @import("format.zig");

const Allocator = std.mem.Allocator;


pub const Message = struct {
    const Self = @This();

    kind: enum { fatal, err, warn, note },
    msg: ?[]const u8,

    pub fn deinit(self: *Self, gpa: Allocator) void {
        if (self.msg != null) {
            gpa.free(self.msg.?);
        }
    }

    pub fn isErr(self: Self) bool {
        return self.kind == .fatal
            or self.kind == .err;
    }
};

pub const MessageBuffer = struct {
    const Self = @This();

    alloc: Allocator,
    stack: []?Message,
    head: usize,
    fill: usize,

    pub fn init(alloc: Allocator, size: usize) !Self {
        const stack = try alloc.alloc(?Message, size);
        @memset(stack, null);

        return .{
            .alloc = alloc,
            .stack = stack,
            .head = 0,
            .fill = 0};
    }

    pub fn deinit(self: *Self, alloc: Allocator) void {
        for (0..self.fill) |i| { self.stack[i].?.deinit(alloc); }
        alloc.free(self.stack);
    }

    fn addBoxedMsg(self: *Self, box: Message) void {
        // Base case: stack is empty
        if (self.fill == 0) {
            self.stack[self.head] = box;
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
            self.stack[self.head].?.deinit(self.alloc);
        }

        self.stack[self.head] = box;

        // Track the capacity of the stack
        if (self.fill < self.stack.len) {
            self.fill += 1;
        }
    }

    pub fn addErr(self: *Self, comptime msg: []const u8, args: anytype) void {
        const box: Message = .{
            .kind = .err,
            .msg = std.fmt.allocPrint(self.alloc, msg, args) catch null
        };

        self.addBoxedMsg(box);
    }

    pub fn addFatalErr(self: *Self, comptime msg: []const u8, args: anytype) void {
        const box: Message = .{
            .kind = .fatal,
            .msg = std.fmt.allocPrint(self.alloc, msg, args) catch null
        };

        self.addBoxedMsg(box);
    }

    pub fn numErrs(self: *Self) usize {
        var counter: usize = 0;

        for (self.stack) |msg| {
            if (msg != null and msg.?.isErr()) {
                counter += 1;
            }
        }

        return counter;
    }

    pub fn numFatal(self: *Self) usize {
        var counter: usize = 0;

        for (self.stack) |msg| {
            if (msg != null and msg.?.kind == .fatal) {
                counter += 1;
            }
        }

        return counter;
    }

    fn lastErr(self: *Self) ?Message {
        // FIXME: This breaks when we roll over
        var i: usize = self.head;

        while (i > 0) {
            if (self.stack[i].?.isErr()) {
                break;
            }

            i -= 1;
        }

        return self.stack[i];
    }

    pub fn printLastErr(self: *Self, writer: *std.Io.Writer) !void {
        const last_err: ?Message = self.lastErr();

        if (last_err == null) {
            try writer.print("{s}No error messages.{s}\n", .{
                format.GREY,
                format.RESET
            });
            return;
        }

        try writer.print("{s}\n", .{ last_err.?.msg.? });
        try writer.flush();
    }

    pub fn printAllErrs(self: *Self, writer: *std.Io.Writer) !void {
        if (self.numErrs() == 0) {
            try writer.print("{s}No error messages.{s}\n", .{
                format.GREY,
                format.RESET
            });
            return;
        }

        var i: usize = 0;
        var pt: usize = self.head;

        while (i < self.fill) {
            const ith_msg = self.stack[pt].?;
            if (ith_msg.isErr()) {
                try writer.print("{s}{d}{s} {s}\n", .{
                    format.RED,
                    i,
                    format.RESET,
                    ith_msg.msg orelse "<err>"
                });
            }

            if (pt == 0) {
                pt = self.fill - 1;
            } else {
                pt -= 1;
            }

            i += 1;
        }

        try writer.flush();
    }
};
