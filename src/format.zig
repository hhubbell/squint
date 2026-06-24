const std = @import("std");
const time = std.time;
const c = @import("c");

const stream = @import("stream.zig");
const perf = @import("perf.zig");

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


/// Convert an unsigned integer representing a time delta in nanoseconds to
/// an unsigned integer representing a time delta in milliseconds
pub fn toMs(ns: u64) u64 {
    return ns / time.ns_per_ms;
}

/// Determine the required buffer size for printing a stream result set
pub fn calcResultBufSize(meta: []stream.ColMetadata, rows: u64) u64 {

    // Determine the buffer size needed to print a single row
    const row_buf: u64 = calcRowBufSize(meta);

    // Determine the buffer size needed to print a horizontal border
    const box_buf: u64 = calcRowBoxSize(meta);

    // Determine the buffer size needed to print ansi color escape sequences
    const clr_buf: u64 = calcColorBufSize(meta);

    // Multiply by 4 for the header and box borders.
    //  1: Top border
    //  2: Column names
    //  3: Header/row separator
    //  4: Bottom border
    // WARNING: This an approximation and needs to be solidified to use
    // the actual characters that will be printed.
    const outer_wrap: u64 = (
        // 1, 3, 4
        box_buf * 3
        // 2
        + row_buf);

    // Multiply by rows for all rows
    const inner_vals: u64 = row_buf * rows;

    return outer_wrap + inner_vals + clr_buf;
}

/// Determine the required buffer size for printing one row without the
/// header
pub fn calcRowBufSize(meta: []stream.ColMetadata) u64 {
    const sep_w: u64 = Box.VertSep.len; // For col sep box char
    const nl_w: u64 = "\n".len;         // Newline len

    var accum: u64 = sep_w; 

    for (meta) |col| {
        accum += col.bytes + PAD + sep_w;
    }

    accum += nl_w;

    return accum;
}

/// Determine the required buffer size for printing one row of box drawing
/// characters. E.g. top border, bottom border.
pub fn calcRowBoxSize(meta: []stream.ColMetadata) u64 {
    const sep_w: u64 = Box.VertSep.len; // For col sep box char
    const nl_w: u64 = "\n".len;         // Newline len

    var accum: u64 = sep_w; 

    for (meta) |col| {
        accum += ((col.width + PAD) * sep_w) + sep_w;
    }

    accum += nl_w;

    return accum;
}

/// Determine the required buffer size for printing all color escape sequences
pub fn calcColorBufSize(meta: []stream.ColMetadata) u64 {
    var accum: u64 = 0;

    for (meta) |col| {
        accum += @intCast(col.color_slots * (GREY.len + RESET.len));
    }

    return accum;
}

// Copy a string buffer to another string buffer and center the string as
// much as possible
pub fn padCenterValue(buffer: *[]u8, value: []const u8) usize {
    const full = buffer.*.len;
    const pad = full - value.len;
    const lpad = @divFloor(pad, 2);
    const rpad = pad - lpad;

    @memmove(buffer.*[lpad..full - rpad], value);
    @memset(buffer.*[0..lpad], ' ');
    @memset(buffer.*[full - rpad..full], ' ');

    return full;
}

// Copy a string buffer to another string buffer and left-justify the string
// as much as possible
pub fn padLeftJustValue(buffer: *[]u8, value: []const u8) usize {
    const full = buffer.*.len;
    const pad = full - value.len;
    const lpad = 1;
    const rpad = pad - lpad;

    @memmove(buffer.*[lpad..full - rpad], value);
    @memset(buffer.*[0..lpad], ' ');
    @memset(buffer.*[full - rpad..full], ' ');

    return full;
}

// Copy a string buffer to another string buffer and right-justify the string
// as much as possible
pub fn padRightJustValue(buffer: *[]u8, value: []const u8) usize {
    const full = buffer.*.len;
    const pad = full - value.len;
    const rpad = 1;
    const lpad = pad - rpad;

    @memmove(buffer.*[lpad..full - rpad], value);
    @memset(buffer.*[0..lpad], ' ');
    @memset(buffer.*[full - rpad..full], ' ');

    return full;
}

pub fn printHeader(buffer: *[]u8, header: []stream.ColMetadata) usize {
    const box_w = calcRowBoxSize(header);

    var fmtbuf = buffer.*;

    var idx: usize = 0;
    idx = printHorizSep(@constCast(&fmtbuf[idx..idx + box_w]), header, .Top);
    idx += writeBuffer(&fmtbuf, Box.VertSep, idx);

    for (header) |col| {
        var colbuf: []u8 = fmtbuf[idx..idx + col.width + PAD];
        idx += padCenterValue(&colbuf, col.name);
        idx += writeBuffer(&fmtbuf, Box.VertSep, idx);
    }

    idx += writeBuffer(&fmtbuf, "\n", idx);

    idx += printHorizSep(@constCast(&fmtbuf[idx..idx + box_w]), header, .Middle);

    return idx;
}

/// Print the border horizontal separator to a buffer.
/// Return the number of bytes written
pub fn printHorizSep(buffer: *[]u8, header: []stream.ColMetadata, orientation: HorizontalSeparator) usize {
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

    var idx: usize = 0;

    idx += writeBuffer(buffer, l_s, idx);

    for (header, 0..) |col, i| {
        // There's probably a neat way to do this without a loop
        // but tricky w/ unicode
        for (0..col.width + PAD) |_| {
            idx += writeBuffer(buffer, Box.HorizSep, idx);
        }

        if (i < header.len - 1) {
            idx += writeBuffer(buffer, i_s, idx);
        } else {
            idx += writeBuffer(buffer, r_s, idx);
        }
    }

    idx += writeBuffer(buffer, "\n", idx);

    return idx;
}

pub fn printStreamBuffer(buffer: *[]u8, asb: *stream.ArrowStreamBuffer) !void {
    const box_w = calcRowBoxSize(asb.metadata.?);

    var view: c.ArrowArrayView = std.mem.zeroInit(c.ArrowArrayView, .{});
    try stream.checkNanoArrow(c.ArrowArrayViewInitFromSchema(&view, &asb.schema, &asb.err));

    var idx: usize = printHeader(buffer, asb.metadata.?);

    for (0..asb.filled) |i| {
        const batch = asb.items[i];
        try stream.checkNanoArrow(c.ArrowArrayViewSetArray(&view, &batch, &asb.err));

        for (0..asb.batch_sz[i]) |r_i| {
            var rowbuf = buffer.*[idx..];
            var rb_idx: usize = 0;

            // Left side of table border
            rb_idx += writeBuffer(&rowbuf, Box.VertSep, rb_idx);

            for (0..@intCast(view.n_children)) |c_i| {
                const col = view.children[c_i];
                var byte_w = asb.metadata.?[c_i].bytes + PAD;
                var cb_idx: usize = 0;

                if (stream.isNull(col, r_i)) {
                    // We need a slightly larger buffer for printing values with
                    // color highlighting
                    byte_w += GREY.len + RESET.len;

                    var colbuf = rowbuf[rb_idx..rb_idx + byte_w];
                    cb_idx += padCenterValue(&colbuf, GREY ++ "null" ++ RESET);
                } else {
                    var colbuf = rowbuf[rb_idx..rb_idx + byte_w];
                    const val_str = stream.extractValue(&asb.metadata.?[c_i], colbuf, col, r_i);
                    if (stream.isNumeric(col)) {
                        cb_idx += padRightJustValue(&colbuf, val_str);
                    } else {
                        cb_idx += padLeftJustValue(&colbuf, val_str);
                    }
                }

                rb_idx += cb_idx;
                rb_idx += writeBuffer(&rowbuf, Box.VertSep, rb_idx);
            }

            rb_idx += writeBuffer(&rowbuf, "\n", rb_idx);

            idx += rb_idx;
        }
    }

    idx += printHorizSep(@constCast(&buffer.*[idx..idx + box_w]), asb.metadata.?, .Bottom);

}

/// Print performance data
pub fn printPerfData(alloc: Allocator, perfd: perf.PerfData) void {
    _ = alloc;

    var buf: [55]u8 = undefined;
    const row = std.fmt.bufPrint(&buf, "{d} rows / {d} bytes", .{perfd.rows, perfd.bufsz}) catch "ERROR!";

    const prep = toMs(perfd.prep);
    const exec = toMs(perfd.exec);
    const proc = toMs(perfd.proc);
    const rend = toMs(perfd.rend);

    std.debug.print("{s} | prepare: {d}ms exec: {d}ms process: {d}ms render: {d}ms\n", .{row, prep, exec, proc, rend});
}

/// Copy a value slice to buffer. Return the number of bytes written.
fn writeBuffer(buffer: *[]u8, value: []const u8, i: usize) usize {
    const until = i + value.len;

    @memcpy(buffer.*[i..until], value);

    //std.debug.print("{s}\n", .{buffer.*});

    return value.len;
}
