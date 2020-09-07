const Builder = @import("std").build.Builder;
const mem = @import("std").mem;
const builtin = @import("builtin");

const print = @import("std").debug.print;

pub fn build(b: *Builder) void {
    const mode = b.standardReleaseOptions();
    const windows = b.option(bool, "windows", "create windows build") orelse false;

    var exe = b.addExecutable("zigui", "src/main.zig");
    var basepath = "libvterm/src/";
    var array  =  {"vterm.c", "foo.c"};
    for (array) |sf| {
      //var s = mem.concat(all, byte, .{basepath, sf});
      //exe.addCSourceFile(s, &[_][]const u8{"-std=c99"});
     // print(sf);
      
    }
    exe.setBuildMode(mode);

    if (windows) {
        exe.setTarget(.{
            .cpu_arch = .x86_64,
            .os_tag = .windows,
            .abi = .gnu,
        });
    }

    exe.addIncludeDir("libvterm/include");

    exe.linkSystemLibrary("c");
    exe.linkSystemLibrary("glfw");
    exe.linkSystemLibrary("epoxy");
    exe.install();

    const sparkle = b.step("sparkle", "is do the sparkly thing");
    const run = exe.run();
    run.step.dependOn(b.getInstallStep());
    sparkle.dependOn(&run.step);
}
