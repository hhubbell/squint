const std = @import("std");
const h = @import("cheaders.zig");
const stream = @import("stream.zig");

const Allocator = std.mem.Allocator;


const PAD: usize = 2;
pub const GREY: []const u8 = "\x1b[37m";
pub const RESET: []const u8 = "\x1b[0m";

pub const HorizontalSeparator = enum { Top, Middle, Bottom };

pub const Box = struct {
    pub const HorizSep: []const u8 = "\u{2500}";
    pub const VertSep: []const u8 = "\u{2502}";
    pub const LJunc: []const u8 = "\u{251C}";
    pub const RJunc: []const u8 = "\u{2524}";
    pub const FJunc: []const u8 = "\u{253C}";
    pub const TJunc: []const u8 = "\u{252C}";
    pub const BJunc: []const u8 = "\u{2534}";
    pub const LUpCor: []const u8 = "\u{250C}";
    pub const RUpCor: []const u8 = "\u{2510}";
    pub const LBotCor: []const u8 = "\u{2514}";
    pub const RBotCor: []const u8 = "\u{2518}";
};


/// Wrap a string with padding so that it is centered as much as possible
/// within the pad. 
pub fn padValue(alloc: Allocator, value: []const u8, padding: usize) ![]u8 {
    const full = value.len + padding;
    const lpad = @divFloor(padding, 2);
    const rpad = padding - lpad;

    var padded_value: []u8 = try alloc.alloc(u8, full);

    @memset(padded_value[0..lpad], ' ');
    @memcpy(padded_value[lpad..full - rpad], value);
    @memset(padded_value[full - rpad..full], ' ');

    return padded_value;
}

pub fn printHeader(alloc: Allocator, header: []stream.ColMetadata) ![]const u8 {
    const top = try printHorizSep(alloc, header, .Top);
    defer alloc.free(top);
    const mid = try printHorizSep(alloc, header, .Middle);
    defer alloc.free(mid);

    // This does not ensure this will be alloc-free but I think it helps?
    var buf: std.ArrayList(u8) = try .initCapacity(alloc, top.len + mid.len + 3);

    try buf.appendSlice(alloc, top);
    try buf.append(alloc, '\n');

    for (header, 0..) |col, i| {
        if (i == 0) try buf.appendSlice(alloc, Box.VertSep);
        const pad_f = padValue(alloc, col.name, PAD) catch "<err>";
        const col_f = try std.fmt.allocPrint(alloc, "{[value]s:<[width]}{[sep]s}", .{
            .value = pad_f,
            .width = col.width,
            .sep = Box.VertSep});

        try buf.appendSlice(alloc, col_f);
        alloc.free(pad_f);
        alloc.free(col_f);
    }
    try buf.append(alloc, '\n');

    try buf.appendSlice(alloc, mid);
    try buf.append(alloc, '\n');

    return buf.toOwnedSlice(alloc);
}

pub fn printHorizSep(alloc: Allocator, header: []stream.ColMetadata, orientation: HorizontalSeparator) ![]const u8 {
    var buf: std.ArrayList(u8) = .empty;

    var l_s: []const u8 = undefined;
    var i_s: []const u8 = undefined;
    var r_s: []const u8 = undefined;

    switch (orientation) {
        .Top => {
            l_s = Box.LUpCor;
            i_s = Box.TJunc;
            r_s = Box.RUpCor;
        },
        .Middle => {
            l_s = Box.LJunc;
            i_s = Box.FJunc;
            r_s = Box.RJunc;
        },
        .Bottom => {
            l_s = Box.LBotCor;
            i_s = Box.BJunc;
            r_s = Box.RBotCor;
        }
    }

    for (0..header.len) |i| {
        if (i == 0) try buf.appendSlice(alloc, l_s);

        // There's probably a neat way to do this without a loop
        // but tricky w/ unicode
        for (0..header[i].width) |_| {
            try buf.appendSlice(alloc, Box.HorizSep);
        }

        if (i < header.len - 1) {
            try buf.appendSlice(alloc, i_s);
        } else {
            try buf.appendSlice(alloc, r_s);
        }
    }

    return buf.toOwnedSlice(alloc);
}

