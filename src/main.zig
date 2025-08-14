// TODO: (tja) - create a REPL to handle changing pages and executing different commands
//              - create a way to apply mathematical functions to the pages
//                  - This may entail or provide an oppourtunity to create a small language to represent the functions
//              - Can we create a way to modify and visualize the Magic Squares?
//                  - A different mode where we can display the original square on one side of the screen, then apply some sort of transformation and display it on the other?
//              - could we injest the musical data and do something similar? 

// https://eliasdorneles.com/til/posts/simple-stdin-stdout-text-processing-with-zig/

const std = @import("std");
const builtin = @import("builtin");
const Allocator = std.mem.Allocator;

const fatal = @import("fatal.zig");
const command = @import("command.zig");
const runes = @import("runes.zig");
const pages = @import("pages.zig");


/// This imports the separate module containing `root.zig`. Take a look in `build.zig` for details.
//const lib = @import("LiberPrimus_CLI_Tool-Zig_lib");


pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();    

    const stdout = std.io.getStdOut().writer();

    var line = std.ArrayList(u8).init(allocator);
    defer line.deinit();

    while (prompt("$ ", &line)) |cmd_line| {
        defer line.clearRetainingCapacity();

        var cmd = command.Command { .allocator = allocator };
        defer cmd.deinit();

        try cmd.init(cmd_line);
        try stdout.print("{s}\n", .{cmd});

        switch (cmd.cmd) {
            command.Commands.exit => break,
            command.Commands.none => continue,
        }

    } else |err| {
        try switch (err) {
            else => stdout.print("Error: {}\n", .{err}),
        };
    }

    //std.debug.print("\x1b[2J\r\x1b[H", .{});
    //for(pages.page_57) |i| {
    //    if (i == 1000) {
    //        std.debug.print("\x1b[36m{u:>3}", .{'\u{25e6}'});
    //        continue;
    //    }
    //    std.debug.print("\x1b[33m{u:>3}", .{runes.runes[i]});
    //}
    //std.debug.print("\n", .{});
    //for(pages.page_57) |i| {
    //    if (i == 1000) {
    //        std.debug.print("\x1b[36m{u:>3}", .{'\u{25e6}'});
    //        continue;
    //    }
    //    std.debug.print("\x1b[35m{s:>3}", .{runes.letters[i]});
    //}
    
    //std.debug.print("\x1b[0m\n", .{});
    //std.debug.print("{u}", .{runes.rune_list[0]});
    //try bw.flush(); // Don't forget to flush!
}


pub fn prompt(text: []const u8, line: *std.ArrayList(u8)) ![]u8 {
    const stdout = std.io.getStdOut().writer();
    try stdout.print("{s}", .{text});

    const stdin = std.io.getStdIn().reader();
    const line_writer = line.writer();
    try stdin.streamUntilDelimiter(line_writer, '\n', null);
    return line.items;
}
