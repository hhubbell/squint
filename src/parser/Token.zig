const std = @import("std");

const Allocator = std.mem.Allocator;

const TokenType = enum {
    // Single char tokens
    LPAREN, RPAREN, LBRACE, RBRACE, COMMA,
    DOT, MINUS, PLUS, SEMICOLON, SLASH, STAR,

    // One or two char tokens
    ARROW, BANG, BANG_EQUAL, COLON, COLON_COLON, DOUBLE_LBRACE, DOUBLE_RBRACE,
    EQUAL, EQUAL_EQUAL, GREATER, GREATER_EQUAL, LESS, LESS_EQUAL, LESS_GREATER,
    LBRACE_PERCENT, LBRACE_HASH, RBRACE_PERCENT, RBRACE_HASH,

    // Literals
    IDENTIFIER, STRING, NUMBER,

    // Keywords
    ALL, AND, AS, BETWEEN, BY, CASE, CAST, CONTAINS, CREATE, CROSS,
    DISTINCT, ELSE, END, EXCEPT, EXISTS, EXTRACT, FALSE, FROM, FULL, GROUP,
    HAVING, ILIKE, IN, INNER, INTERSECT, IS, JOIN, LEFT, LIKE, LIMIT, NOT, NULL,
    ON, OR, ORDER, OUTER, OVER, PARTITION, QUALIFY, REPLACE, RIGHT,
    SELECT, TABLE, TEMP, THEN, TOP, TRUE, TRY_CAST, UNION, USE, USING, VIEW,
    WHEN, WHERE, WITH,

    // Comments
    COMMENT, BLOCK_COMMENT,

    // Whitespace and newlines
    _WS, _NEWL,

    // Parser special
    _ERR, _UNCATEG
};

const Self = @This();


kind: TokenType,
col_beg: usize,
col_end: usize,


pub fn init(kind: TokenType, beg: usize, end: usize) Self {
    return .{
        .kind = kind,
        .col_beg = beg,
        .col_end = end
    };
}

pub fn is(self: Self, kind: TokenType) bool {
    return self.kind == kind;
}

pub fn isWhitespace(self: Self) bool {
    return self.is(._WS) or self.is(._NEWL);
}

