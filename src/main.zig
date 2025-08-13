const std = @import("std");
const unicode = std.unicode;

const runes = @import("runes.zig");
const pages = @import("pages.zig");

/// This imports the separate module containing `root.zig`. Take a look in `build.zig` for details.
const lib = @import("LiberPrimus_CLI_Tool-Zig_lib");


pub fn main() !void {
   
    //for (0..runes.max_runes) |i| {
    //    std.debug.print("Rune: {u} Letter: {s} Value: {d}\n", .{runes.rune_list[i], runes.letter_list[i], runes.value_list[i]});
    //}

    // TODO: (tja) - create a REPL to handle changing pages and executing different commands
    //              - create a way to apply mathematical functions to the pages
    //                  - This may entail or provide an oppourtunity to create a small language to represent the functions
    //              - Can we create a way to modify and visualize the Magic Squares?
    //                  - A different mode where we can display the original square on one side of the screen, then apply some sort of transformation and display it on the other?
    //              - could we injest the musical data and do something similar? 

    std.debug.print("\x1b[2J\r\x1b[H", .{});
    for(pages.page_57) |i| {
        if (i == 1000) {
            std.debug.print("\x1b[36m{u:>3}", .{'\u{25e6}'});
            continue;
        }
        std.debug.print("\x1b[33m{u:>3}", .{runes.runes[i]});
    }
    std.debug.print("\n", .{});
    for(pages.page_57) |i| {
        if (i == 1000) {
            std.debug.print("\x1b[36m{u:>3}", .{'\u{25e6}'});
            continue;
        }
        std.debug.print("\x1b[35m{s:>3}", .{runes.letters[i]});
    }
    
    std.debug.print("\x1b[0m\n", .{});
    //std.debug.print("{u}", .{runes.rune_list[0]});
    //try bw.flush(); // Don't forget to flush!
}



