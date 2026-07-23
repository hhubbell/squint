const std = @import("std");
const time = std.time;


pub const DateTime = struct {
    year: u32,
    month: u8,
    day: u8,
    hour: u8,
    minute: u8,
    second: u8,
    millisecond: u8
};


/// Convert a DateTime into the number of days since the UNIX epoch. See
/// https://howardhinnant.github.io/date_algorithms.html for more details
pub fn toEpochDays(dt: DateTime) i64 {
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
            .day=1,
            .hour=0,
            .minute=0,
            .second=0,
            .millisecond=0
        })
    );

    try std.testing.expectEqual(
        20454,
        toEpochDays(.{
            .year=2026,
            .month=1,
            .day=1,
            .hour=0,
            .minute=0,
            .second=0,
            .millisecond=0
        })
    );
}

/// Convert an int representing the number of days since the UNIX epoch to a
/// DateTime struct. See https://howardhinnant.github.io/date_algorithms.html
/// for more details.
pub fn fromEpochDays(d: i64) DateTime {
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
        .day = @intCast(dy),
        .hour = 0,
        .minute = 0,
        .second = 0,
        .millisecond = 0
    };
}

test "fromEpochDays" {
    try std.testing.expectEqual(
        DateTime{
            .year=1970,
            .month=1,
            .day=1,
            .hour=0,
            .minute=0,
            .second=0,
            .millisecond=0
        },
        fromEpochDays(0)
    );

    try std.testing.expectEqual(
        DateTime{
            .year=2026,
            .month=1,
            .day=1,
            .hour=0,
            .minute=0,
            .second=0,
            .millisecond=0
        },
        fromEpochDays(20454)
    );
}

test {
    std.testing.refAllDecls(@This());
}
