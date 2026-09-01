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

fn innerAsString(self: Self, gpa: Allocator, beg: usize, end: usize) !std.ArrayList(u8) {
    var stmt: std.ArrayList(u8) = .empty;

    for (beg..end) |i| {
        try stmt.appendSlice(gpa, self.tokenString(self.items[i]));
    }

    return stmt;
}

pub fn asString(self: Self, gpa: Allocator) ![]const u8 {
    var stmt = try self.innerAsString(gpa, 0, self.items.len);  
    defer stmt.deinit(gpa);

    return try stmt.toOwnedSlice(gpa);
}

pub fn asStringZ(self: Self, gpa: Allocator) ![:0]const u8 {
    var stmt = try self.innerAsString(gpa, 0, self.items.len);
    defer stmt.deinit(gpa);

    try stmt.append(gpa, '\x00');

    return try stmt.toOwnedSliceSentinel(gpa, 0);
}

pub fn asStringRange(self: Self, gpa: Allocator, beg: usize, end: usize) ![]const u8 {
    var stmt = try self.innerAsString(gpa, beg, end);
    defer stmt.deinit(gpa);

    return try stmt.toOwnedSlice(gpa);
}

pub fn tokenString(self: Self, tok: Token) []const u8 {
    return self.src[tok.col_beg..tok.col_end];
}

pub fn lastToken(self: Self) Token {
    return self.items[self.items.len - 1];
}

pub fn lastTokenNonWs(self: Self) Token {
    var i: usize = self.items.len - 1;

    while (i >= 0) : (i -= 1) {
        if (self.items[i].isWhitespace()) continue;

        return self.items[i];
    }
}

pub fn printTokens(self: Self) void {
    for (self.items, 0..) |tok, i| {
        // Use writer, but whatever, this is for debugging only really
        std.debug.print("{d}: [{s}] {s}\n",
            .{i, @tagName(tok.kind), self.tokenString(tok)}
        );
    }
}
