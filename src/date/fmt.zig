const std = @import("std");


/// Convert an unsigned integer representing a time delta in milliseconds to
/// a character buffer which is at most 5 characters. Therefore, we have a
/// small amount of room to deal with to render the display. For example, a
/// performance point which takes 2500 milliseconds could be simplified to
/// something like 2.5s
pub fn toDisplayTime(ms: u64, buf: *[5]u8) void {

    if (ms < 1000) {
        _ = std.fmt.bufPrint(buf, "{d}ms", .{ms}) catch @memcpy(buf, "ERR!!");
        return;
    }

    if (ms < 10000) {
        const f_ms: f32 = @floatFromInt(ms);
        const sec: f32 = f_ms / 1000.0;
        _ = std.fmt.bufPrint(buf, "{d:.1}s", .{sec}) catch @memcpy(buf, "ERR!!");
        return;
    }

    if (ms < 60000) {
        const f_ms: f32 = @floatFromInt(ms);
        const sec: f32 = f_ms / 1000.0;

        _ = std.fmt.bufPrint(buf, "{d:.0}s", .{sec}) catch @memcpy(buf, "ERR!!");
        return;
    }

    @memcpy(buf, "LONG!");
}
