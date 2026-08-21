const std = @import("std");
const posix = std.posix;

const Allocator = std.mem.Allocator;
const Dir = std.Io.Dir;
const Environ = std.process.Environ;
const Io = std.Io;
const SIG = posix.SIG;


/// Known (non-exhaustive) list of pagers that we will pipe out to for long
/// results. The order matters here, as the search for an appropriate pager
/// will return as soon as a match is found in PATH. Therefore, this enum
/// is in preferential order: less > more > nopager.
pub const PagerType = enum {
    less, more, nopager
};

/// Pager is a struct that holds a Writer to the pager (or stdout) and
/// a reference to the child process (if a pager).
pub const Pager = struct {
    const Self = @This();

    writer: Io.File.Writer,
    child: ?std.process.Child,

    pub fn close(self: *Self, io: Io) !void {
        if (self.child) |*child| {
            try closePipe(io, child);
        }
    }
};

/// Determine if a pager is available in PATH to page long output. Return
/// a value from an enum of known pagers. This is not exhaustive. This may
/// be the wrong design to support arbitrary pagers provided by the user,
/// but we'll get there.
pub fn whichPager(io: Io, env: *Environ.Map) PagerType {
    const path = env.get("PATH") orelse return .nopager;

    for (std.enums.values(PagerType)) |typ| {
        if (typ == .nopager) {
            continue;
        }

        var iter = std.mem.tokenizeSequence(u8, path, ":");

        while (iter.next()) |p| {
            const dir = Dir.cwd().openDir(io, p, .{}) catch continue;
            defer dir.close(io);

            const handle = dir.openFile(io, @tagName(typ), .{}) catch continue;
            defer handle.close(io);

            const st = Io.File.stat(handle, io) catch continue;

            if (st.kind == .file) {
                // When paging results, we need to disable SIGPIPE if we quit
                // the pager without consuming the entire result set. This is a
                // similar approach used in the Postgres cli
                disableSigPipe();

                return typ;
            }
        }
    }

    return .nopager;
}

/// Return a PagerType from a string
pub fn fromString(value: []const u8) !PagerType {
    const typ: ?PagerType = std.meta.stringToEnum(PagerType, value);

    if (typ == null) {
        return error.InvalidPager;
    }

    return typ.?;
}

/// Take an input buffer and write it to the session pager.
pub fn page(io: Io, pager: PagerType, buffer: []u8) !Pager {
    return switch(pager) {
        .less => try lessPipe(io, buffer),
        .more => try morePipe(io, buffer),
        .nopager => writeStdout(io, buffer)
    };
}

/// Provide a pager child process for outputs that are larger than the standard
/// output window. Requires dependency `less`.
fn lessPipe(io: Io, buffer: []u8) !Pager {
    var child = try std.process.spawn(io, .{
        .argv = &[2][]const u8 {"less", "-FRS"},
        .stdin = .pipe,
        .stdout = .inherit,
        .stderr = .inherit});

    return .{
        .writer = child.stdin.?.writer(io, buffer),
        .child = child
    };
}

/// Provide a pager child process for outputs using `more`. Requires dependency
/// `more`.
fn morePipe(io: Io, buffer: []u8) !Pager {
    var child = try std.process.spawn(io, .{
        .argv = &[1][]const u8 {"more"},
        .stdin = .pipe,
        .stdout = .inherit,
        .stderr = .inherit});

    return .{
        .writer = child.stdin.?.writer(io, buffer),
        .child = child
    };
}

/// Write output unbuffered to a child process pipe. In the event the pipe
/// closes, clean up and return, masking the WriteFailed error
fn writeChild(io: Io, child: *std.process.Child, source: *Io.Reader) !void {
    var buffer: [4096]u8 = undefined;
    var sink: Io.File.Writer = child.stdin.?.writer(io, &buffer);

    // WARNING: 
    //  When we close our pager without reading the full result set, less
    //  will attempt to issue a SIGPIPE which terminates the parent process.
    //  We are ignoring these signals. As a result, incomplete reading of
    //  inputs results in a WriteFailed error due to a broken pipe. In this
    //  case, we are just ignoring the error and returning.
    _ = source.streamRemaining(&sink.interface) catch |err| {
        if (err == error.WriteFailed) {
            try closePipe(io, child);
            return;
        }

        return err;
    };
    sink.interface.flush() catch |err| {
        if (err == error.WriteFailed) {
            try closePipe(io, child);
            return;
        }

        return err;
    };
    
    try closePipe(io, child);
}

/// In the event that no pager was available, write the output unbuffered
/// to stdout.
fn writeStdout(io: Io, buffer: []u8) Pager {
    return .{
        .writer = Io.File.stdout().writer(io, buffer),
        .child = null
    };
}

/// Close a child process that is accepting stdin and clean up resources
fn closePipe(io: Io, child: *std.process.Child) !void {
    child.stdin.?.close(io);

    // NOTE:
    // Using `less -F` results in a thread panic if the input data is too
    // small without explicitly doing this action below. I believe this is
    // caused by the wait function trying to clean up a nonexistent fd.
    // Setting it to null solves this problem.
    child.stdin = null;

    _ = try child.wait(io);
}

/// When paging results, we may need to disable SIGPIPE to prevent the process
/// from terminating if we quit the pager without consuming the entire result
/// set. This is a similar approach used in the Postgres cli
fn disableSigPipe() void {
    const act: posix.Sigaction = .{
        .handler = .{ .handler = SIG.IGN },
        .mask = std.mem.zeroes(posix.sigset_t),
        .flags = 0
    };

    posix.sigaction(SIG.PIPE, &act, null);
}
