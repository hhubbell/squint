pub const c = @cImport({
    @cInclude("arrow-adbc/adbc.h");
    @cInclude("arrow-adbc/driver/sqlite.h");
    @cInclude("nanoarrow/nanoarrow.h");
    @cInclude("readline/readline.h");
    @cInclude("readline/history.h");
});
