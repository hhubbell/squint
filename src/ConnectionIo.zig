const std = @import("std");
const c = @import("c");
const adbc = @import("adbc");

const mesg = @import("message.zig");
const perf = @import("perf.zig");

const TableWriter = @import("render/TableWriter.zig");

const Allocator = std.mem.Allocator;
const Io = std.Io;

const Self = @This();

db: c.AdbcDatabase,
conn: c.AdbcConnection,
err: c.AdbcError,
pmon: perf.PerfData,
row_limit: ?usize = 10_240,
rows_affected: i64 = 0,
last_result: adbc.ArrowStreamBuffer,

pub fn init(io: Io, gpa: Allocator) !Self {
    return .{
        .db = std.mem.zeroInit(c.AdbcDatabase, .{}),
        .conn = std.mem.zeroInit(c.AdbcConnection, .{}),
        .err = std.mem.zeroInit(c.AdbcError, .{}),
        .pmon = .init(io),
        // FIXME: This is just a basic implementation to test that the behavior
        // is roughly working. We should rename these initializers, and perhaps
        // move the initializer to a vtable-ish think on another struct, i.e.
        // the ConnManager.
        // Due to the behavior of the ArrowArray stream, any limit the user has
        // set is actually rounded up to multiple of 1024. Because the limit is
        // applied on the client side and not server side, this really doesn't
        // have a noticeable impact on performance. It's more so a quality of
        // life behavior to avoid accidentally dumping millions of rows to the
        // user's stdout.
        // TODO: To support .save we are breaking row limits. This API needs
        // some work anyway so it's fine.
        .last_result = try .initRows(gpa, 10_240)
    };
}

pub fn deinit(self: *Self, gpa: Allocator) !void {
    self.last_result.deinit(gpa);
    if (self.err.release) |release| release(&self.err);
    try adbc.err.checkAdbc(c.AdbcConnectionRelease(&self.conn, &self.err));
    try adbc.err.checkAdbc(c.AdbcDatabaseRelease(&self.db, &self.err));
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
) ![]const u8 {
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

    adbc.readStream(gpa, &strm, &self.last_result) catch |e| {
        switch (e) {
            error.NanoArrowStreamError =>
                adbc.err.onNanoArrowStreamErrMsg(&strm,
                    @typeInfo(@TypeOf(msg)).pointer.child,
                    msg,
                    mesg.MessageBuffer.addErr),
            error.NanoArrowError => msg.addErr("{s}", .{self.last_result.err.message}),
            error.AdbcLibError => msg.addErr("ADBC Library Error.", .{}),
            else => msg.addErr("Uncaught Error.", .{})
        }
        return e;
    };

    self.pmon.load = self.pmon.lap(io);

    // TODO move this to a new TableStreamBuffer interface
    self.last_result.metadata = try adbc.calcColumnMetadata(io, gpa, &self.last_result);
    self.pmon.rows = self.last_result.countRows();

    const bufsz = TableWriter.calcResultBufSize(
        self.last_result.metadata.?,
        self.pmon.rows);

    self.pmon.proc = self.pmon.lap(io);

    var prntbuf = try gpa.alloc(u8, bufsz);

    // Write the ArrowStream result set to the allocated print buffer. By
    // calculating the required buffer size ahead of time, instead of
    // dynamically allocating to build the string at print time, we save
    // a substantial amount of time rendering.
    try TableWriter.write(&prntbuf, &self.last_result);

    self.pmon.rend = self.pmon.lap(io);

    return prntbuf;
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

