const std = @import("std");

pub const FingerPrintArgs = struct { target: [:0]const u8 };

pub fn fingerprint_runner(args: FingerPrintArgs) void {
    std.debug.print("Dispatcher target: {s}\n", .{args.target});
}
