const std = @import("std");

var gpa = std.heap.GeneralPurposeAllocator(.{}){};

pub fn main() !void {
    const allocator = gpa.allocator();
    var bw = std.io.bufferedWriter(std.fs.File.stdout().writer());
    const stdout = bw.writer();
    try stdout.print("Content-type: text/html\n", .{});
    try stdout.print("\n", .{});

    const envMap = try std.process.getEnvMap(allocator);
    const queryString = envMap.getPtr("QUERY_STRING");
    
    if (queryString) |qs| {
        try stdout.print("<html><body><h3>Hello world!</h3>{s}</body></html>", .{qs.*});
    } else {
        try stdout.print("<html><body><h3>Hello world!</h3></body></html>", .{});
    }
    try bw.flush();
}