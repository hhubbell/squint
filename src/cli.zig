const std = @import("std");

const version = @import("build_options").version;

const Allocator = std.mem.Allocator;
const Args = std.process.Args;


/// What if there was like an API where you could "Parse into" a struct.
/// The struct would define the allowed arguments and act as the carrier
/// for the parsed results. Would require some type introspection to
/// determine allowed values at compile time, which I think is possible?
///
/// This API doesn't do that, but it would be cool.
///
/// Given that something more robust than what I've implemented below is on the
/// roadmap (https://codeberg.org/ziglang/zig/issues/30677), I'll probably wait
/// until something comes from stdlib, rather than pursuing this idea.
///
/// But it would be cool.
///
pub const SimpleArgParser = struct {
    const Self = @This();

    vargs: std.StringHashMapUnmanaged([]const u8) = .empty,

    fn longArg(
        self: *Self,
        alloc: Allocator,
        key: []const u8,
        args: *Args.Iterator
    ) !void {
        const val: []const u8 = args.next() orelse "";
        const knm: []const u8 = key[2..];

        try self.vargs.put(alloc, knm, val);
    }

    fn shortArg(
        self: *Self,
        alloc: Allocator,
        key: []const u8,
        args: *Args.Iterator
    ) !void {
        // FIXME: Do some traversal from short to long name
        try self.longArg(alloc, key, args);
    }

    pub fn parse(self: *Self, alloc: Allocator, a: Args) !void {
        var args = try a.iterateAllocator(alloc);
        defer args.deinit();

        // Skip program invocation arg
        _ = args.skip();

        while (args.next()) |arg| {
            if (isHelp(arg)) {
                help();
                std.process.exit(0);
            }

            if (isVersion(arg)) {
                // FIXME: Use io.Writer instead of std.debug but whatever
                std.debug.print("{f}\n", .{version});
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


fn isHelp(arg: []const u8) bool {
    return std.mem.eql(u8, arg, "-h") or std.mem.eql(u8, arg, "--help");
}

fn isVersion(arg: []const u8) bool {
    return std.mem.eql(u8, arg, "-v") or std.mem.eql(u8, arg, "--version");
}

pub fn help() void {
    // FIXME: Use io.Writer instead of std.debug but whatever
    std.debug.print("squint {f}\n\n"
        ++ "Usage: squint [ARGS]\n\n"
        ++ "  --profile\tConnection profile config name\n"
        ++ "  --driver\tAny driver supported by adbc_driver_manager\n"
        ++ "  --uri\t\tDatabase connection string parameters\n\n"
        ++ "  --exec\tExecute a string as a query\n"
        ++ "  --interactive\tEnter an interactive prompt after exec or source\n"
        ++ "  --pager\t[on|off] Disable paging. Default on.\n"
        ++ "  --source\tRead and execute a file\n",
        .{version});
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

