const std = @import("std");

const FingerPrintArgs = struct { target: [:0]const u8 };

// TODO: fix this -- this is vibed. We can probably use an official regex. Good enough for now
fn is_valid_ip(ip: [:0]const u8) bool {
    var ip_parts = std.mem.splitScalar(u8, ip, '.');
    var parts: usize = 0;
    while (ip_parts.next()) |part| {
        if (part.len == 0 or part.len > 3) return false;
        for (part) |c| {
            if (c < '0' or c > '9') return false;
        }
        parts += 1;
    }
    return parts == 4;
}

fn fingerprint_dispatcher(flags: []const [:0]const u8) !void {
    var target: ?[:0]const u8 = null;

    var i: usize = 0;
    while (i < flags.len) : (i += 1) {
        const flag = flags[i];

        if (std.mem.eql(u8, flag, "--target")) {
            i += 1;

            if (i >= flags.len) return error.MissingTargetArgument;
            if (std.mem.startsWith(u8, flags[i], "--")) return error.MissingTargetValue;
            if (!is_valid_ip(flags[i])) return error.InvalidTargetValue;
            target = flags[i];
        } else {
            return error.UnknownFingerprintFlag;
        }
    }

    // We keep local target optional, but required for the fingerprint dispatcher
    // Error handling here by assigning the optional to the struct or throwing
    const fingerprint_args: FingerPrintArgs = .{
        .target = target orelse return error.MissingTargetFlag,
    };

    std.debug.print("fingerprint target: {s}\n", .{fingerprint_args.target});
}

pub fn parse_args(args: []const [:0]const u8) !void {
    const command = args[1];
    const command_args = args[2..];

    if (args.len > 1) {
        if (std.mem.eql(u8, command, "--help")) {
            std.debug.print("usage: {s} [args...]\n", .{args[0]});
            return;
        } else if (std.mem.eql(u8, command, "fingerprint")) {
            fingerprint_dispatcher(command_args) catch |err| {
                switch (err) {

                    // TODO: Better error messages
                    error.MissingTargetFlag => std.debug.print("missing target flag\n", .{}),
                    error.MissingTargetArgument => std.debug.print("missing target argument\n", .{}),
                    error.MissingTargetValue => std.debug.print("missing target value\n", .{}),
                    error.InvalidTargetValue => std.debug.print("invalid target value\n", .{}),
                    error.UnknownFingerprintFlag => std.debug.print("unknown fingerprint flag\n", .{}),
                }
            };
            return;
        }
    }

    for (args[1..]) |arg| {
        std.log.info("arg: {s}", .{arg});
    }
}
