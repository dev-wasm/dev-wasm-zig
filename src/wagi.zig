const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();
    
    // Get writer for stdout output (requires buffer in Zig 0.15.2)
    var output_buffer: [4096]u8 = undefined;
    var stdout_file_writer = std.fs.File.stdout().writer(&output_buffer);
    const out = &stdout_file_writer.interface;
    try out.print("Content-type: text/html\n", .{});
    try out.print("\n", .{});

    var envMap = try std.process.getEnvMap(allocator);
    defer envMap.deinit();
    const queryString = envMap.getPtr("QUERY_STRING");
    
    if (queryString) |qs| {
        try out.print("<html><body><h3>Hello world!</h3>{s}</body></html>", .{qs.*});
    } else {
        try out.print("<html><body><h3>Hello world!</h3></body></html>", .{});
    }
    try out.flush();
}