const std = @import("std");
const c = @import("c");
const adbc = @import("adbc");

const mesg = @import("message.zig");
const perf = @import("perf.zig");
const rndr = @import("render/root.zig");

const Allocator = std.mem.Allocator;
const Io = std.Io;

const Self = @This();

db: c.AdbcDatabase,
conn: c.AdbcConnection,
err: c.AdbcError,
pmon: perf.PerfData,
row_limit: ?usize = 10_240,
rows_affected: i64 = 0,
last_statement: ?[]const u8 = null,
last_result: adbc.TableBuffer,

pub fn init(io: Io, gpa: Allocator) !Self {
    return .{
        .db = std.mem.zeroInit(c.AdbcDatabase, .{}),
        .conn = std.mem.zeroInit(c.AdbcConnection, .{}),
        .err = std.mem.zeroInit(c.AdbcError, .{}),
        .pmon = .init(io),
        // TODO: To support .save we are breaking row limits. This API needs
        // some work anyway so it's fine.
        .last_result = try .init(gpa, 16)
    };
}

pub fn deinit(self: *Self, gpa: Allocator) !void {
    self.last_result.deinit(gpa);
    if (self.last_statement) |stmt| gpa.free(stmt);
    if (self.err.release) |release| release(&self.err);
    try adbc.err.checkAdbc(c.AdbcConnectionRelease(&self.conn, &self.err));
    try adbc.err.checkAdbc(c.AdbcDatabaseRelease(&self.db, &self.err));
}

pub fn clear(self: *Self, gpa: Allocator) void {
    self.last_result.clear(gpa);

    if (self.last_statement) |stmt| gpa.free(stmt);
    self.last_statement = null;
}

/// Initialize a connection to database
pub fn connect(self: *Self, gpa: Allocator, cfg: adbc.AdbcConfig) !void {
    try adbc.err.checkAdbc(c.AdbcDatabaseNew(&self.db, self.errPtr()));
    try adbc.err.checkAdbc(c.AdbcDriverManagerDatabaseSetLoadFlags(&self.db,
        c.ADBC_LOAD_FLAG_DEFAULT,
        self.errPtr()
    ));

    inline for (@typeInfo(@TypeOf(cfg)).@"struct".field_names) |f| {
        const v = @field(cfg, f);

        if (v != null) {
            try adbc.setDatabaseOption(gpa, &self.db, self.errPtr(), f, v.?);
        }
    }

    try adbc.err.checkAdbc(c.AdbcDatabaseInit(&self.db, self.errPtr()));

    try adbc.err.checkAdbc(c.AdbcConnectionNew(&self.conn, self.errPtr()));
    try adbc.err.checkAdbc(c.AdbcConnectionInit(&self.conn,
        &self.db,
        self.errPtr()));
}

/// Execute a query and return the result as a string
///
/// TODO: Can we use Zig's new sink/source Io idea to write the result directly
/// to the next node in the pipeline's reader? And therefore avoid an
/// intermediate string? Could be cool
pub fn execute(
    self: *Self,
    io: Io,
    gpa: Allocator,
    msg: *mesg.MessageBuffer,
    query_str: [:0]const u8
) !void {
    // Store the last statement. This should happen even if the query is
    // invalid
    self.last_statement = try gpa.dupe(u8, query_str[0..query_str.len - 1]);

    // Basic performance monitoring
    self.pmon.reset(io);

    var stmt: c.AdbcStatement = adbc.prepareStatement(query_str,
        &self.conn,
        self.errPtr()
    ) catch |e| {
        msg.addErr("{s}", .{self.lastErrMsg()});
        return e;
    };
    defer adbc.err.checkAdbc(c.AdbcStatementRelease(&stmt, self.errPtr())) catch {
        @panic("Failed to release statement.");
    };

    var strm: c.ArrowArrayStream = adbc.executeWithCancel(io,
        &stmt,
        self.errPtr()
    ) catch |e| {
        switch (e) {
            error.Canceled => msg.addErr("Execution canceled.", .{}),
            else => msg.addErr("{s}", .{self.lastErrMsg()})
        }
        return e;
    };
    defer if (strm.release) |release| release(&strm);

    self.pmon.exec = self.pmon.lap(io);

    adbc.readStream(gpa, &strm, &self.last_result.buffer) catch |e| {
        switch (e) {
            error.NanoArrowStreamError =>
                adbc.err.onNanoArrowStreamErrMsg(&strm,
                    @typeInfo(@TypeOf(msg)).pointer.child,
                    msg,
                    mesg.MessageBuffer.addErr),
            error.NanoArrowError => msg.addErr("{s}", .{self.last_result.lastErrMsg()}),
            error.AdbcLibError => msg.addErr("ADBC Library Error.", .{}),
            else => msg.addErr("Uncaught Error.", .{})
        }
        return e;
    };

    self.pmon.load = self.pmon.lap(io);

    // TODO move this to a new TableStreamBuffer interface
    self.last_result.metadata = try adbc.calcColumnMetadata(io, gpa, &self.last_result.buffer);
    self.pmon.proc = self.pmon.lap(io);
}

/// Deprecated
///
/// This is unnecessary as `pmon.rend` is no longer meaningful when we
/// stream our writes. Keeping as a reminder if needed in the future.
pub fn render(self: *Self, io: Io, gpa: Allocator, tw: rndr.TableWriter) !void {
    // Reset the lap timer in case it has been a been a while
    _ = self.pmon.lap(io);

    // WARNING: 
    //  When we close our pager without reading the full result set, less
    //  will attempt to issue a SIGPIPE which terminates the parent process.
    //  We are ignoring these signals. As a result, incomplete reading of
    //  inputs results in a WriteFailed error due to a broken pipe. In this
    //  case, we are just ignoring the error and returning.
    tw.write(gpa, &self.last_result) catch |err| {
        if (err != error.WriteFailed) {
            return err;
        }
    };

    self.pmon.rend = self.pmon.lap(io);
}

/// If an error already exists, free it before returning a fresh AdbcError.
///
/// This may warrant rethinking how error handling happens generally. E.g. an
/// independent error wrapper with explicit init. But it seems ok for now
pub fn errPtr(self: *Self) *c.AdbcError {
    if (self.err.release) |release| release(&self.err);

    self.err = std.mem.zeroInit(c.AdbcError, .{});

    return &self.err;
}

/// Return the last AdbcError message as a string
pub fn lastErrMsg(self: *Self) []const u8 {
    if (self.err.message != null) {
        return std.mem.span(self.err.message);
    } else {
        return "No error message provided.";
    }
}

/// Get the connection driver. It shouldn't be possible to establish a
/// connection without a driver, so we basically unwrap this and crash
/// if it fails.
pub fn getDriver(self: *Self, gpa: Allocator) !?[]const u8 {
    return try adbc.getConnectionInfo(gpa, &self.conn,
        c.ADBC_INFO_DRIVER_NAME,
        self.errPtr()
    );
}

pub fn getUri(self: *Self, gpa: Allocator) !?[]const u8 {
    return try adbc.getDatabaseOption(gpa, &self.db,
        "uri",
        self.errPtr()
    );
}
