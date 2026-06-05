const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // NOTE:
    //  In the future, we can use translate-c to do this translation from c to
    //  zig all in the build step. However, there is a regression in 0.16 which
    //  incorrectly translates unary operators (e.g. ++). This breaks translation
    //  of some `nanoarrow` functions which have for loops which use this syntax
    //  to increment the index.
    //
    //  Instead, translate-c is done as a manual step and the output is stored
    //  as `translated.zig`. The code is manually adjusted to be valid zig
    //  syntax
    //
    const Translator = @import("translate_c").Translator;
    const translate_c = b.dependency("translate_c", .{});

    const t: Translator = .init(translate_c, .{
        .c_source_file = b.path("include/c.h"),
        .target = target,
        .optimize = optimize,
        .link_libc = true
    });
    //const translate_c = b.addModule("c", .{
    //    .root_source_file = b.path("include/translated.zig"),
    //    .target = target,
    //    .link_libc = true,
    //    .link_libcpp = true,
    //});
    t.mod.linkSystemLibrary("fmt", .{});
    t.mod.linkSystemLibrary("nanoarrow_shared", .{});
    t.mod.linkSystemLibrary("adbc_driver_manager", .{});
    t.mod.linkSystemLibrary("adbc_driver_sqlite", .{});
    t.mod.linkSystemLibrary("sqlite3", .{});
    t.mod.linkSystemLibrary("readline", .{});


    const mod = b.addModule("sql_cli", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .imports = &.{
            .{ .name = "c", .module = t.mod }
        }
    });

    
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
