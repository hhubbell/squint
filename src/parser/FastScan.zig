//! The objective of FastScan is to quickly split a string representing one or
//! more SQL queries into tokens, such that the statements can be easily split
//! apart. The objective is not to lex every word into a token. Rather, this
//! scanner's goal is to lex the minimum necessary amount of information to
//! be able to accurately identify query bounds.
//!
//! This scanner does this by searching for whitespace, comments, strings, and
//! semicolons. All other tokens are represented as `_UNCATEG`, or
//! uncategorized.
//!
//! This minimum set allows us to easily pull out the end of a query (;),
//! without false positives caused by semicolons in comments or strings.

const std = @import("std");

const Token = @import("Token.zig");
const TokenBuffer = @import("TokenBuffer.zig");

const Allocator = std.mem.Allocator;

const Self = @This();


cur: usize,
start: usize,
src: []const u8,


fn advanceCursor(self: *Self) void {
    self.cur += 1;
}

fn atEnd(self: Self) bool {
    return self.cur >= self.src.len;
}

fn setMark(self: *Self) void {
    self.start = self.cur;
}

fn matchNext(self: *Self, next: u8) bool {
    if (self.atEnd()) return false;

    const c: u8 = self.src[self.cur];
    if (c != next) return false;

    self.advanceCursor();

    return true;
}

fn peek(self: Self) u8 {
    if (self.atEnd()) return '\x00';

    return self.src[self.cur];
}

fn peekNext(self: Self) u8 {
    if (self.cur + 1 >= self.src.len) return '\x00';

    return self.src[self.cur + 1];
}

pub fn scan(gpa: Allocator, source: []const u8) !TokenBuffer {
    var scanner: Self = .{
        .cur = 0,
        .start = 0,
        .src = source
    };

    var tokens: std.ArrayList(Token) = .empty;

    while (!scanner.atEnd()) {
        scanner.setMark();

        const tok = scanner.scanNext();

        if (tok.is(.BLOCK_COMMENT) or tok.is(.COMMENT)) continue;

        try tokens.append(gpa, tok);
    }

    return .{
        .items = try tokens.toOwnedSlice(gpa),
        .src = source
    };
}

pub fn scanNext(self: *Self) Token {
    const char: u8 = self.peek();

    self.advanceCursor();

    return switch(char) {
        ';' => .init(.SEMICOLON, self.start, self.cur),
        ' ','\r', '\t', '\n' => .init(._WS, self.start, self.cur),
        '-' => blk: {
            if (self.matchNext('-')) {
                // A one line comment starts with `--` and goes to EOL
                while (self.peek() != '\n' and !self.atEnd()) {
                    self.advanceCursor();
                }
                break :blk .init(.COMMENT, self.start, self.cur);
            } else {
                break :blk .init(._UNCATEG, self.start, self.cur);
            }
        },
        '/' => blk: {
            if (self.matchNext('/')) {
                // A C-style one line comment starts with `//` and goes to EOL
                // This is a valid comment in certain dialects, e.g. snowflake
                while (self.peek() != '\n' and !self.atEnd()) {
                    self.advanceCursor();
                }
                break :blk .init(.COMMENT, self.start, self.cur);
            } else if (self.matchNext('*')) {
                // A block comment starts with `/*` and goes until `*/`
                while (!self.atEnd()) {
                    if (self.matchNext('*')) {
                        if (self.matchNext('/')) {
                            break;
                        }
                    } else {
                        self.advanceCursor();
                    }
                }
                break :blk .init(.BLOCK_COMMENT, self.start, self.cur);
            } else {
                break :blk .init(._UNCATEG, self.start, self.cur);
            }
        },
        '\'' => self.string(),
        '"' => blk: {
            while (!self.matchNext('"')) {
                self.advanceCursor();

                if (self.atEnd()) {
                    break;
                }
            }
            break :blk .init(.IDENTIFIER, self.start, self.cur);
        },
        else => self.word()
    };
}

fn string(self: *Self) Token {
    while (self.peek() != '\'' and !self.atEnd()) {
        self.advanceCursor();
    }

    if (self.atEnd()) {
        return .init(._ERR, self.start, self.cur);
    }

    self.advanceCursor();

    return .init(.STRING, self.start, self.cur);
}

fn word(self: *Self) Token {
    var c: u8 = self.peek();

    // [A-Za-z0-9_]
    while (std.ascii.isAlphanumeric(c) or c == '_') {
        self.advanceCursor();
        c = self.peek();
    }

    return .init(._UNCATEG, self.start, self.cur);
}
