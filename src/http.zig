pub extern "wasi_experimental_http" fn req(url: *allowzero const u8, url_len: i32, method: *allowzero const u8, method_len: i32, headers: *allowzero const u8, headers_len: i32, body: *allowzero const u8, body_len: i32, statusCode: *u16, handle: *u32) i32;
pub extern "wasi_experimental_http" fn close(handle: i32) i32;
pub extern "wasi_experimental_http" fn body_read(handle: u32, body_buffer: *u8, body_buffer_len: i32, written_bytes: *u32) i32;
pub extern "wasi_experimental_http" fn header_get(handle: u32, name: *allowzero const u8, name_len: i32, body_buffer: *u8, body_buffer_len: i32, written_bytes: *u32) i32;

const std = @import("std");

fn cstring(str: []const u8) *allowzero const u8 {
    if (str.len == 0) {
        return @ptrFromInt(0);
    }
    const cstr: [*c]const u8 = &str[0];
    return cstr;
}

fn request(url: []const u8, method: []const u8, headers: []const u8, body: []const u8, statusCode: *u16, handle: *u32) i32 {
    return req(cstring(url), @intCast(url.len), cstring(method), @intCast(method.len), cstring(headers), @intCast(headers.len), cstring(body), @intCast(body.len), statusCode, handle);
}

fn header(handle: u32, name: []const u8, buffer: []u8, written: *u32) i32 {
    return header_get(handle, cstring(name), @intCast(name.len), &buffer[0], @intCast(buffer.len), written);
}

var gpa = std.heap.GeneralPurposeAllocator(.{}){};

pub fn main() !void {
    const allocator = gpa.allocator();
    var buf: [8192]u8 = undefined;
    var writer = std.fs.File.stdout().writer(&buf);
    const stdout = &writer.interface;
    var statusCode: u16 = 0;
    var handle: u32 = 0;

    var result = request("https://postman-echo.com/get", "GET", "", "", &statusCode, &handle);
    defer _ = close(@intCast(handle));
    if (result != 0) {
        try stdout.print("Response Error: {any}\n", .{result});
        try stdout.flush();
        return;
    }

    try stdout.print("Request succeeded: {d}\n", .{statusCode});

    var header_buffer = try allocator.alloc(u8, 1024);
    var header_len: u32 = 0;
    result = header(handle, "Content-length", header_buffer, &header_len);
    if (result != 0) {
        try stdout.print("Response Error: {any}\n", .{result});
        try stdout.flush();
        return;
    }
    try stdout.print("Content length: {s}\n", .{header_buffer[0..header_len]});
    const len = try std.fmt.parseInt(u32, header_buffer[0..header_len], 10);
    var buffer = try allocator.alloc(u8, len + 1);
    defer allocator.free(buffer);

    var written: u32 = 0; 
    result = body_read(handle, &buffer[0], @intCast(buffer.len), &written);
    if (result != 0) {
        try stdout.print("Response Error: {any}\n", .{result});
        try stdout.flush();
        return;
    }
    try stdout.print("{s}\n", .{buffer[0..written]});
    try stdout.flush();
}

// Tests
const testing = std.testing;

test "cstring with non-empty string" {
    const input = "hello";
    const result = cstring(input);
    try testing.expect(@intFromPtr(result) != 0);
}

test "cstring with empty string returns null pointer" {
    const empty = "";
    const result = cstring(empty);
    try testing.expectEqual(0, @intFromPtr(result));
}