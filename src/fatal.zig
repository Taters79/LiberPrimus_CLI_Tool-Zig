const std = @import("std");
const builtin = @import("builtin");

pub fn msg(comptime fmt: []const u8, args: anytype) noreturn {
    std.debug.print(fmt, args);
    if (builtin.mode == .Debug) std.debug.panic("\n\n(LP CLI TOOL debug stack trace\n)", .{});
    std.process.exit(1);
}

pub fn oom() void {
    msg("oom\n", .{});
}