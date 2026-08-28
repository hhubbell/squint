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

/// Determine the required min buffer size for printing a column by returning
/// the widest column width
pub fn calcMaxWidth(meta: []adbc.ColMetadata) u64 {
    var width: u64 = 0;
    for (meta) |col| {
        width = @max(width, col.data.width);
    }

    return width;
}

/// Write a TableBuffer to an Io.Writer interface. Requires an allocator
/// to make one allocation for a buffer as wide as the widest column. Will
/// flush.
pub fn write(
    self: Self,
    gpa: Allocator,
    asb: *adbc.TableBuffer
) !void {
    const colb: []u8 = try gpa.alloc(u8, calcMaxWidth(asb.metadata.?));
    defer gpa.free(colb);

    try writeHeader(self.interface, asb.metadata.?);

    var iter: adbc.TableBuffer.Iterator = try asb.iter(.colwise);
    while (iter.next()) |slot| {
        // Left side of cell border
        try self.interface.writeAll(Shape.Box.VertSep);

        if (adbc.meta.isNull(slot.view, slot.row)) {
            try padCenterValue(self.interface,
                Color.Grey ++ "null" ++ Color.Reset,
                slot.meta.data.width + PAD + Color.Grey.len + Color.Reset.len
            );
        } else {
            const val_str = adbc.meta.extractValue(
                slot.meta,
                colb,
                slot.view,
                slot.row);

            if (adbc.meta.isNumeric(slot.view)) {
                try padRightJustValue(self.interface, val_str, slot.meta.data.width + PAD);
            } else {
                try padLeftJustValue(self.interface, val_str, slot.meta.data.width + PAD);
            }
        }

        if (slot.col >= iter.table.countCols() - 1) {
            try self.interface.writeAll(Shape.Box.VertSep);
            try self.interface.writeAll("\n");
        }
    }

    try writeHorizSep(self.interface, asb.metadata.?, .Bottom);
    try self.interface.flush();
}

/// Given a slice of ColMetadata, generate a header for the table with box
/// drawing characters.
fn writeHeader(writer: *Io.Writer, header: []adbc.ColMetadata) !void {
    try writeHorizSep(writer, header, .Top);

    try writer.writeAll(Shape.Box.VertSep);

    for (header) |col| {
        try padCenterValue(writer, col.name, col.data.width + PAD);
        try writer.writeAll(Shape.Box.VertSep);
    }

    try writer.writeAll("\n");
    try writeHorizSep(writer, header, .Middle);
}

/// Print the border horizontal separator to a buffer.
/// Return the number of bytes written
fn writeHorizSep(
    writer: *Io.Writer,
    header: []adbc.ColMetadata,
    orientation: HorizontalSeparator
) !void {
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

    try writer.writeAll(l_s);

    for (header, 0..) |col, i| {
        // There's probably a neat way to do this without a loop
        // but tricky w/ unicode
        for (0..col.data.width + PAD) |_| {
            try writer.writeAll(Shape.Box.HorizSep);
        }

        if (i < header.len - 1) {
            try writer.writeAll(i_s);
        } else {
            try writer.writeAll(r_s);
        }
    }

    try writer.writeAll("\n");
}

/// Write padding to the writer interface n times.
fn writePad(writer: *Io.Writer, width: usize) !void {
    // Is this the fastest way? Or is there a better approach?
    for (0..width) |_| {
        try writer.writeByte(' ');
    }
}

/// Write a string as centered as possible into a space width wide
fn padCenterValue(
    writer: *Io.Writer,
    value: []const u8,
    width: usize
) !void {
    const pad = width - value.len;
    const lpad = @divFloor(pad, 2);
    const rpad = pad - lpad;

    try writePad(writer, lpad);
    try writer.writeAll(value);
    try writePad(writer, rpad);
}

/// Write a string as left-justified into a space width wide
fn padLeftJustValue(
    writer: *Io.Writer,
    value: []const u8,
    width: usize
) !void {
    const pad = width - value.len;
    const lpad = 1;
    const rpad = pad - lpad;

    try writePad(writer, lpad);
    try writer.writeAll(value);
    try writePad(writer, rpad);
}

/// Write a string as right-justified into a space width wide
fn padRightJustValue(
    writer: *Io.Writer,
    value: []const u8,
    width: usize
) !void {
    const pad = width - value.len;
    const rpad = 1;
    const lpad = pad - rpad;

    try writePad(writer, lpad);
    try writer.writeAll(value);
    try writePad(writer, rpad);
}

