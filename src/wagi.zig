const std = @import("std");

var gpa = std.heap.GeneralPurposeAllocator(.{}){};

pub fn main() !void {
    const allocator = gpa.allocator();
    var buf: [4096]u8 = undefined;
    var writer = std.fs.File.stdout().writer(&buf);
    const stdout = &writer.interface;
    try stdout.print("Content-type: text/html\n", .{});
    try stdout.print("\n", .{});

    const envMap = try std.process.getEnvMap(allocator);
    const queryString = envMap.getPtr("QUERY_STRING");
    
    if (queryString) |qs| {
        try stdout.print("<html><body><h3>Hello world!</h3>{s}</body></html>", .{qs.*});
    } else {
        try stdout.print("<html><body><h3>Hello world!</h3></body></html>", .{});
    }
    try stdout.flush();
}