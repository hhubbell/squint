const std = @import("std");
const sql_cli = @import("sql_cli");

pub fn main() !void {
    try sql_cli.main();
}

