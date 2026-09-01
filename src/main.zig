const std = @import("std");
const adbc = @import("adbc");

const input = @import("input.zig");
const mesg = @import("message.zig");

const ConnectionCatalog = @import("ConnectionCatalog.zig");
const State = @import("State.zig");

const Allocator = std.mem.Allocator;
const Io = std.Io;


/// REPL loop
pub fn main(init: std.process.Init) !void {
    const gpa = init.gpa;

    var threaded: Io.Threaded = .init(gpa, .{.environ = init.minimal.environ});
    defer threaded.deinit();

    const io = threaded.io();

    var buffer: [4096]u8 = undefined;
    var stderr: Io.File.Writer = Io.File.stderr().writer(io, &buffer);

    var msg: mesg.MessageBuffer = try .init(gpa, 16);
    defer msg.deinit(gpa);

    var state: State = State.init(io, gpa, &msg, init) catch |e| {
        try msg.printAllErrs(&stderr.interface);

        return e;
    };
    defer state.deinit(gpa);

    if (state.mode == .quit) {
        return;
    }

    // Refresh the connection catalog asyncronously. This information is useful
    // for completion, but it's ok if it's not ready by the time we get to the
    // prompt. Spinning this off reduces the time to prompt, especially for
    // connections with large catalogs, or which take a while to yield a result.
    var catalog_fut = io.async(ConnectionCatalog.refresh, .{
        &input.catalog,
        gpa,
        &state.conn});
    defer input.catalog.deinit(gpa);
    defer catalog_fut.cancel(io) catch {};

    input.setMultiLine(1);
    input.setCompletionCallback(input.completionCallback);

    input.active_query = try .init(gpa, 2);
    defer input.active_query.deinit(gpa);

    var prompt: [*c]u8 = @constCast("> \x00");

    while (true) {
        const query: [*c]u8 = input.readline(prompt);
        defer std.c.free(query);

        switch (input.inputType(gpa, query)) {
            .blank,
            .canceled => {
                prompt = @constCast("> \x00");
                input.active_query.clear(gpa);
            },
            .continued => {
                prompt = @constCast(". \x00");
                try input.active_query.add(gpa, std.mem.span(query));
            },
            .dot => {
                _ = input.addHistory(query);
                input.dotCommand(std.mem.span(query), .{
                    .io = io,
                    .gpa = gpa, 
                    .state = &state,
                    .msg = &msg
                }) catch {
                    try msg.printLastErr(&stderr.interface);
                };
            },
            .execute => {
                prompt = @constCast("> \x00");
                try input.active_query.add(gpa, std.mem.span(query));

                const qstr: [:0]const u8 = try input.active_query.asStringZ(gpa);
                defer gpa.free(qstr);

                input.active_query.clear(gpa);

                input.execStatements(io, gpa, &state, &msg, qstr) catch {
                    try msg.printLastErr(&stderr.interface);
                };
            },
            .exit => break
        }
    }
}

test {
    std.testing.refAllDecls(@This());
}
