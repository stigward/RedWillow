const std = @import("std");

pub fn main(init: std.process.Init) !void {
    const arena = init.arena.allocator();
    const args = try init.minimal.args.toSlice(arena);

    if (args.len > 1 and std.mem.eql(u8, args[1], "--help")) {
        std.debug.print("usage: {s} [args...]\n", .{args[0]});
        return;
    }

    std.debug.print("wassup killer\n", .{});

    for (args[1..]) |arg| {
        std.log.info("arg: {s}", .{arg});
    }
}
