const std = @import("std");
const time = std.time;

const Self = @This();

year: u32,
month: u8,
day: u8,


/// Given a buffer, print the DateTime in YYYY-MM-DD format.
pub fn asDateString(dt: Self, buf: []u8) ![]u8 {
    return std.fmt.bufPrint(buf,
        "{d:0>4}-{d:0>2}-{d:0>2}", .{
            dt.year,
            dt.month,
            dt.day
        });
}

test "asDateString" {
    var buf: [10]u8 = undefined;
    const epoch: Self = .{
        .year=1970,
        .month=1,
        .day=1
    };

    try std.testing.expectEqualStrings(
        "1970-01-01",
        try epoch.asDateString(&buf)
    );
}

/// Convert a Date into the number of days since the UNIX epoch. See
/// https://howardhinnant.github.io/date_algorithms.html for more details
pub fn toEpochDays(dt: Self) i64 {
    const yr: u32 = dt.year - @intFromBool(dt.month <= 2);
    const mo: u32 = if (dt.month <= 2) dt.month + 9 else dt.month - 3;

    const era = @divFloor(yr, 400);
    const yoe = @mod(yr, 400);
    const doy = @divTrunc(153 * mo + 2, 5) + dt.day - 1;
    const doe = yoe * 365 + @divTrunc(yoe, 4) - @divTrunc(yoe, 100) + doy;

    return era * 146097 + doe - 719468;
}

test "toEpochDays" {
    try std.testing.expectEqual(
        0,
        toEpochDays(.{
            .year=1970,
            .month=1,
            .day=1
        })
    );

    try std.testing.expectEqual(
        20454,
        toEpochDays(.{
            .year=2026,
            .month=1,
            .day=1
        })
    );
}

/// Convert an int representing the number of days since the UNIX epoch to a
/// Date struct. See https://howardhinnant.github.io/date_algorithms.html
/// for more details.
pub fn fromEpochDays(d: i64) Self {
    const days: i64 = d + 719468;

    const era = @divFloor(days, 146097);
    const doe = @mod(days, 146097);
    
    const yoe = @divTrunc(doe
            - @divTrunc(doe, 1460)
            + @divTrunc(doe, 36524)
            - @divTrunc(doe, 146096),
        365);
    const yr = yoe + era * 400;
    
    const doy = doe - (365 * yoe + @divTrunc(yoe, 4) - @divTrunc(yoe, 100));
    const mp = @divTrunc(5 * doy + 2, 153);
    
    const dy = doy - @divTrunc(153 * mp + 2, 5) + 1;
    const mo = if (mp < 10) mp + 3 else mp - 9;

    return .{
        .year = @intCast(if (mo <= 2) yr + 1 else yr),
        .month = @intCast(mo),
        .day = @intCast(dy)
    };
}

