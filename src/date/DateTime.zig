const std = @import("std");
const time = std.time;

const Self = @This();

year: u32,
month: u8,
day: u8,
hour: u8,
minute: u8,
second: u8,
millisecond: u16,


/// Convert a DateTime into the number of days since the UNIX epoch. See
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
        .day = @intCast(dy),
        .hour = 0,
        .minute = 0,
        .second = 0,
        .millisecond = 0
    };
}

test "fromEpochDays" {
    try std.testing.expectEqual(
        Self{
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
        Self{
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

/// Convert a DateTime into the number of milliseconds since the UNIX epoch. See
/// https://howardhinnant.github.io/date_algorithms.html for more details
pub fn toEpochMs(dt: Self) i64 {
    return toEpochDays(dt) * time.ms_per_day
        + @as(i64, dt.hour) * time.ms_per_hour
        + @as(i64, dt.minute) * time.ms_per_min
        + @as(i64, dt.second) * time.ms_per_s
        + @as(i64, dt.millisecond);
}

test "toEpochMs" {
    try std.testing.expectEqual(
        0,
        toEpochMs(.{
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
        1767266553456,
        toEpochMs(.{
            .year=2026,
            .month=1,
            .day=1,
            .hour=11,
            .minute=22,
            .second=33,
            .millisecond=456
        })
    );
}

/// Convert an int representing the number of milliseconds since the UNIX epoch
/// to a DateTime struct. See https://howardhinnant.github.io/date_algorithms.html
/// for more details.
pub fn fromEpochMs(ms: i64) Self {
    var rem = ms;

    const days = @divFloor(ms, time.ms_per_day);
    rem -= days * time.ms_per_day;

    const hrs = @divTrunc(rem, time.ms_per_hour);
    rem -= hrs * time.ms_per_hour;

    const mins = @divTrunc(rem, time.ms_per_min);
    rem -= mins * time.ms_per_min;

    const secs = @divTrunc(rem, time.ms_per_s);
    rem -= secs * time.ms_per_s;

    var ymd = fromEpochDays(days);

    ymd.hour = @intCast(hrs);
    ymd.minute = @intCast(mins);
    ymd.second = @intCast(secs);
    ymd.millisecond = @intCast(rem);

    return ymd;
}

test "fromEpochMs" {
    try std.testing.expectEqual(
        Self{
            .year=1970,
            .month=1,
            .day=1,
            .hour=0,
            .minute=0,
            .second=0,
            .millisecond=0
        },
        fromEpochMs(0)
    );

    try std.testing.expectEqual(
        Self{
            .year=2026,
            .month=1,
            .day=1,
            .hour=11,
            .minute=22,
            .second=33,
            .millisecond=456
        },
        fromEpochMs(1767266553456)
    );
}

