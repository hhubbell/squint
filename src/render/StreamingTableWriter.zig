const std = @import("std");
const adbc = @import("adbc");
const c = @import("c");

const Color = @import("Color.zig");

const Allocator = std.mem.Allocator;
const Io = std.Io;


const PAD: usize = 2;

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


/// Determine the required min buffer size for printing a column by returning
/// the widest column width
pub fn calcMaxWidth(meta: []adbc.ColMetadata) u64 {

    var width: u64 = 0;
    for (meta) |col| {
        width = @max(width, col.data.width);
    }

    return width;
}

/// Write padding to the writer interface n times.
pub fn writePad(writer: *Io.Writer, width: usize) !void {
    // Is this the fastest way? Or is there a better approach?
    for (0..width) |_| {
        try writer.writeAll(" ");
    }
}

/// Copy a string buffer to another string buffer and center the string as
/// much as possible
pub fn padCenterValue(writer: *Io.Writer, value: []const u8, width: usize) !void {
    const pad = width - value.len;
    const lpad = @divFloor(pad, 2);
    const rpad = pad - lpad;

    try writePad(writer, lpad);
    try writer.writeAll(value);
    try writePad(writer, rpad);
}

/// Copy a string buffer to another string buffer and left-justify the string
/// as much as possible
pub fn padLeftJustValue(writer: *Io.Writer, value: []const u8, width: usize) !void {
    const pad = width - value.len;
    const lpad = 1;
    const rpad = pad - lpad;

    try writePad(writer, lpad);
    try writer.writeAll(value);
    try writePad(writer, rpad);
}

/// Copy a string buffer to another string buffer and right-justify the string
/// as much as possible
pub fn padRightJustValue(writer: *Io.Writer, value: []const u8, width: usize) !void {
    const pad = width - value.len;
    const rpad = 1;
    const lpad = pad - rpad;

    try writePad(writer, lpad);
    try writer.writeAll(value);
    try writePad(writer, rpad);
}

pub fn writeHeader(writer: *Io.Writer, header: []adbc.ColMetadata) !void {
    try writeHorizSep(writer, header, .Top);

    try writer.writeAll(Box.VertSep);

    for (header) |col| {
        try padCenterValue(writer, col.name, col.data.width + PAD);
        try writer.writeAll(Box.VertSep);
    }

    try writer.writeAll("\n");
    try writeHorizSep(writer, header, .Middle);
    try writer.flush();
}

/// Print the border horizontal separator to a buffer.
/// Return the number of bytes written
pub fn writeHorizSep(writer: *Io.Writer, header: []adbc.ColMetadata, orientation: HorizontalSeparator) !void {
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

    try writer.writeAll(l_s);

    for (header, 0..) |col, i| {
        // There's probably a neat way to do this without a loop
        // but tricky w/ unicode
        for (0..col.data.width + PAD) |_| {
            try writer.writeAll(Box.HorizSep);
        }

        if (i < header.len - 1) {
            try writer.writeAll(i_s);
        } else {
            try writer.writeAll(r_s);
        }
    }

    try writer.writeAll("\n");
    try writer.flush();
}

pub fn write(writer: *Io.Writer, asb: *adbc.TableBuffer, colb: []u8) !void {
    try writeHeader(writer, asb.metadata.?);

    for (0..asb.countBatches()) |i| {
        var view = try asb.asArrayView(i);
        defer _ = c.ArrowArrayViewReset(&view);

        for (0..asb.countBatchRows(i)) |r_i| {
            // Left side of table border
            try writer.writeAll(Box.VertSep);

            for (asb.metadata.?, 0..) |meta, c_i| {
                const col = view.children[c_i];

                if (adbc.meta.isNull(col, r_i)) {
                    try padCenterValue(writer,
                        Color.Grey ++ "null" ++ Color.Reset,
                        meta.data.width + PAD + Color.Grey.len + Color.Reset.len
                    );
                } else {
                    const val_str = adbc.meta.extractValue(&asb.metadata.?[c_i], colb, col, r_i);

                    if (adbc.meta.isNumeric(col)) {
                        try padRightJustValue(writer, val_str, meta.data.width + PAD);
                    } else {
                        try padLeftJustValue(writer, val_str, meta.data.width + PAD);
                    }
                }

                try writer.writeAll(Box.VertSep);
            }

            try writer.writeAll("\n");
        }
    }

    try writeHorizSep(writer, asb.metadata.?, .Bottom);
}

