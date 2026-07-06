const std = @import("std");
const config = @import("config");
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
        try self.vargs.put(alloc, key[2..], val);
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

        // The first argument of the cli should be the driver to use for
        // the connection. If it isn't, then print help and exit.
        const driver: ?[]const u8 = args.next();
        if (driver == null or isHelp(driver.?)) {
            help();
            std.process.exit(0);
        } else if (isLongArg(driver.?) or isShortArg(driver.?)) {
            // FIXME: Use io.Writer instead of std.debug but whatever
            std.debug.print("Incorrect program invocation.\n\n", .{});

            help();
            std.process.exit(0);
        } else {
            // NOTE: This is technically unnecessary but provides an earlier
            // failure mode if an invald driver was passed to the application.
            // The adbc spec defines a directory structure and toml config
            // entry point. We can refer to drivers by name instead of by
            // their static library
            if (!config.AdbcDriverMap.has(driver.?)) {
                return error.UnsupportedDriverError;
            }

            try self.vargs.put(alloc, "driver", driver.?);
        }

        while (args.next()) |arg| {
            if (isHelp(arg)) {
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


fn isHelp(arg: []const u8) bool {
    return std.mem.eql(u8, arg, "-h") or std.mem.eql(u8, arg, "--help");
}

pub fn help() void {
    // FIXME: Use io.Writer instead of std.debug but whatever
    std.debug.print("squint [DRIVER] [ARGS]\n"
        ++ "  driver\tAny driver supported by adbc_driver_manager\n"
        ++ "  --uri\t\tDatabase connection string parameters\n\n"
        ++ "  --profile\tConnection profile config name\n\n",
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

