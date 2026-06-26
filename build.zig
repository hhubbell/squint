const std = @import("std");
const Translator = @import("translate_c").Translator;

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const c_flg = &[_][]const u8{ "-std=c17" };
    const cc_flg = &[_][]const u8{ "-std=c++17" };


    // arrow-adbc dependency: nanoarrow
    const nanoarrow_path: []const u8 = "vendor/arrow-nanoarrow";
    const nanoarrow = b.addLibrary(.{
        .name = "nanoarrow",
        .linkage = .static,
        .root_module = b.createModule(.{
            .target = target,
            .optimize = optimize,
            .link_libc = true
        })
    });

    const nanoarrow_config = b.addConfigHeader(.{
        .style = .blank,
        .include_path = "nanoarrow/nanoarrow_config.h"
    }, .{
        .NANOARROW_VERSION = "0.9.0",
        .NANOARROW_VERSION_MAJOR = "0",
        .NANOARROW_VERSION_MINOR = "9",
        .NANOARROW_VERSION_PATCH = "0",
        .NANOARROW_VERSION_INT = 900,
        .NANOARROW_NAMESPACE_DEFINE = "#define NANOARROW_NAMESPACE"
    });
        
    nanoarrow.root_module.addConfigHeader(nanoarrow_config);
    nanoarrow.root_module.addIncludePath(b.path(b.pathJoin(&.{ nanoarrow_path, "src" })));
    nanoarrow.root_module.addIncludePath(b.path(b.pathJoin(&.{ nanoarrow_path, "thirdparty/flatcc/include" })));

    addCSourceFileGlob(b, nanoarrow.root_module, b.pathJoin(&.{ nanoarrow_path, "src/nanoarrow/common"}), ".c", c_flg);
    addCSourceFileGlob(b, nanoarrow.root_module, b.pathJoin(&.{ nanoarrow_path, "src/nanoarrow/device"}), ".c", c_flg);
    addCSourceFileGlob(b, nanoarrow.root_module, b.pathJoin(&.{ nanoarrow_path, "src/nanoarrow/ipc"}), ".c", c_flg);

    const adbc_path: []const u8 = "vendor/arrow-adbc/c";
    const adbc = b.addLibrary(.{
        .name = "arrow-adbc",
        .linkage = .static,
        .root_module = b.createModule(.{
            .target = target,
            .optimize = optimize,
            .link_libc = true,
            .link_libcpp = true
        })
    });

    adbc.root_module.addIncludePath(b.path(adbc_path));
    adbc.root_module.addIncludePath(b.path(b.pathJoin(&.{ adbc_path, "include" })));
    adbc.root_module.addIncludePath(b.path(b.pathJoin(&.{ adbc_path, "include/arrow-adbc" })));
    adbc.root_module.addIncludePath(b.path(b.pathJoin(&.{ adbc_path, "vendor" })));
    adbc.root_module.addIncludePath(b.path(b.pathJoin(&.{ adbc_path, "vendor/nanoarrow" })));
    adbc.root_module.addIncludePath(b.path(b.pathJoin(&.{ adbc_path, "vendor/fmt/include/fmt" })));

    addCSourceFileGlob(b, adbc.root_module, b.pathJoin(&.{ adbc_path, "vendor"}), ".c", c_flg);

    // arrow-adbc dependency: driver_manager
    const driver_mgr = b.addLibrary(.{
        .name = "adbc-driver-manager",
        .linkage = .static,
        .root_module = b.createModule(.{
            .target = target,
            .optimize = optimize,
            .link_libcpp = true
        })
    });

    driver_mgr.root_module.addIncludePath(b.path(b.pathJoin(&.{ adbc_path, "driver_manager" })));
    driver_mgr.root_module.addIncludePath(b.path(b.pathJoin(&.{ adbc_path, "include" })));
    driver_mgr.root_module.addIncludePath(b.path(b.pathJoin(&.{ adbc_path, "vendor" })));

    addCSourceFileGlob(b, driver_mgr.root_module, b.pathJoin(&.{ adbc_path, "driver_manager"}), ".c", c_flg);
    driver_mgr.root_module.addCSourceFiles(.{
        .files = &.{
            b.pathJoin(&.{ adbc_path, "driver_manager/adbc_driver_manager_api.cc" }),
            b.pathJoin(&.{ adbc_path, "driver_manager/adbc_driver_manager.cc" }),
            b.pathJoin(&.{ adbc_path, "driver_manager/adbc_driver_manager_driver_loading.cc" }),
            b.pathJoin(&.{ adbc_path, "driver_manager/adbc_driver_manager_profiles.cc" }),
        },
        .flags = cc_flg
    });

    const translate_c = b.dependency("translate_c", .{});
    const t: Translator = .init(translate_c, .{
        .c_source_file = b.path("include/c.h"),
        .target = target,
        .optimize = optimize,
        .link_libc = true
    });
    t.addIncludePath(b.path(b.pathJoin(&.{ adbc_path, "include" })));
    t.addIncludePath(b.path(b.pathJoin(&.{ adbc_path, "include/arrow-adbc" })));
    t.addConfigHeader(nanoarrow_config);
    t.addIncludePath(b.path(b.pathJoin(&.{ nanoarrow_path, "src" })));
    
    const mod = b.addModule("sql_cli", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .imports = &.{
            .{ .name = "c", .module = t.mod }
        }
    });
    mod.linkLibrary(driver_mgr);
    mod.linkLibrary(nanoarrow);
    mod.linkLibrary(adbc);
    mod.linkSystemLibrary("readline", .{});

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

    run_cmd.addPassthruArgs();

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

fn addCSourceFileGlob(
    b: *std.Build,
    mod: *std.Build.Module,
    path: []const u8,
    ext: [] const u8,
    options: []const []const u8
) void {

    var dir = std.Io.Dir.cwd().openDir(b.graph.io, path, .{ .iterate = true }) catch {
        std.debug.print("Failed to open C source directory: {s}\n", .{path});
        return;
    };
    defer dir.close(b.graph.io);

    var walker = dir.walk(b.allocator) catch return;
    defer walker.deinit();

    while (walker.next(b.graph.io) catch null) |entry| {
        if (entry.kind == .file and std.mem.endsWith(u8, entry.path, ext)) {
            mod.addCSourceFile(.{
                .file = b.path(b.pathJoin(&.{path, entry.path})),
                .flags = options
            });
        }
    }
}
