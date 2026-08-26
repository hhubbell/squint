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
    _WS, _NEWL, _NUL,

    // Parser special
    _ERR, _UNCATEG
};

pub const KeywordLookup = std.StaticStringMap(TokenType).initComptime(.{
    .{ "all", .ALL },
    .{ "and", .AND },
    .{ "as", .AS },
    .{ "between", .BETWEEN },
    .{ "by", .BY },
    .{ "case", .CASE },
    .{ "cast", .CAST },
    .{ "contains", .CONTAINS },
    .{ "create", .CREATE },
    .{ "cross", .CROSS },
    .{ "distinct", .DISTINCT },
    .{ "else", .ELSE },
    .{ "end", .END },
    .{ "except", .EXCEPT },
    .{ "extract", .EXTRACT },
    .{ "exists", .EXISTS },
    .{ "false", .FALSE },
    .{ "from", .FROM },
    .{ "full", .FULL },
    .{ "group", .GROUP },
    .{ "having", .HAVING },
    .{ "ilike", .ILIKE },
    .{ "in", .IN },
    .{ "inner", .INNER },
    .{ "intersect", .INTERSECT },
    .{ "is", .IS },
    .{ "join", .JOIN },
    .{ "left", .LEFT },
    .{ "like", .LIKE },
    .{ "limit", .LIMIT },
    .{ "minus", .EXCEPT }, // MINUS is a synonym for EXCEPT
    .{ "not", .NOT },
    .{ "null", .NULL },
    .{ "on", .ON },
    .{ "or", .OR },
    .{ "order", .ORDER },
    .{ "outer", .OUTER },
    .{ "over", .OVER },
    .{ "partition", .PARTITION },
    .{ "qualify", .QUALIFY },
    .{ "replace", .REPLACE },
    .{ "right", .RIGHT },
    .{ "select", .SELECT },
    .{ "table", .TABLE },
    .{ "temp", .TEMP },
    .{ "temporary", .TEMP },
    .{ "then", .THEN },
    .{ "top", .TOP },
    .{ "true", .TRUE },
    .{ "try_cast", .TRY_CAST },
    .{ "union", .UNION },
    .{ "use", .USE },
    .{ "using", .USING },
    .{ "view", .VIEW },
    .{ "when", .WHEN },
    .{ "where", .WHERE },
    .{ "with", .WITH },
});

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

