const Builder = @import("std").build.Builder;
const builtin = @import("builtin");

pub fn build(b: *Builder) void {
    const mode = b.standardReleaseOptions();
    const windows = b.option(bool, "windows", "create windows build") orelse false;

    var exe = b.addExecutable("zigui", "src/main.zig");
    exe.setBuildMode(mode);

    if (windows) {
        exe.setTarget(.{
            .cpu_arch = .x86_64,
            .os_tag = .windows,
            .abi = .gnu,
        });
    }

    exe.linkSystemLibrary("c");
    exe.linkSystemLibrary("glfw");
    exe.linkSystemLibrary("epoxy");
    exe.install();

    const sparkle = b.step("sparkle", "is do the sparkly thing");
    const run = exe.run();
    run.step.dependOn(b.getInstallStep());
    sparkle.dependOn(&run.step);
}
