const std = @import("std");

const FingerPrintArgs = struct { target: [:0]const u8 };

fn fingerprint_dispatcher(flags: []const [:0]const u8) !void {
    var target: ?[:0]const u8 = null;

    var i: usize = 0;
    while (i < flags.len) : (i += 1) {
        const flag = flags[i];

        if (std.mem.eql(u8, flag, "--target")) {
            i += 1;
            if (i >= flags.len) return error.MissingTargetValue;

            target = flags[i];
        } else {
            return error.UnknownFingerprintFlag;
        }
    }

    const fingerprint_args: FingerPrintArgs = .{
        .target = target orelse return error.MissingTargetFlag,
    };

    std.debug.print("fingerprint target: {s}\n", .{fingerprint_args.target});
}

pub fn main(init: std.process.Init) !void {
    const arena = init.arena.allocator();
    const args = try init.minimal.args.toSlice(arena);

    if (args.len < 2) {
        std.debug.print("usage: {s} [args...]\n", .{args[0]});
        return;
    }

    const command = args[1];
    const command_args = args[2..];

    if (args.len > 1) {
        if (std.mem.eql(u8, command, "--help")) {
            std.debug.print("usage: {s} [args...]\n", .{args[0]});
            return;
        } else if (std.mem.eql(u8, command, "fingerprint")) {
            try fingerprint_dispatcher(command_args);
            return;
        }
    }

    for (args[1..]) |arg| {
        std.log.info("arg: {s}", .{arg});
    }
}
