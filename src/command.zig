const std = @import("std");

pub const Commands = enum {
    exit,
    none,
};

pub const Command = struct {
    allocator: std.mem.Allocator,
    cmd: Commands = Commands.none,
    args: [][]const u8 = &.{},

    pub fn init(self: *Command, cmd_line: []u8) !void {
        // TODO: (tja) - We need a way to process both commands w/o args and with...
        if (std.mem.indexOf(u8, cmd_line, " ") == null) {
            std.debug.print("No space found!\n", .{});
            self.cmd = std.meta.stringToEnum(Commands, cmd_line) orelse Commands.none;
            std.debug.print("{s} {}\n", .{cmd_line, self.cmd});
            return;
        }

        var iter = std.mem.splitScalar(u8, cmd_line, ' ');
        self.cmd = std.meta.stringToEnum(Commands, iter.next() orelse "") orelse Commands.none;

        var temp_list = std.ArrayList([]const u8).init(self.allocator);
        while (iter.next()) |word| {
            if (std.mem.eql(u8, word, "")) continue;

            try temp_list.append(try self.allocator.dupe(u8, word));
        }
        self.args = try temp_list.toOwnedSlice();
    }

    pub fn deinit(self: *Command) void {
        for (self.args) |arg| {
            self.allocator.free(arg);
        }
        self.allocator.free(self.args);
    }

    pub fn format(
        self: Command,
        comptime _: []const u8,
        _: std.fmt.FormatOptions,
        writer: anytype,
    ) !void {
        try writer.print("Command: ", .{});
        try writer.print(" cmd={}, args=.{{", .{self.cmd});
        if (self.args.len == 0) {
            try writer.print("\"", .{});
        }
        for (self.args, 0..) |arg, i| {
            if (std.mem.eql(u8, arg, "")) {
                break;
            } else {
                if (i != 0) try writer.print(", ", .{});
            }
            try writer.print("\"{s}\"", .{arg});
        }
        //try writer.print("} }");
    }

};