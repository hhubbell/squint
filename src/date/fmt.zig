const std = @import("std");

const DateTime = @import("DateTime.zig");

const time = std.time;


/// Convert an unsigned integer representing a time delta in milliseconds to
/// a character buffer which is at most 5 characters. Therefore, we have a
/// small amount of room to deal with to render the display. For example, a
/// performance point which takes 2500 milliseconds could be simplified to
/// something like 2.5s
pub fn toDisplayTime(ms: u64, buf: []u8) []u8 {
    const ERR = "ERR!!";

    if (ms < time.ms_per_s) {
        return std.fmt.bufPrint(buf, "{d}ms", .{ms}) catch @constCast(ERR);
    }

    if (ms < time.ms_per_min) {
        const f_ms: f32 = @floatFromInt(ms);
        const sec: f32 = f_ms / time.ms_per_s;
        return std.fmt.bufPrint(buf, "{d:.1}s", .{sec}) catch @constCast(ERR);
    }

    // Beyond this point it's more straightforward to use DateTime
    const dt = DateTime.fromEpochMs(@intCast(ms));

    if (ms < time.ms_per_min * 10) {
        return std.fmt.bufPrint(buf, "{d:.0}m{d:.0}s", .{
            dt.timepart.minute,
            dt.timepart.second
        }) catch @constCast(ERR);
    }

    if (ms < time.ms_per_hour) {
        return std.fmt.bufPrint(buf, "{d:.0}m", .{dt.timepart.minute}) catch @constCast(ERR);
    }

    if (ms < time.ms_per_hour * 10) {
        return std.fmt.bufPrint(buf, "{d:.0}h{d:.0}m", .{
            dt.timepart.hour,
            dt.timepart.minute
        }) catch @constCast(ERR);
    }

    return @constCast("LONG!");
}

test "toDisplayTime" {
    var buf: [5]u8 = undefined;

    try std.testing.expectEqualStrings("0ms",
        toDisplayTime(0, &buf));
    try std.testing.expectEqualStrings("2.5s",
        toDisplayTime(2500, &buf));
    try std.testing.expectEqualStrings("15.0s",
        toDisplayTime(time.ms_per_s * 15, &buf));
    try std.testing.expectEqualStrings("1m0s",
        toDisplayTime(time.ms_per_min, &buf));
    try std.testing.expectEqualStrings("1m10s",
        toDisplayTime(time.ms_per_min + time.ms_per_s * 10, &buf));
    try std.testing.expectEqualStrings("10m",
        toDisplayTime(time.ms_per_min * 10, &buf));
    try std.testing.expectEqualStrings("1h5m",
        toDisplayTime(time.ms_per_hour + time.ms_per_min * 5, &buf));
    try std.testing.expectEqualStrings("LONG!",
        toDisplayTime(time.ms_per_day, &buf));
}
