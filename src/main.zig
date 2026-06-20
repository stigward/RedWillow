const std = @import("std");
const cli = @import("cli.zig");
const cmd = @import("commands/fingerprint.zig");

pub fn main(init: std.process.Init) !void {
    const arena = init.arena.allocator();
    const args = try init.minimal.args.toSlice(arena);
    if (args.len < 2) return error.MissingCommand;

    // TODO: handle error with nicer print message
    const command = try cli.parse_args(args);
    switch (command) {
        .fingerprint => |flags| {
            std.debug.print("fingerprint target: {s}\n", .{flags.target});
            cmd.fingerprint_runner(flags);
        },
    }
}
