const std = @import("std");

const Constants = @import("constants.zig");
const Registers = @import("registers.zig");

memory: [0xFFFF]u8,

pub fn init() @This() {
    return @This(){ .memory = .{0} ** 0xFFFF };
}

pub fn read(self: *@This(), address: u16) u8 {
    return self.memory[address];
}

pub fn readWord(self: *@This(), address: u16) u16 {
    const lower = @as(u16, self.read(address));
    const upper = @as(u16, self.read(address + 1)) << 8;
    return lower | upper;
}

pub fn write(self: *@This(), address: u16, value: u8) void {
    self.memory[address] = value;
}

pub fn writeWord(self: *@This(), address: u16, value: u16) void {
    const upper: u8 = @truncate(value >> 8);
    const lower: u8 = @truncate(value);
    self.write(address, lower);
    self.write(address + 1, upper);
}

pub fn stackPush(self: *@This(), registers: *Registers, value: u16) void {
    registers.decrement(.SP, 2);
    self.writeWord(registers.get(.SP), value);
}

pub fn loadBootRoom(self: *@This(), file_path: []const u8, variant: Constants.BootRomVariant) anyerror!void {
    const file = try std.fs.cwd().openFile(file_path, .{});
    defer file.close();

    switch (variant) {
        .DMG => {
            const expected_size = 0x100;
            var boot_rom: [expected_size]u8 = undefined;

            var fba = std.heap.FixedBufferAllocator.init(&boot_rom);
            _ = try fba.allocator().alloc(u8, expected_size);

            const bytes_read = try file.read(&boot_rom);
            std.debug.assert(bytes_read == expected_size);

            for (boot_rom, 0..) |byte, address| {
                self.write(@intCast(address), byte);
            }
        },
        .GBC => {},
    }
}
