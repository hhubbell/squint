const std = @import("std");

const Dir = std.Io.Dir;
const Environ = std.process.Environ;
const Io = std.Io;

// TODO We could potentially do something cool with comptime to set a temp
// file that is platform dependent, based on the build. Worth considering.
// But I think this works for now for the platforms we support.
pub const tmp_buffer: []const u8 = "/tmp/squintedit.sql";


/// Determine if EDITOR is set. If not, if vim is available in PATH then
/// fallback to vim.
pub fn whichEditor(io: Io, env: *Environ.Map) ?[]const u8 {
    return env.get("EDITOR") orelse getFallback(io, "vim", env);
}

/// Open a pipe to editor and edit the file at path.
pub fn edit(io: Io, editor: []const u8, path: []const u8) !void {
    var child = try std.process.spawn(io, .{
        .argv = &[2][]const u8 {editor, path},
        .stdin = .inherit,
        .stdout = .inherit,
        .stderr = .inherit});

    _ = try child.wait(io);
}

/// Determine if an executable is available in PATH. If yes, return
/// a string representing the executable name, otherwise null
fn getFallback(io: Io, fb: []const u8, env: *Environ.Map) ?[]const u8 {
    const path = env.get("PATH") orelse return null;

    var iter = std.mem.tokenizeSequence(u8, path, ":");

    while (iter.next()) |p| {
        const dir = Dir.cwd().openDir(io, p, .{}) catch continue;
        defer dir.close(io);

        const handle = dir.openFile(io, fb, .{}) catch continue;
        defer handle.close(io);

        const st = Io.File.stat(handle, io) catch continue;

        if (st.kind == .file) {
            return fb;
        }
    }

    return null;
}

