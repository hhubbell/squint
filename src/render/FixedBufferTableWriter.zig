const std = @import("std");
const adbc = @import("adbc");

const Color = @import("Color.zig");
const Shape = @import("Shape.zig");

const Allocator = std.mem.Allocator;
const Io = std.Io;

const PAD: usize = 2;
const HorizontalSeparator = enum { Top, Middle, Bottom };

const Self = @This();


interface: *Io.Writer,


pub fn init(interface: *Io.Writer) Self {
    return .{ .interface = interface };
}

/// Determine the required buffer size for printing a stream result set. By
// calculating the required buffer size ahead of time, instead of dynamically
// allocating to build the string at print time, we save a substantial amount
// of time rendering.
pub fn calcResultBufSize(meta: []adbc.ColMetadata, rows: u64) u64 {
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
fn calcRowBufSize(meta: []adbc.ColMetadata) u64 {
    const sep_w: u64 = Shape.Box.VertSep.len;
    const nl_w: u64 = "\n".len;

    var accum: u64 = sep_w; 

    for (meta) |col| {
        accum += col.data.bytes + PAD + sep_w;
    }

    accum += nl_w;

    return accum;
}

/// Determine the required buffer size for printing one row of box drawing
/// characters. E.g. top border, bottom border.
fn calcRowBoxSize(meta: []adbc.ColMetadata) u64 {
    const sep_w: u64 = Shape.Box.VertSep.len;
    const nl_w: u64 = "\n".len;

    var accum: u64 = sep_w; 

    for (meta) |col| {
        accum += ((col.data.width + PAD) * sep_w) + sep_w;
    }

    accum += nl_w;

    return accum;
}

/// Determine the required buffer size for printing all color escape sequences
fn calcColorBufSize(meta: []adbc.ColMetadata) u64 {
    var accum: u64 = 0;

    for (meta) |col| {
        accum += @intCast(col.data.color_slots * (Color.Grey.len + Color.Reset.len));
    }

    return accum;
}

/// Write a TableBuffer to an Io.Writer interface, by way of a fixed backing
/// buffer that is sized to contain the entire write in one string. Sometimes
/// this writer is faster than StreamingTableBuffer. This was the original
/// TableWriter, but StreamingTableWriter is easier to reason about.
pub fn write(
    self: Self,
    gpa: Allocator,
    asb: *adbc.TableBuffer
) !void {
    var buffer: []u8 = try gpa.alloc(u8, calcResultBufSize(
        asb.metadata.?,
        asb.countRows()));
    defer gpa.free(buffer);

    const box_w = calcRowBoxSize(asb.metadata.?);

    var idx: usize = writeHeader(&buffer, asb.metadata.?);

    var iter: adbc.TableBuffer.Iterator = try asb.iter(.colwise);
    while (iter.next()) |slot| {
        idx += writeBuffer(&buffer, Shape.Box.VertSep, idx);

        var byte_w = asb.metadata.?[slot.col].data.bytes + PAD;

        if (adbc.meta.isNull(slot.view, slot.row)) {
            byte_w += Color.Grey.len + Color.Reset.len;

            idx += padCenterValue(
                @constCast(&buffer[idx..idx + byte_w]),
                Color.Grey ++ "null" ++ Color.Reset);
        } else {
            const val_str = adbc.meta.extractValue(
                slot.meta,
                buffer[idx..idx + byte_w],
                slot.view,
                slot.row);

            if (adbc.meta.isNumeric(slot.view)) {
                idx += padRightJustValue(
                    @constCast(&buffer[idx..idx + byte_w]),
                    val_str);
            } else {
                idx += padLeftJustValue(
                    @constCast(&buffer[idx..idx + byte_w]),
                    val_str);
            }
        }

        if (slot.col >= iter.table.countCols() - 1) {
            idx += writeBuffer(&buffer, Shape.Box.VertSep, idx);
            idx += writeBuffer(&buffer, "\n", idx);
        }
    }

    idx += writeHorizSep(@constCast(&buffer[idx..idx + box_w]), asb.metadata.?, .Bottom);

    var source: Io.Reader = .fixed(buffer);
    _ = try source.streamRemaining(self.interface);
    try self.interface.flush();
}

/// Copy a value slice to buffer. Return the number of bytes written.
fn writeBuffer(buffer: *[]u8, value: []const u8, i: usize) usize {
    const until = i + value.len;

    @memcpy(buffer.*[i..until], value);

    return value.len;
}

/// Given a slice of ColMetadata, generate a header for the table with box
/// drawing characters.
fn writeHeader(buffer: *[]u8, header: []adbc.ColMetadata) usize {
    const box_w = calcRowBoxSize(header);

    var idx: usize = 0;
    idx = writeHorizSep(@constCast(&buffer.*[idx..idx + box_w]), header, .Top);
    idx += writeBuffer(buffer, Shape.Box.VertSep, idx);

    for (header) |col| {
        var colbuf: []u8 = buffer.*[idx..idx + col.data.width + PAD];
        idx += padCenterValue(&colbuf, col.name);
        idx += writeBuffer(buffer, Shape.Box.VertSep, idx);
    }

    idx += writeBuffer(buffer, "\n", idx);

    idx += writeHorizSep(@constCast(&buffer.*[idx..idx + box_w]), header, .Middle);

    return idx;
}

/// Print the border horizontal separator to a buffer.
/// Return the number of bytes written
fn writeHorizSep(
    buffer: *[]u8,
    header: []adbc.ColMetadata,
    orientation: HorizontalSeparator
) usize {
    var l_s: []const u8 = undefined;
    var i_s: []const u8 = undefined;
    var r_s: []const u8 = undefined;

    switch (orientation) {
        .Top => {
            l_s = Shape.Box.LUpCor;
            i_s = Shape.Box.TJunc;
            r_s = Shape.Box.RUpCor;
        },
        .Middle => {
            l_s = Shape.Box.LJunc;
            i_s = Shape.Box.FJunc;
            r_s = Shape.Box.RJunc;
        },
        .Bottom => {
            l_s = Shape.Box.LBotCor;
            i_s = Shape.Box.BJunc;
            r_s = Shape.Box.RBotCor;
        }
    }

    var idx: usize = 0;

    idx += writeBuffer(buffer, l_s, idx);

    for (header, 0..) |col, i| {
        // There's probably a neat way to do this without a loop
        // but tricky w/ unicode
        for (0..col.data.width + PAD) |_| {
            idx += writeBuffer(buffer, Shape.Box.HorizSep, idx);
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

// Copy a string buffer to another string buffer and center the string as
// much as possible
fn padCenterValue(buffer: *[]u8, value: []const u8) usize {
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
fn padLeftJustValue(buffer: *[]u8, value: []const u8) usize {
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
fn padRightJustValue(buffer: *[]u8, value: []const u8) usize {
    const full = buffer.*.len;
    const pad = full - value.len;
    const rpad = 1;
    const lpad = pad - rpad;

    @memmove(buffer.*[lpad..full - rpad], value);
    @memset(buffer.*[0..lpad], ' ');
    @memset(buffer.*[full - rpad..full], ' ');

    return full;
}

