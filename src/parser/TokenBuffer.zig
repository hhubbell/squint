const std = @import("std");

const Allocator = std.mem.Allocator;
const Token = @import("Token.zig");
const Self = @This();


items: []Token,
src: []const u8,


pub fn deinit(self: *Self, gpa: Allocator) void {
    gpa.free(self.items);
}

pub fn split(self: *Self, gpa: Allocator) ![]Self {
    var stmt: std.ArrayList(Self) = .empty;
    defer stmt.deinit(gpa);

    var start: usize = 0;
    var cur: usize = 0;
    for (self.items) |tok| {
        cur += 1;

        if (tok.is(.SEMICOLON)) {
            try stmt.append(gpa, .{
                .items = self.items[start..cur],
                .src = self.src
            });

            start = cur;
        }
    }

    // There's a trailing statement not terminated by a semicolon.
    // However, we need to make sure it's something more than just
    // a comment or whitespace.
    for (start..cur) |i| {
        if (
            !self.items[i].isWhitespace()
            and !self.items[i].is(.BLOCK_COMMENT)
            and !self.items[i].is(.COMMENT)
        ) { 
            try stmt.append(gpa, .{
                .items = self.items[start..cur],
                .src = self.src
            });

            break;
        }
    }

    return try stmt.toOwnedSlice(gpa);
}

fn innerAsString(self: Self, gpa: Allocator) !std.ArrayList(u8) {
    var stmt: std.ArrayList(u8) = .empty;

    for (self.items) |tok| {
        try stmt.appendSlice(gpa, self.src[tok.col_beg..tok.col_end]);
    }

    return stmt;
}

pub fn asString(self: Self, gpa: Allocator) ![]const u8 {
    var stmt = try self.innerAsString(gpa);  
    defer stmt.deinit(gpa);

    return try stmt.toOwnedSlice(gpa);
}

pub fn asStringZ(self: Self, gpa: Allocator) ![:0]const u8 {
    var stmt = try self.innerAsString(gpa);
    defer stmt.deinit(gpa);

    try stmt.append(gpa, '\x00');

    return try stmt.toOwnedSliceSentinel(gpa, 0);
}

