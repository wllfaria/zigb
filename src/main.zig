const std = @import("std");

const Registers = @import("registers.zig");
const Memory = @import("memory.zig");
const Cpu = @import("cpu.zig");
const Cartridge = @import("cartridge.zig");

pub fn main() anyerror!void {
    var cpu = Cpu.init();

    // try cpu.loadDmgBootRom("./roms/dmg_boot.gb");
    try cpu.loadRom("./roms/01-special.gb");
    // try cpu.loadRom("./roms/02-interrupts.gb");
    // try cpu.loadRom("./roms/03-op sp,hl.gb");
    // try cpu.loadRom("./roms/04-op r,imm.gb");
    // try cpu.loadRom("./roms/05-op rp.gb");
    // try cpu.loadRom("./roms/06-ld r,r.gb");
    // try cpu.loadRom("./roms/07-jr,jp,call,ret,rst.gb");
    // try cpu.loadRom("./roms/08-misc instrs.gb");
    // try cpu.loadRom("./roms/09-op r,r.gb");
    // try cpu.loadRom("./roms/10-bit ops.gb");
    // try cpu.loadRom("./roms/11-op a,(hl).gb");

    while (true) {
        const cycles = cpu.step();
        cpu.handleTimer(cycles);
        cpu.serviceInterrupts();

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
