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
            if (std.mem.eql(u8, arg, "-h") or std.mem.eql(u8, arg, "--help")) {
                help();
                std.process.exit(0);
            }

            if (isLongArg(arg)) {
                try self.longArg(alloc, arg, &args);
            } else if (isShortArg(arg)) {
                try self.shortArg(alloc, arg, &args);
            } else {
                help();
                std.process.exit(0);
            }
        }
    }
};

fn help() void {
    // FIXME: Use io.Writer instead of std.debug but whatever
    std.debug.print("squint [ARGS]\n"
        ++ "  --driver\tAny driver supported by adbc_driver_manager\n"
        ++ "  --uri\t\tDatabase connection string parameters\n\n",
        .{});
}

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

