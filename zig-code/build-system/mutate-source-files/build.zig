const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const exe = b.addExecutable(.{
        .name = "demo",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
    });
    b.installArtifact(exe);

    const proto_gen = b.addExecutable(.{
        .name = "proto_gen",
        .root_source_file = b.path("tools/proto_gen.zig"),
        .target = target,
    });

    const run = b.addRunArtifact(proto_gen);
    const generated_protocol_file = run.addOutputFileArg("protocol.zig");

    const wf = b.addUpdateSourceFiles();
    wf.addCopyFileToSource(generated_protocol_file, "src/protocol.zig");

    const update_protocol_step = b.step("update-protocol", "update src/protocol.zig to latest");
    update_protocol_step.dependOn(&wf.step);
}

fn detectWhetherToEnableLibFoo() bool {
    return false;
}

// syntax
