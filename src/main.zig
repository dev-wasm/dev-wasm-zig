// inspired by https://github.com/kubkon/zig-wasi-tutorial/blob/main/src/main.zig (thanks!)
const std = @import("std");

var gpa = std.heap.GeneralPurposeAllocator(.{}){};

pub fn main() !void {
    const allocator = gpa.allocator();
    const stdout = std.io.getStdOut().writer();
    try stdout.print("Hello, Zig!\n", .{});

    // Setup the pre-opened file descriptors
    var preopens = std.fs.wasi.PreopenList.init(allocator);
    defer preopens.deinit();
    try preopens.populate(null);

    // Look for the '.' directory
    if (preopens.find(std.fs.wasi.PreopenType{ .Dir = "." })) |pr| {
        const dir = std.fs.Dir{ .fd = pr.fd };
        var file = try dir.createFile(
            "test.txt",
            .{ .read = true },
        );
        defer file.close();
        try file.writeAll("This is a test");
        try file.seekTo(0);
        
        const read_buf = try file.readToEndAlloc(allocator, 1024);

        var file2 = try dir.createFile(
            "test2.txt",
            .{ .read = false },
        );
        defer file2.close();
        try file2.writeAll(read_buf);
    }
}