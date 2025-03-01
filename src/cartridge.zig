const std = @import("std");

pub fn load(file_path: []const u8) anyerror![]u8 {
    const allocator = std.heap.page_allocator;

    const file = try std.fs.cwd().openFile(file_path, .{});
    defer file.close();

    const file_size = try file.getEndPos();

    const buffer = try allocator.alloc(u8, file_size);

    const bytes_read = try file.readAll(buffer);
    std.debug.assert(bytes_read == file_size);

    return buffer;
}
