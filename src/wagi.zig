const std = @import("std");

var gpa = std.heap.GeneralPurposeAllocator(.{}){};

pub fn main() !void {
    const allocator = gpa.allocator();
    const stdout = std.io.getStdOut().writer();
    try stdout.print("Content-type: text/html\n", .{});
    try stdout.print("\n", .{});

    const envMap = try std.process.getEnvMap(allocator);
    const queryString = envMap.getPtr("QUERY_STRING");
    
    try stdout.print("<html><body><h3>Hello world!</h3>{?s}</body></html", .{queryString.?.*});
}