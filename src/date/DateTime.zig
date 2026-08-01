const std = @import("std");
const time = std.time;

const Date = @import("Date.zig");
const Time = @import("Time.zig");

const Self = @This();

datepart: Date,
timepart: Time,


/// Given a buffer, print the DateTime in YYYY-MM-DD format.
pub fn asDateString(dt: Self, buf: []u8) ![]u8 {
    return std.fmt.bufPrint(buf,
        "{d:0>4}-{d:0>2}-{d:0>2}", .{
            dt.datepart.year,
            dt.datepart.month,
            dt.datepart.day
        });
}

test "asDateString" {
    var buf: [10]u8 = undefined;
    const epoch: Self = .{
        .datepart = .{
            .year=1970,
            .month=1,
            .day=1
        },
        .timepart = .{
            .hour=0,
            .minute=0,
            .second=0,
            .millisecond=0
        }
    };

    try std.testing.expectEqualStrings(
        "1970-01-01",
        try epoch.asDateString(&buf)
    );
}

/// Given a buffer, print the DateTime in YYYY-MM-DD HH:MM:SS.mmm format.
pub fn asDateTimeString(dt: Self, buf: []u8) ![]u8 {
    return std.fmt.bufPrint(buf,
        "{d:0>4}-{d:0>2}-{d:0>2} {d:0>2}:{d:0>2}:{d:0>2}.{d:0>3}", .{
            dt.datepart.year,
            dt.datepart.month,
            dt.datepart.day,
            dt.timepart.hour,
            dt.timepart.minute,
            dt.timepart.second,
            dt.timepart.millisecond
        });
}

test "asDateTimeString" {
    var buf: [23]u8 = undefined;
    const epoch: Self = .{
        .datepart = .{
            .year=1970,
            .month=1,
            .day=1
        },
        .timepart = .{
            .hour=12,
            .minute=13,
            .second=14,
            .millisecond=987
        }
    };

    try std.testing.expectEqualStrings(
        "1970-01-01 12:13:14.987",
        try epoch.asDateTimeString(&buf)
    );
}

/// Convert a DateTime into the number of days since the UNIX epoch. See
/// https://howardhinnant.github.io/date_algorithms.html for more details
pub fn toEpochDays(dt: Self) i64 {
    return dt.datepart.toEpochDays();
}

test "toEpochDays" {
    try std.testing.expectEqual(
        0,
        toEpochDays(.{
            .datepart = .{
                .year=1970,
                .month=1,
                .day=1
            },
            .timepart = .{
                .hour=0,
                .minute=0,
                .second=0,
                .millisecond=0
            }
        })
    );

    try std.testing.expectEqual(
        20454,
        toEpochDays(.{
            .datepart = .{
                .year=2026,
                .month=1,
                .day=1
            },
            .timepart = .{
                .hour=0,
                .minute=0,
                .second=0,
                .millisecond=0
            }
        })
    );
}

/// Convert an int representing the number of days since the UNIX epoch to a
/// DateTime struct. See https://howardhinnant.github.io/date_algorithms.html
/// for more details.
pub fn fromEpochDays(d: i64) Self {
    const date: Date = .fromEpochDays(d);

    return .{
        .datepart = date,
        .timepart = .{
            .hour = 0,
            .minute = 0,
            .second = 0,
            .millisecond = 0
        }
    };
}

test "fromEpochDays" {
    try std.testing.expectEqual(
        Self{
            .datepart = .{
                .year=1970,
                .month=1,
                .day=1
            },
            .timepart = .{
                .hour=0,
                .minute=0,
                .second=0,
                .millisecond=0
            }
        },
        fromEpochDays(0)
    );

    try std.testing.expectEqual(
        Self{
            .datepart = .{
                .year=2026,
                .month=1,
                .day=1
            },
            .timepart = .{
                .hour=0,
                .minute=0,
                .second=0,
                .millisecond=0
            }
        },
        fromEpochDays(20454)
    );
}

/// Convert a DateTime into the number of milliseconds since the UNIX epoch. See
/// https://howardhinnant.github.io/date_algorithms.html for more details
pub fn toEpochMs(dt: Self) i64 {
    return toEpochDays(dt) * time.ms_per_day
        + @as(i64, dt.timepart.hour) * time.ms_per_hour
        + @as(i64, dt.timepart.minute) * time.ms_per_min
        + @as(i64, dt.timepart.second) * time.ms_per_s
        + @as(i64, dt.timepart.millisecond);
}

test "toEpochMs" {
    try std.testing.expectEqual(
        0,
        toEpochMs(.{
            .datepart = .{
                .year=1970,
                .month=1,
                .day=1
            },
            .timepart = .{
                .hour=0,
                .minute=0,
                .second=0,
                .millisecond=0
            }
        })
    );

    try std.testing.expectEqual(
        1767266553456,
        toEpochMs(.{
            .datepart = .{
                .year=2026,
                .month=1,
                .day=1
            },
            .timepart = .{
                .hour=11,
                .minute=22,
                .second=33,
                .millisecond=456
            }
        })
    );
}

/// Convert an int representing the number of seconds since the UNIX epoch
/// to a DateTime struct. See https://howardhinnant.github.io/date_algorithms.html
/// for more details.
pub fn fromEpochSec(sec: i64) Self {
    var rem = sec;

    const days = @divFloor(rem, time.s_per_day);
    rem -= days * time.s_per_day;

    const d: Date = .fromEpochDays(days);
    const t: Time = .fromMidnightSec(rem);

    return .{
        .datepart = d,
        .timepart = t
    };
}

test "fromEpochSec" {
    try std.testing.expectEqual(
        Self{
            .datepart = .{
                .year=1970,
                .month=1,
                .day=1
            },
            .timepart = .{
                .hour=0,
                .minute=0,
                .second=0,
                .millisecond=0
            }
        },
        fromEpochSec(0)
    );

    try std.testing.expectEqual(
        Self{
            .datepart = .{
                .year=2026,
                .month=1,
                .day=1
            },
            .timepart = .{
                .hour=11,
                .minute=22,
                .second=33,
                .millisecond=0
            }
        },
        fromEpochSec(1767266553)
    );
}

/// Convert an int representing the number of milliseconds since the UNIX epoch
/// to a DateTime struct. See https://howardhinnant.github.io/date_algorithms.html
/// for more details.
pub fn fromEpochMs(ms: i64) Self {
    var rem = ms;

    const days = @divFloor(rem, time.ms_per_day);
    rem -= days * time.ms_per_day;

    const d: Date = .fromEpochDays(days);
    const t: Time = .fromMidnightMs(rem);

    return .{
        .datepart = d,
        .timepart = t
    };
}

test "fromEpochMs" {
    try std.testing.expectEqual(
        Self{
            .datepart = .{
                .year=1970,
                .month=1,
                .day=1
            },
            .timepart = .{
                .hour=0,
                .minute=0,
                .second=0,
                .millisecond=0
            }
        },
        fromEpochMs(0)
    );

    try std.testing.expectEqual(
        Self{
            .datepart = .{
                .year=2026,
                .month=1,
                .day=1
            },
            .timepart = .{
                .hour=11,
                .minute=22,
                .second=33,
                .millisecond=456
            }
        },
        fromEpochMs(1767266553456)
    );
}

/// Convert an int representing the number of microseconds since the UNIX epoch
/// to a DateTime struct. See https://howardhinnant.github.io/date_algorithms.html
/// for more details.
pub fn fromEpochMicro(us: i64) Self {
    return fromEpochMs(@divFloor(us, 1000));
}

/// Convert an int representing the number of nanoseconds since the UNIX epoch
/// to a DateTime struct. See https://howardhinnant.github.io/date_algorithms.html
/// for more details.
pub fn fromEpochNano(ns: i64) Self {
    return fromEpochMs(@divFloor(ns, 1000000));
}
