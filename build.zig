const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "Nubibus",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });

    add_sdl(exe);

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    const unit_tests = b.addTest(.{
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });

    add_sdl(unit_tests);

    const run_unit_tests = b.addRunArtifact(unit_tests);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_unit_tests.step);
}

fn add_sdl(c: *std.build.Step.Compile) void {
    c.linkLibC();

    const lib_dir = "D:\\Dev\\Librarys\\sdl2";
    // const lib_dir = "C:\\Dev\\Libs";

    c.addIncludePath(.{ .path = lib_dir ++ "\\SDL2-2.30.0\\include" });
    c.addObjectFile(.{ .path = lib_dir ++ "\\SDL2-2.30.0\\lib\\x64\\SDL2.lib" });

    c.addIncludePath(.{ .path = lib_dir ++ "\\SDL2_image-2.8.2\\include" });
    c.addObjectFile(.{ .path = lib_dir ++ "\\SDL2_image-2.8.2\\lib\\x64\\SDL2_image.lib" });

    c.addIncludePath(.{ .path = lib_dir ++ "\\SDL2_ttf-2.22.0\\include" });
    c.addObjectFile(.{ .path = lib_dir ++ "\\SDL2_ttf-2.22.0\\lib\\x64\\SDL2_ttf.lib" });
}
