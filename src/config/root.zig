const std = @import("std");

const Allocator = std.mem.Allocator;
const Dir = std.Io.Dir;
const Environ = std.process.Environ;
const Io = std.Io;

pub const CONFIG_PATH: []const u8 = ".config/squint";

pub const Duckdb = @import("Duckdb.zig");
pub const Postgresql = @import("Postgresql.zig");
pub const Snowflake = @import("Snowflake.zig");
pub const Sqlite = @import("Sqlite.zig");


pub const Drivers = enum {
    duckdb, postgresql, snowflake, sqlite
};

pub const DriverConfig = union(Drivers) {
    duckdb: Duckdb,
    postgresql: Postgresql,
    snowflake: Snowflake,
    sqlite: Sqlite
};

pub const AdbcDriverMap = std.StaticStringMap(Drivers).initComptime(.{
    .{ "duckdb", .duckdb },
    .{ "postgresql", .postgresql },
    .{ "sqlite",  .sqlite },
    .{ "snowflake", .snowflake }
});

pub const ConfigKeyValue = struct {
    key: []const u8,
    val: ?[]const u8
};

pub const Config = struct {
    const Self = @This();

    driver: []const u8,
    profile: DriverConfig,

    pub fn getUri(self: Self) []const u8 {
        switch (self.profile) {
            inline else => |t| return t.uri
        }
    }

    /// TODO: This would be nice if we followed the .next() pattern instead
    /// of returning a slice of tuples. But this gets us going at least
    pub fn iterFields(self: Self, alloc: Allocator) ![]ConfigKeyValue {
        switch (self.profile) {
            inline else => |t| {
                const T = @TypeOf(t);
                const info = @typeInfo(T);
                const fields = switch(info) {
                    .@"struct" => |s| s.field_names,
                    else => unreachable
                };

                const res: []ConfigKeyValue = try alloc.alloc(ConfigKeyValue, fields.len);

                inline for (fields, 0..) |f, i| {
                    res[i] = .{ .key = f, .val = @field(t, f) };
                }

                return res;
            }
        }
    }
};


pub fn readConfig(
    io: Io,
    alloc: Allocator,
    path: []const u8,
    comptime T: type
) !std.json.Parsed(T) {
    const file = try Dir.cwd().openFile(io, path, .{});
    defer file.close(io);

    // NOTE: Do not free the buffer here as long as we are using and arena
    // allocator. Hold it till the end and the arena will free it.
    const fsize = try file.length(io);
    const buffer = try alloc.alloc(u8, fsize);

    var reader: Io.File.Reader = file.reader(io, buffer);
    try reader.interface.readSliceAll(buffer);

    return std.json.parseFromSlice(T, alloc, buffer, .{});
}

pub fn readProfile(
    io: Io,
    alloc: Allocator,
    env: *Environ.Map,
    driver: []const u8,
    profile: []const u8
) !Config {
    const home = env.get("HOME") orelse return error.ProfileError;
    const path = try std.fs.path.join(alloc, &.{ home, CONFIG_PATH, profile });
    defer alloc.free(path);

    const tag = AdbcDriverMap.get(driver) orelse return error.ProfileError;

    switch (tag) {
        inline else => |t| {
            const T = comptime switch (t) {
                .duckdb => Duckdb,
                .postgresql => Postgresql,
                .snowflake => Snowflake,
                .sqlite => Sqlite
            };

            const parsed = try readConfig(io, alloc, path, T);
            defer parsed.deinit();

            return .{
                .driver = driver,
                .profile = @unionInit(DriverConfig, @tagName(t), parsed.value)
            };
        }
    }
}

pub fn simpleConfig(driver: []const u8, uri: []const u8) !Config {
    const tag = AdbcDriverMap.get(driver) orelse return error.ProfileError;

    const profile = switch (tag) {
        inline else => |t| @unionInit(DriverConfig, @tagName(t), .{ .uri = uri }),
    };

    return .{
        .driver = driver,
        .profile = profile
    };
}

