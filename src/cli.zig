const std = @import("std");
const Allocator = std.mem.Allocator;
const Args = std.process.Args;


pub const SimpleArgParser = struct {
    const Self = @This();

    vargs: std.StringHashMapUnmanaged([]const u8) = .empty,

    fn longArg(self: *Self, alloc: Allocator, key: []const u8, args: *Args.Iterator) !void {
        const val: []const u8 = args.next() orelse "";

        try self.vargs.put(alloc, key[2..], val);
    }

    fn shortArg(self: *Self, alloc: Allocator, key: []const u8, args: *Args.Iterator) !void {
        // FIXME: Do some traversal from short to long name
        try self.longArg(alloc, key, args);
    }

    pub fn parse(self: *Self, alloc: Allocator, a: Args) !void {
        var args = try a.iterateAllocator(alloc);
        defer args.deinit();

        // Skip program invocation arg
        _ = args.skip();

        while (args.next()) |arg| {
            if (isLongArg(arg)) {
                try self.longArg(alloc, arg, &args);
            } else if (isShortArg(arg)) {
                try self.shortArg(alloc, arg, &args);
            }
        }
    }
};

fn isLongArg(arg: []const u8) bool {
    return (arg.len > 2
        and arg[0] == '-'
        and arg[1] == '-');
}

fn isShortArg(arg: []const u8) bool {
    return (arg.len > 1
        and arg[0] == '-'
        and arg[1] != '-');
}

