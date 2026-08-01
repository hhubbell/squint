const std = @import("std");
const time = std.time;

const Self = @This();

hour: u8,
minute: u8,
second: u8,
millisecond: u16,


/// Given a buffer, print the Time in HH:MM:SS.mmm format.
pub fn asTimeString(ts: Self, buf: []u8) ![]u8 {
    return std.fmt.bufPrint(buf,
        "{d:0>2}:{d:0>2}:{d:0>2}.{d:0>3}", .{
            ts.hour,
            ts.minute,
            ts.second,
            ts.millisecond
        });
}

/// Convert an int representing the number of seconds since midnight to a
/// Time struct.
pub fn fromMidnightSec(sec: i64) Self {
    var rem = sec;

    const hrs = @divTrunc(rem, time.s_per_hour);
    rem -= hrs * time.s_per_hour;

    const mins = @divTrunc(rem, time.s_per_min);
    rem -= mins * time.s_per_min;

    return .{
        .hour = @intCast(hrs),
        .minute = @intCast(mins),
        .second = @intCast(rem),
        .millisecond = 0
    };
}

/// Convert an int representing the number of milliseconds since midnight to a
/// Time struct.
pub fn fromMidnightMs(ms: i64) Self {
    var rem = ms;

    const hrs = @divTrunc(rem, time.ms_per_hour);
    rem -= hrs * time.ms_per_hour;

    const mins = @divTrunc(rem, time.ms_per_min);
    rem -= mins * time.ms_per_min;

    const secs = @divTrunc(rem, time.ms_per_s);
    rem -= secs * time.ms_per_s;

    return .{
        .hour = @intCast(hrs),
        .minute = @intCast(mins),
        .second = @intCast(secs),
        .millisecond = @intCast(rem)
    };
}

/// Convert an int representing the number of microseconds since midnight to a
/// Time struct.
pub fn fromMidnightMicro(us: i64) Self {
    return fromMidnightMs(@divFloor(us, 1000));
}

/// Convert an int representing the number of nanoseconds since midnight to a
/// Time struct.
pub fn fromMidnightNano(us: i64) Self {
    return fromMidnightMs(@divFloor(us, 1000000));
}
