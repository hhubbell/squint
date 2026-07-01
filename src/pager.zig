const std = @import("std");
const posix = std.posix;

const Allocator = std.mem.Allocator;
const Io = std.Io;
const SIG = posix.SIG;


pub const PagerType = enum {
    less, nopager
};

/// Determine if a pager is available in PATH to page long output. Return
/// a value from an enum of known pagers. This is not exhaustive. This may
/// be the wrong design to support arbitrary pagers provided by the user,
/// but we'll get there
///
/// Also right now only less is supported!
/// (And we don't even really check!)
pub fn whichPager(io: Io, alloc: Allocator) PagerType {
    _ = io;
    _ = alloc;

    // When paging results, we need to disable SIGPIPE if we quit the pager
    // without consuming the entire result set. This is a similar approach
    // used in the Postgres cli
    disableSigPipe();

    return .less;
}

/// Take an input buffer and write it to the session pager.
pub fn page(io: Io, pager: PagerType, data: []const u8) !void {
    switch(pager) {
        .less => try lessPipe(io, data),
        .nopager => try writeStdout(io, data)
    }
}

/// Provide a pager child process for outputs that are larger than the standard
/// output window. Requires dependency `less`.
fn lessPipe(io: Io, data: []const u8) !void {
    var child = try std.process.spawn(io, .{
        .argv = &[2][]const u8 {"less", "-FRS"},
        .stdin = .pipe,
        .stdout = .inherit,
        .stderr = .inherit});

    var writer = child.stdin.?.writer(io, &.{});

    // WARNING: 
    //  When we close our pager without reading the full result set, less
    //  will attempt to issue a SIGPIPE which terminates the parent process.
    //  We are ignoring these signals. As a result, incomplete reading of
    //  inputs results in a WriteFailed error due to a broken pipe. In this
    //  case, we are just ignoring the error and returning.
    writer.interface.writeAll(data) catch |err| {
        if (err == error.WriteFailed) {
            child.stdin.?.close(io);
            child.stdin = null;
            _ = try child.wait(io);

            return;
        }

        return err;
    };
    
    child.stdin.?.close(io);

    // NOTE:
    //  Using -F results in a thread panic if the input data is too small
    //  without explicitly doing this action below. I believe this is caused
    //  by the wait function trying to clean up a non-existant fd. Setting
    //  it to null solves this problem.
    child.stdin = null;

    _ = try child.wait(io);
}

/// In the event that no pager was available, write the output unbuffered
/// to stdout.
fn writeStdout(io: Io, data: []const u8) !void {
    var writer = Io.File.stdout().writer(io, &.{});

    try writer.interface.writeAll(data);
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
