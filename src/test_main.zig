const std = @import("std");
const testing = std.testing;

test "allocator basic functionality" {
    var allocator_instance = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = allocator_instance.deinit();
    const alloc = allocator_instance.allocator();
    
    const buffer = try alloc.alloc(u8, 100);
    defer alloc.free(buffer);
    
    try testing.expect(buffer.len == 100);
}

test "string operations" {
    const message = "Hello, Zig!";
    try testing.expect(message.len == 11);
    try testing.expectEqualStrings("Hello, Zig!", message);
}
