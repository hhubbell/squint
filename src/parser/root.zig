pub const FastScan = @import("FastScan.zig");
pub const Token = @import("Token.zig");
pub const TokenBuffer = @import("TokenBuffer.zig");

pub const StatementType = enum {
    alter, create, delete, drop, insert, select, truncate, update, use
};
