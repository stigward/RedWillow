const std = @import("std");
const cli = @import("cli.zig");

pub fn main(init: std.process.Init) !void {
    const arena = init.arena.allocator();
    const args = try init.minimal.args.toSlice(arena);
    if (args.len < 2) return error.MissingCommand;
    try cli.parse_args(args);
}
