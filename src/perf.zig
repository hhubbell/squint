const std = @import("std");
const date = @import("date");

const Io = std.Io;


pub const PerfData = struct {
    const Self = @This();

    last_lap: Io.Clock.Timestamp,
    rows: u64 = 0,
    exec: u64 = 0,
    load: u64 = 0,
    proc: u64 = 0,
    rend: u64 = 0,

    pub fn init(io: Io) Self {
        return .{ .last_lap = .now(io, .real) };
    }

    pub fn lap(self: *Self, io: Io) u64 {
        const l: Io.Clock.Timestamp = .now(io, .real);

        const delta: i64 = l.raw.toMilliseconds() - self.last_lap.raw.toMilliseconds();

        self.last_lap = l;

        // FIXME: If last_lap is ever AFTER current lap, this will crash. It
        // should never happen, but we're depending on the language to handle
        // this instead of being more defensive.
        return @intCast(delta);
    }

    pub fn reset(self: *Self, io: Io) void {
        self.rows = 0;
        self.exec = 0;
        self.load = 0;
        self.proc = 0;
        self.rend = 0;

        self.last_lap = .now(io, .real);
    }

    /// Print performance data
    pub fn format(self: Self, writer: *Io.Writer) !void {
        var exec: [5]u8 = undefined;
        var load: [5]u8 = undefined;
        var proc: [5]u8 = undefined;
        var rend: [5]u8 = undefined;

        date.fmt.toDisplayTime(self.exec, &exec);
        date.fmt.toDisplayTime(self.load, &load);
        date.fmt.toDisplayTime(self.proc, &proc);
        date.fmt.toDisplayTime(self.rend, &rend);

        try writer.print(
            "{d} rows | exec: {s} load: {s} proc: {s} rend: {s}",
            .{ self.rows, exec, load, proc, rend }
        );
    }
};
