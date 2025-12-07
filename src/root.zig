//! By convention, root.zig is the root source file when making a library.
const std = @import("std");
const posix = std.posix;
const SIG = posix.SIG;
const time = std.time;

const h = @import("cheaders.zig");
const db = @import("db.zig");
const errors = @import("errors.zig");
const format = @import("format.zig");
const stream = @import("stream.zig");

const Allocator = std.mem.Allocator;


/// Yikes - dumpster signature
pub fn dotCommand(alloc: Allocator, log: *errors.ErrorSingleton, cmd: []const u8, writer: *std.Io.Writer) !void {

    _ = alloc;

    // Rethink this when we have more commands, e.g. hashmap with
    // some callable or something else.
    const dotc = cmd[1..];

    if (std.mem.eql(u8, dotc, "errors")) {
        try log.printAllErrs(writer);
    } else if (std.mem.eql(u8, dotc, "save")) {
        log.addErr("Save not yet implemented.");
        return error.DotCommandError;
    } else {
        log.addErr("Invalid dot command.");
        return error.DotCommandError;
    }
}

/// Provide a pager child process for outputs that are larger than the standard
/// output window. Requires dependency `less`.
pub fn lessPipe(alloc: Allocator, data: []const u8) !void {
    var child = std.process.Child.init(&[_][]const u8 {"less", "-FRS"}, alloc);

    child.stdin_behavior = .Pipe;
    child.stdout_behavior = .Inherit;
    child.stderr_behavior = .Inherit;

    try child.spawn();

    var writer = child.stdin.?.writer(&.{});

    // WARNING: 
    //  When we close our pager without reading the full result set, less
    //  will attempt to issue a SIGPIPE which terminates the parent process.
    //  We are ignoring these signals. As a result, incomplete reading of
    //  inputs results in a WriteFailed error due to a broken pipe. In this
    //  case, we are just ignoring the error and returning.
    writer.interface.writeAll(data) catch |err| {
        if (err == error.WriteFailed) {
            child.stdin.?.close();
            child.stdin = null;
            _ = try child.wait();
            return;
        }

        return err;
    };
    
    child.stdin.?.close();

    // NOTE:
    //  Using -F results in a thread panic if the input data is too small
    //  without explicitly doing this action below. I believe this is caused
    //  by the wait function trying to clean up a non-existant fd. Setting
    //  it to null solves this problem.
    child.stdin = null;

    _ = try child.wait();
}

fn toMs(ns: u64) u64 {
    return ns / time.ns_per_ms;
}

/// Set a signal handler specifically for when in readline mode to handle
/// SIGINT signals from users entering ctrl-c. When his happens. Abandon
/// the current input and give a new prompt.
///
/// According to Readline documentation, the default builtin SIGINT handler
/// should have handled cleanup of the input so far, so we do not need to
/// do our own housekeeping.
fn rlSigIntHandler(sig: SIG) callconv(.c) void {
    _ = sig;

    _ = h.c.rl_crlf();
    _ = h.c.rl_on_new_line();
    h.c.rl_replace_line("", 0);
    h.c.rl_redisplay();
}

/// Get the output handle window size
///
/// Not actively used
fn windowSize(handle: std.fs.File.Handle) !posix.winsize {
    var winsize: posix.winsize = .{
        .row = 0,
        .col = 0,
        .xpixel = 0,
        .ypixel = 0};

    const err = posix.system.ioctl(handle, posix.T.IOCGWINSZ, @intFromPtr(&winsize));

    if (posix.errno(err) != .SUCCESS) {
        return error.IoctlError;
    }

    return winsize;
}

/// REPL loop
///
pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const alloc = gpa.allocator();

    var errs: errors.ErrorSingleton = try .init(alloc, 4);
    defer errs.deinit(alloc);

    //var threaded: std.Io.Threaded = .init_single_threaded;
    //const io = threaded.io();

    //var stdout = std.fs.File.stdout();

    var stderr = std.fs.File.stderr();
    var stderrw = stderr.writer(&.{});

    // XXX:
    //  I originally used this block to dynamically call lessPipe based on
    //  the window size and result size. Now I just use `less -F`. But this
    //  might be useful for something... someday...
    //const winsize = windowSize(stdout.handle) catch {
    //    errs.addErr("Ioctl winsize unknown.");
    //    try errs.printLastErr(&stderrw.interface);
    //};

    // NOTE:
    //  When paging results, we need to disable SIGPIPE if we quit the pager
    //  without consuming the entire result set. This is a similar approach
    //  used in the Postgres cli
    const pg_act = posix.Sigaction {
        .handler = .{ .handler = SIG.IGN },
        .mask = std.mem.zeroes(posix.sigset_t),
        .flags = 0};
    std.posix.sigaction(SIG.PIPE, &pg_act, null);

    // Set a signal handler for SIGINT received while in readline mode. This
    // will capture the signal and handle it in a different way instead of
    // exiting. Instead ctrl-d will exit the repl.
    const rl_act = posix.Sigaction {
        .handler = .{ .handler = rlSigIntHandler },
        .mask = std.mem.zeroes(posix.sigset_t),
        .flags = 0};
    std.posix.sigaction(SIG.INT, &rl_act, null);

    const tst_path: []const u8 = "/home/harry/oil.db";

    var conn: db.ConnManager = db.ConnManager.init();
    db.connectSqlite(&conn, tst_path) catch {
        errs.addErr(conn.lastErrMsg());
        try errs.printLastErr(&stderrw.interface);
    };

    while (true) {
        const query = h.c.readline("> ");
        
        // A Null value here indicates a ctrl-d keypress. Exit the main loop.
        if (query == null) {
            break;
        }

        // If the user entered a blank string, do not continue.
        if (std.mem.len(query) == 0) {
            continue;
        }

        h.c.add_history(query);

        // Dot commands are meta commands for interacting with the session.
        if (query[0] == '.') {
            dotCommand(alloc, &errs, std.mem.span(query), &stderrw.interface) catch {
                try errs.printLastErr(&stderrw.interface);
            };

            continue;
        }

        // Basic performance monitoring
        var timer: time.Timer = try .start();

        var stmt = db.prepareStatement(&conn, std.mem.span(query)) catch {
            errs.addErr(conn.lastErrMsg());
            try errs.printLastErr(&stderrw.interface);
            continue;
        };

        const tm_prep = timer.lap();

        var strm = db.executeStatement(&conn, &stmt) catch {
            errs.addErr(conn.lastErrMsg());
            try errs.printLastErr(&stderrw.interface);
            continue;
        };

        const tm_exec = timer.lap();

        var res = try stream.ArrowStreamBuffer.initRows(alloc, 100_000); // prod: 1024
        stream.readStream(&conn, &strm, &res) catch |err| {
            switch (err) {
                error.AdbcStreamError => {
                    if (strm.get_last_error) |callable| {
                        const msg: [*c]const u8 = callable(&strm);

                        if (msg != null) {
                            errs.addErr(std.mem.span(msg));
                        }
                    }
                },
                error.AdbcNanoArrowError => errs.addErr(&res.err.message),
                error.AdbcLibError => errs.addErr("ADBC Library Error."),
                else => errs.addErr("Uncaught Error.")
            }

            try errs.printLastErr(&stderrw.interface);
            continue;
        };

        // This is pointless
        //if (res.hasCapacity()) {
        //    res.shrinkToFit(alloc);
        //}

        res.metadata = try stream.calcColumnMetadata(alloc, &res);
        const res_b_sz = format.calcResultBufSize(res.metadata.?, res.countRows());

        const tm_proc = timer.lap();

        std.debug.print("Buffersize: {any} bytes\n\n", .{res_b_sz});

        var prntbuf = try alloc.alloc(u8, res_b_sz);
        defer alloc.free(prntbuf);

        // Testing FBA is ~50x faster than GPA for dynamically building
        // the output string. However, there is an issue with how we build
        // this string that requires more memory than is actually needed.
        //
        // Part of this was the box drawing characters being 3 bytes wide.
        //
        // Currently we multiply the actual needed memory by 7 to be safe. But
        // it only works up to a certain result size. My hunch is that this is
        // caused by the allocPrint calls to format some of the strings while
        // building. Can we get rid of these or use a fixed buffer?
        //var fba = std.heap.FixedBufferAllocator.init(prntbuf);
        //const rnd = try stream.allocPrintStreamBuffer(fba.allocator(), &res);
        //const rnd = try stream.allocPrintStreamBuffer(alloc, &res);
        
        try format.printStreamBuffer(&prntbuf, &res);

        //std.debug.print("{d}\n\n", .{rnd.len});

        const tm_rend = timer.lap();

        try lessPipe(alloc, prntbuf);

        // Diagnostics
        try stderrw.interface.print(
            "\nTotal Rows: {d}\n\n"
                ++ "Prepare (ms): {d}\n"
                ++ "Execute (ms): {d}\n"
                ++ "Process (ms): {d}\n"
                ++ " Render (ms): {d}\n",
            .{
                conn.last_row_count,
                toMs(tm_prep),
                toMs(tm_exec),
                toMs(tm_proc),
                toMs(tm_rend)
            });

        //alloc.free(rnd);
        res.deinit(alloc);
        if (strm.release) |release| release(&strm);
        try db.releaseStatement(&conn, &stmt);

        h.c.free(query);
    }
}
