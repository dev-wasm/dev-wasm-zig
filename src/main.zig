// inspired by https://github.com/kubkon/zig-wasi-tutorial/blob/main/src/main.zig (thanks!)
const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();
    
    // Get stdout writer for output (requires buffer for Zig 0.15.2)
    var output_buffer: [4096]u8 = undefined;
    var stdout_file_writer = std.fs.File.stdout().writer(&output_buffer);
    const out = &stdout_file_writer.interface;
    try out.print("Hello, Zig!\n", .{});
    try out.flush();

    // Setup the pre-opened file descriptors
    const preopens = try std.fs.wasi.preopensAlloc(allocator);
    defer {
        for (preopens.names) |name| {
            allocator.free(name);
        }
        allocator.free(preopens.names);
    }

    // Look for the '.' directory
    if (preopens.find(".")) |fd| {
        const dir = std.fs.Dir{ .fd = fd };
        var file = try dir.createFile(
            "test.txt",
            .{ .read = true },
        );
        defer file.close();
        try file.writeAll("This is a test");
        try file.seekTo(0);
        
        const read_buf = try file.readToEndAlloc(allocator, 1024);
        defer allocator.free(read_buf);

        var file2 = try dir.createFile(
            "test2.txt",
            .{ .read = false },
        );
        defer file2.close();
        try file2.writeAll(read_buf);
    }
}