const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const mod = b.addModule("sql_cli", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .link_libc = true,
        .link_libcpp = true
    });

    // ADBC headers
    //mod.addIncludePath(b.path("include/arrow-adbc/include"));
    // Nanoarrow headers
    //mod.addIncludePath(b.path("include/arrow-nanoarrow/src"));

    //mod.addLibraryPath(b.path("/usr/local/lib"));
    mod.linkSystemLibrary("fmt", .{});
    mod.linkSystemLibrary("nanoarrow_shared", .{});
    mod.linkSystemLibrary("adbc_driver_manager", .{});
    mod.linkSystemLibrary("adbc_driver_sqlite", .{});
    mod.linkSystemLibrary("sqlite3", .{});
    mod.linkSystemLibrary("readline", .{});
    //mod.addLibraryPath(b.path("lib"));
    //mod.addObjectFile(b.path("lib/libnanoarrow_static.a"));
    //mod.linkSystemLibrary("adbc_driver_sqlite", .{});
    //mod.addObjectFile(b.path("lib/driver/common/libadbc_driver_common.a"));
    //mod.addObjectFile(b.path("lib/driver/framework/libadbc_driver_framework.a"));
    //mod.addObjectFile(b.path("lib/driver/sqlite/libadbc_driver_sqlite.a"));


    const exe = b.addExecutable(.{
        .name = "sql_cli",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "sql_cli", .module = mod },
            },
        }),
    });


    b.installArtifact(exe);

    const run_step = b.step("run", "Run the app");

    const run_cmd = b.addRunArtifact(exe);
    run_step.dependOn(&run_cmd.step);

    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const mod_tests = b.addTest(.{
        .root_module = mod,
    });

    const run_mod_tests = b.addRunArtifact(mod_tests);

    const exe_tests = b.addTest(.{
        .root_module = exe.root_module,
    });

    const run_exe_tests = b.addRunArtifact(exe_tests);

    const test_step = b.step("test", "Run tests");
    test_step.dependOn(&run_mod_tests.step);
    test_step.dependOn(&run_exe_tests.step);
}
