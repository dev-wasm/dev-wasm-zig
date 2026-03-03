const std = @import("std");

var gpa = std.heap.GeneralPurposeAllocator(.{}){};

pub fn main() !void {
    const allocator = gpa.allocator();
    // Get writer for stdout output
    const stdout_writer = std.fs.File.stdout().writer();
    try stdout_writer.print("Content-type: text/html\n", .{});
    try stdout_writer.print("\n", .{});

    const envMap = try std.process.getEnvMap(allocator);
    const queryString = envMap.getPtr("QUERY_STRING");
    
    if (queryString) |qs| {
        try stdout_writer.print("<html><body><h3>Hello world!</h3>{s}</body></html>", .{qs.*});
    } else {
        try stdout_writer.print("<html><body><h3>Hello world!</h3></body></html>", .{});
    }
}