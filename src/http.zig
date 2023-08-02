const types = @cImport({
    // See https://github.com/ziglang/zig/issues/515
    @cDefine("_NO_CRT_STDIO_INLINE", "1");
    @cInclude("./c/proxy.h");
});

const std = @import("std");

var gpa = std.heap.GeneralPurposeAllocator(.{}){};

pub fn main() !void {
    //const allocator = gpa.allocator();
    const stdout = std.io.getStdOut().writer();
    //var statusCode: u16 = 0;
    //var handle: u32 = 0;

    var content_type: []types.types_tuple2_string_string_t = 
    []types.types_tuple2_string_string_t{
        types.types_tuple2_string_string_t{
            .f0 = types.types_string_t{ .ptr = "User-agent", .len = 10 },
            .f1 = types.types_string_t{ .ptr = "WASI-HTTP/0.0.1", .len = 15},
        },
        types.types_tuple2_string_string_t{
            .f0 = types.types_string_t{ .ptr = "Content-type", .len = 12 },
            .f1 = types.types_string_t{ .ptr = "application/json", .len = 16},
        }};
    
    var headers_list: types.types_list_tuple2_string_string_t =
    types.types_list_tuple2_string_string_t{
        .ptr = &content_type[0],
        .len = 2,
    };
    var headers: types.wasi_http_types_fields_t = types.wasi_http_types_new_fields(&headers_list);

    stdout.Printf("Headers: %d\n", headers);

}