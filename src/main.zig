const std = @import("std");

const Registers = @import("registers.zig");
const Memory = @import("memory.zig");
const Cpu = @import("cpu.zig");
const Cartridge = @import("cartridge.zig");

pub fn main() anyerror!void {
    var cpu = Cpu.init();

    try cpu.loadDmgBootRom("./roms/dmg_boot.bin");
    // try cpu.loadDmgBootRom("./roms/dmg_boot.bin");

    while (true) {
        cpu.step();

        if (cpu.memory.memory[0xff02] == 0x81) {
            const a = cpu.memory.memory[0xff01];
            std.debug.print("{c}", .{a});
            cpu.memory.memory[0xff02] = 0x0;
        }
    }
}

test {
    _ = @import("registers.zig");
}
