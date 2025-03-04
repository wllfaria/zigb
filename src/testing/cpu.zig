const std = @import("std");
const testing = std.testing;

const Cpu = @import("../cpu.zig");
const OpCodes = @import("../op_codes.zig");

test "LD R16, Imm16" {
    var cpu = Cpu.init();

    cpu.memory.write(0x0000, @intFromEnum(OpCodes.OpCode.LdHLImm16));
    cpu.memory.writeWord(0x0001, 0x1234);

    const cycles = cpu.step();
    const flags = cpu.registers.getFlags();

    try testing.expectEqual(12, cycles);
    try testing.expectEqual(0x1234, cpu.registers.get(.HL));

    try testing.expectEqual(false, flags.carry);
    try testing.expectEqual(false, flags.half);
    try testing.expectEqual(false, flags.subtract);
    try testing.expectEqual(false, flags.zero);
}

test "LD [R16], r8" {
    var cpu = Cpu.init();
    cpu.registers.setUpper(.AF, 0x12);
    cpu.registers.set(.HL, 0xC0D3);

    cpu.memory.write(0x0000, @intFromEnum(OpCodes.OpCode.LdHLMemA));

    const cycles = cpu.step();
    const flags = cpu.registers.getFlags();

    try testing.expectEqual(8, cycles);
    try testing.expectEqual(0xC0D3, cpu.registers.get(.HL));
    try testing.expectEqual(0x12, cpu.memory.read(0xC0D3));

    try testing.expectEqual(false, flags.carry);
    try testing.expectEqual(false, flags.half);
    try testing.expectEqual(false, flags.subtract);
    try testing.expectEqual(false, flags.zero);
}

test "LD [R16+], r8" {
    var cpu = Cpu.init();
    cpu.registers.setUpper(.AF, 0x12);
    cpu.registers.set(.HL, 0xC0D3);

    cpu.memory.write(0x0000, @intFromEnum(OpCodes.OpCode.LdHLMemAddA));

    const cycles = cpu.step();
    const flags = cpu.registers.getFlags();

    try testing.expectEqual(8, cycles);
    try testing.expectEqual(0xC0D4, cpu.registers.get(.HL));
    try testing.expectEqual(0x12, cpu.memory.read(0xC0D3));

    try testing.expectEqual(false, flags.carry);
    try testing.expectEqual(false, flags.half);
    try testing.expectEqual(false, flags.subtract);
    try testing.expectEqual(false, flags.zero);
}

test "LD [R16-], r8" {
    var cpu = Cpu.init();
    cpu.registers.setUpper(.AF, 0x12);
    cpu.registers.set(.HL, 0xC0D3);

    cpu.memory.write(0x0000, @intFromEnum(OpCodes.OpCode.LdHLMemSubA));

    const cycles = cpu.step();
    const flags = cpu.registers.getFlags();

    try testing.expectEqual(8, cycles);
    try testing.expectEqual(0xC0D2, cpu.registers.get(.HL));
    try testing.expectEqual(0x12, cpu.memory.read(0xC0D3));

    try testing.expectEqual(false, flags.carry);
    try testing.expectEqual(false, flags.half);
    try testing.expectEqual(false, flags.subtract);
    try testing.expectEqual(false, flags.zero);
}

test "LD r8, imm8" {
    var cpu = Cpu.init();

    cpu.memory.write(0x0000, @intFromEnum(OpCodes.OpCode.LdBImm8));
    cpu.memory.write(0x0001, 0x12);

    cpu.memory.write(0x0002, @intFromEnum(OpCodes.OpCode.LdCImm8));
    cpu.memory.write(0x0003, 0x34);

    var cycles = cpu.step();
    var flags = cpu.registers.getFlags();

    try testing.expectEqual(8, cycles);
    try testing.expectEqual(0x1200, cpu.registers.get(.BC));
    try testing.expectEqual(0x12, cpu.registers.getUpper(.BC));
    try testing.expectEqual(0x00, cpu.registers.getLower(.BC));

    try testing.expectEqual(false, flags.carry);
    try testing.expectEqual(false, flags.half);
    try testing.expectEqual(false, flags.subtract);
    try testing.expectEqual(false, flags.zero);

    cycles = cpu.step();
    flags = cpu.registers.getFlags();

    try testing.expectEqual(8, cycles);
    try testing.expectEqual(0x1234, cpu.registers.get(.BC));
    try testing.expectEqual(0x12, cpu.registers.getUpper(.BC));
    try testing.expectEqual(0x34, cpu.registers.getLower(.BC));

    try testing.expectEqual(false, flags.carry);
    try testing.expectEqual(false, flags.half);
    try testing.expectEqual(false, flags.subtract);
    try testing.expectEqual(false, flags.zero);
}

test "LD A, [r16]" {
    var cpu = Cpu.init();
    // dummy value for checking
    cpu.registers.set(.AF, 0xAB00);

    cpu.registers.set(.HL, 0xC0D3);
    cpu.memory.write(0xC0D3, 0x12);

    cpu.memory.write(0x0000, @intFromEnum(OpCodes.OpCode.LdAHLMem));

    const cycles = cpu.step();
    const flags = cpu.registers.getFlags();

    try testing.expectEqual(8, cycles);
    try testing.expectEqual(0xC0D3, cpu.registers.get(.HL));
    try testing.expectEqual(0x12, cpu.memory.read(0xC0D3));
    try testing.expectEqual(0x12, cpu.registers.getUpper(.AF));
    try testing.expectEqual(0x00, cpu.registers.getLower(.AF));

    try testing.expectEqual(false, flags.carry);
    try testing.expectEqual(false, flags.half);
    try testing.expectEqual(false, flags.subtract);
    try testing.expectEqual(false, flags.zero);
}

test "LD A, [r16+]" {
    var cpu = Cpu.init();
    // dummy value for checking
    cpu.registers.set(.AF, 0xAB00);

    cpu.registers.set(.HL, 0xC0D3);
    cpu.memory.write(0xC0D3, 0x12);

    cpu.memory.write(0x0000, @intFromEnum(OpCodes.OpCode.LdAHLMemAdd));

    const cycles = cpu.step();
    const flags = cpu.registers.getFlags();

    try testing.expectEqual(8, cycles);
    try testing.expectEqual(0xC0D4, cpu.registers.get(.HL));
    try testing.expectEqual(0x12, cpu.memory.read(0xC0D3));
    try testing.expectEqual(0x12, cpu.registers.getUpper(.AF));
    try testing.expectEqual(0x00, cpu.registers.getLower(.AF));

    try testing.expectEqual(false, flags.carry);
    try testing.expectEqual(false, flags.half);
    try testing.expectEqual(false, flags.subtract);
    try testing.expectEqual(false, flags.zero);
}

test "LD A, [r16-]" {
    var cpu = Cpu.init();
    // dummy value for checking
    cpu.registers.set(.AF, 0xAB00);

    cpu.registers.set(.HL, 0xC0D3);
    cpu.memory.write(0xC0D3, 0x12);

    cpu.memory.write(0x0000, @intFromEnum(OpCodes.OpCode.LdAHLMemSub));

    const cycles = cpu.step();
    const flags = cpu.registers.getFlags();

    try testing.expectEqual(8, cycles);
    try testing.expectEqual(0xC0D2, cpu.registers.get(.HL));
    try testing.expectEqual(0x12, cpu.memory.read(0xC0D3));
    try testing.expectEqual(0x12, cpu.registers.getUpper(.AF));
    try testing.expectEqual(0x00, cpu.registers.getLower(.AF));

    try testing.expectEqual(false, flags.carry);
    try testing.expectEqual(false, flags.half);
    try testing.expectEqual(false, flags.subtract);
    try testing.expectEqual(false, flags.zero);
}

test "LD A, [imm16]" {
    var cpu = Cpu.init();
    // dummy value for checking
    cpu.registers.set(.AF, 0xAB00);
    cpu.memory.write(0xC0D3, 0x12);

    cpu.memory.write(0x0000, @intFromEnum(OpCodes.OpCode.LdAImm16Mem));
    cpu.memory.write(0x0001, 0xD3);
    cpu.memory.write(0x0002, 0xC0);

    const cycles = cpu.step();
    const flags = cpu.registers.getFlags();

    try testing.expectEqual(16, cycles);
    try testing.expectEqual(0x12, cpu.memory.read(0xC0D3));
    try testing.expectEqual(0x12, cpu.registers.getUpper(.AF));
    try testing.expectEqual(0x00, cpu.registers.getLower(.AF));

    try testing.expectEqual(false, flags.carry);
    try testing.expectEqual(false, flags.half);
    try testing.expectEqual(false, flags.subtract);
    try testing.expectEqual(false, flags.zero);
}

test "LDH [c], A" {
    var cpu = Cpu.init();
    // dummy value for checking
    cpu.registers.set(.BC, 0xC0D3);
    cpu.registers.set(.AF, 0x1200);

    cpu.memory.write(0x0000, @intFromEnum(OpCodes.OpCode.LdhCMemA));

    const cycles = cpu.step();
    const flags = cpu.registers.getFlags();

    try testing.expectEqual(8, cycles);
    try testing.expectEqual(0x12, cpu.memory.read(0xFFD3));
    try testing.expectEqual(0xC0D3, cpu.registers.get(.BC));
    try testing.expectEqual(0x12, cpu.registers.getUpper(.AF));
    try testing.expectEqual(0x00, cpu.registers.getLower(.AF));

    try testing.expectEqual(false, flags.carry);
    try testing.expectEqual(false, flags.half);
    try testing.expectEqual(false, flags.subtract);
    try testing.expectEqual(false, flags.zero);
}

test "LDH [imm8], A" {
    var cpu = Cpu.init();
    // dummy value for checking
    cpu.registers.set(.AF, 0x1200);

    cpu.memory.write(0x0000, @intFromEnum(OpCodes.OpCode.LdhImm8MemA));
    cpu.memory.write(0x0001, 0xD3);

    const cycles = cpu.step();
    const flags = cpu.registers.getFlags();

    try testing.expectEqual(12, cycles);
    try testing.expectEqual(0x12, cpu.memory.read(0xFFD3));
    try testing.expectEqual(0x12, cpu.registers.getUpper(.AF));
    try testing.expectEqual(0x00, cpu.registers.getLower(.AF));

    try testing.expectEqual(false, flags.carry);
    try testing.expectEqual(false, flags.half);
    try testing.expectEqual(false, flags.subtract);
    try testing.expectEqual(false, flags.zero);
}

test "LDH A, [imm8]" {
    var cpu = Cpu.init();
    cpu.memory.write(0xFFD3, 0x12);

    cpu.memory.write(0x0000, @intFromEnum(OpCodes.OpCode.LdhAImm8Mem));
    cpu.memory.write(0x0001, 0xD3);

    const cycles = cpu.step();
    const flags = cpu.registers.getFlags();

    try testing.expectEqual(12, cycles);
    try testing.expectEqual(0x12, cpu.memory.read(0xFFD3));
    try testing.expectEqual(0x12, cpu.registers.getUpper(.AF));
    try testing.expectEqual(0x00, cpu.registers.getLower(.AF));

    try testing.expectEqual(false, flags.carry);
    try testing.expectEqual(false, flags.half);
    try testing.expectEqual(false, flags.subtract);
    try testing.expectEqual(false, flags.zero);
}

test "LD r8, r8" {
    var cpu = Cpu.init();
    cpu.registers.set(.DE, 0x1234);

    // LD B E
    cpu.memory.write(0x0000, @intFromEnum(OpCodes.OpCode.LdBE));
    // LD C E
    cpu.memory.write(0x0001, @intFromEnum(OpCodes.OpCode.LdCE));
    // LD C D
    cpu.memory.write(0x0002, @intFromEnum(OpCodes.OpCode.LdCD));
    // LD B D
    cpu.memory.write(0x0003, @intFromEnum(OpCodes.OpCode.LdBD));

    var cycles = cpu.step();
    var flags = cpu.registers.getFlags();

    try testing.expectEqual(4, cycles);
    try testing.expectEqual(0x12, cpu.registers.getUpper(.DE));
    try testing.expectEqual(0x34, cpu.registers.getLower(.DE));
    try testing.expectEqual(0x34, cpu.registers.getUpper(.BC));
    try testing.expectEqual(0x00, cpu.registers.getLower(.BC));

    try testing.expectEqual(false, flags.carry);
    try testing.expectEqual(false, flags.half);
    try testing.expectEqual(false, flags.subtract);
    try testing.expectEqual(false, flags.zero);

    cycles = cpu.step();
    flags = cpu.registers.getFlags();

    try testing.expectEqual(4, cycles);
    try testing.expectEqual(0x12, cpu.registers.getUpper(.DE));
    try testing.expectEqual(0x34, cpu.registers.getLower(.DE));
    try testing.expectEqual(0x34, cpu.registers.getUpper(.BC));
    try testing.expectEqual(0x34, cpu.registers.getLower(.BC));

    try testing.expectEqual(false, flags.carry);
    try testing.expectEqual(false, flags.half);
    try testing.expectEqual(false, flags.subtract);
    try testing.expectEqual(false, flags.zero);

    cycles = cpu.step();
    flags = cpu.registers.getFlags();

    try testing.expectEqual(4, cycles);
    try testing.expectEqual(0x12, cpu.registers.getUpper(.DE));
    try testing.expectEqual(0x34, cpu.registers.getLower(.DE));
    try testing.expectEqual(0x34, cpu.registers.getUpper(.BC));
    try testing.expectEqual(0x12, cpu.registers.getLower(.BC));

    try testing.expectEqual(false, flags.carry);
    try testing.expectEqual(false, flags.half);
    try testing.expectEqual(false, flags.subtract);
    try testing.expectEqual(false, flags.zero);

    cycles = cpu.step();
    flags = cpu.registers.getFlags();

    try testing.expectEqual(4, cycles);
    try testing.expectEqual(0x12, cpu.registers.getUpper(.DE));
    try testing.expectEqual(0x34, cpu.registers.getLower(.DE));
    try testing.expectEqual(0x12, cpu.registers.getUpper(.BC));
    try testing.expectEqual(0x12, cpu.registers.getLower(.BC));

    try testing.expectEqual(false, flags.carry);
    try testing.expectEqual(false, flags.half);
    try testing.expectEqual(false, flags.subtract);
    try testing.expectEqual(false, flags.zero);
}

test "LD [imm16], A" {
    var cpu = Cpu.init();
    cpu.registers.set(.AF, 0x1200);

    cpu.memory.write(0x0000, @intFromEnum(OpCodes.OpCode.LdImm16MemA));
    cpu.memory.writeWord(0x0001, 0xC0D3);

    const cycles = cpu.step();
    const flags = cpu.registers.getFlags();

    try testing.expectEqual(16, cycles);
    try testing.expectEqual(0x12, cpu.memory.read(0xC0D3));
    try testing.expectEqual(0x12, cpu.registers.getUpper(.AF));
    try testing.expectEqual(0x00, cpu.registers.getLower(.AF));

    try testing.expectEqual(false, flags.carry);
    try testing.expectEqual(false, flags.half);
    try testing.expectEqual(false, flags.subtract);
    try testing.expectEqual(false, flags.zero);
}

test "XOR A, r8" {
    var cpu = Cpu.init();
    cpu.registers.set(.AF, 0x1200);
    cpu.registers.set(.BC, 0xC0D3);

    cpu.memory.write(0x0000, @intFromEnum(OpCodes.OpCode.XorAA));
    cpu.memory.write(0x0001, @intFromEnum(OpCodes.OpCode.XorAB));

    var cycles = cpu.step();
    var flags = cpu.registers.getFlags();

    try testing.expectEqual(4, cycles);
    try testing.expectEqual(0x00, cpu.registers.getUpper(.AF));
    try testing.expectEqual(0x80, cpu.registers.getLower(.AF));

    try testing.expectEqual(false, flags.carry);
    try testing.expectEqual(false, flags.half);
    try testing.expectEqual(false, flags.subtract);
    try testing.expectEqual(true, flags.zero);

    // resets A
    cpu.registers.set(.AF, 0x1200);

    cycles = cpu.step();
    flags = cpu.registers.getFlags();

    try testing.expectEqual(4, cycles);
    try testing.expectEqual(0xD2, cpu.registers.getUpper(.AF));
    try testing.expectEqual(0x00, cpu.registers.getLower(.AF));

    try testing.expectEqual(false, flags.carry);
    try testing.expectEqual(false, flags.half);
    try testing.expectEqual(false, flags.subtract);
    try testing.expectEqual(false, flags.zero);
}

test "BIT b3, r8" {
    var cpu = Cpu.init();
    cpu.registers.setUpper(.BC, 0b0001_0000);

    cpu.memory.write(0x0000, @intFromEnum(OpCodes.OpCode.CbPrefix));
    cpu.memory.write(0x0001, @intFromEnum(OpCodes.CBOpCode.Bit7B));
    cpu.memory.write(0x0002, @intFromEnum(OpCodes.OpCode.CbPrefix));
    cpu.memory.write(0x0003, @intFromEnum(OpCodes.CBOpCode.Bit4B));

    var cycles = cpu.step();
    var flags = cpu.registers.getFlags();

    try testing.expectEqual(8, cycles);
    try testing.expectEqual(0x0002, cpu.registers.get(.PC));
    try testing.expectEqual(0x10, cpu.registers.getUpper(.BC));
    try testing.expectEqual(0x00, cpu.registers.getLower(.BC));

    try testing.expectEqual(false, flags.carry);
    try testing.expectEqual(true, flags.half);
    try testing.expectEqual(false, flags.subtract);
    try testing.expectEqual(true, flags.zero);

    cycles = cpu.step();
    flags = cpu.registers.getFlags();

    try testing.expectEqual(8, cycles);
    try testing.expectEqual(0x0004, cpu.registers.get(.PC));
    try testing.expectEqual(0x10, cpu.registers.getUpper(.BC));
    try testing.expectEqual(0x00, cpu.registers.getLower(.BC));

    try testing.expectEqual(false, flags.carry);
    try testing.expectEqual(true, flags.half);
    try testing.expectEqual(false, flags.subtract);
    try testing.expectEqual(false, flags.zero);
}

test "ADD A, imm8" {
    var cpu = Cpu.init();
    cpu.registers.setUpper(.AF, 0x10);

    cpu.memory.write(0x0000, @intFromEnum(OpCodes.OpCode.AddAImm8));
    cpu.memory.write(0x0001, 0x05);
    cpu.memory.write(0x0002, @intFromEnum(OpCodes.OpCode.AddAImm8));
    cpu.memory.write(0x0003, 0x00);
    cpu.memory.write(0x0004, @intFromEnum(OpCodes.OpCode.AddAImm8));
    cpu.memory.write(0x0005, 0x01);
    cpu.memory.write(0x0006, @intFromEnum(OpCodes.OpCode.AddAImm8));
    cpu.memory.write(0x0007, 0x01);

    var cycles = cpu.step();
    var flags = cpu.registers.getFlags();

    try testing.expectEqual(8, cycles);
    try testing.expectEqual(0x15, cpu.registers.getUpper(.AF));
    try testing.expectEqual(0x0002, cpu.registers.get(.PC));

    try testing.expectEqual(false, flags.zero);
    try testing.expectEqual(false, flags.half);
    try testing.expectEqual(false, flags.carry);
    try testing.expectEqual(false, flags.subtract);

    cpu.registers.setUpper(.AF, 0x00);
    cycles = cpu.step();
    flags = cpu.registers.getFlags();

    try testing.expectEqual(8, cycles);
    try testing.expectEqual(0x00, cpu.registers.getUpper(.AF));
    try testing.expectEqual(true, flags.zero);
    try testing.expectEqual(false, flags.half);
    try testing.expectEqual(false, flags.carry);
    try testing.expectEqual(false, flags.subtract);
    try testing.expectEqual(0x0004, cpu.registers.get(.PC));

    cpu.registers.setUpper(.AF, 0x0F);
    cycles = cpu.step();
    flags = cpu.registers.getFlags();

    try testing.expectEqual(8, cycles);
    try testing.expectEqual(0x10, cpu.registers.getUpper(.AF));
    try testing.expectEqual(false, flags.zero);
    try testing.expectEqual(true, flags.half);
    try testing.expectEqual(false, flags.carry);
    try testing.expectEqual(false, flags.subtract);
    try testing.expectEqual(0x0006, cpu.registers.get(.PC));

    cpu.registers.setUpper(.AF, 0xFF);
    cycles = cpu.step();
    flags = cpu.registers.getFlags();

    try testing.expectEqual(8, cycles);
    try testing.expectEqual(0x00, cpu.registers.getUpper(.AF));
    try testing.expectEqual(true, flags.zero);
    try testing.expectEqual(true, flags.half);
    try testing.expectEqual(true, flags.carry);
    try testing.expectEqual(false, flags.subtract);
    try testing.expectEqual(0x0008, cpu.registers.get(.PC));
}

test "JR COND, imm8" {
    var cpu = Cpu.init();

    cpu.memory.write(0x0000, @intFromEnum(OpCodes.OpCode.JrZImm8));
    cpu.memory.write(0x0001, 0x09);
    cpu.memory.write(0x0002, @intFromEnum(OpCodes.OpCode.JrNZImm8));
    cpu.memory.write(0x0003, 0x09);
    cpu.memory.write(0x000d, @intFromEnum(OpCodes.OpCode.JrNCImm8));
    cpu.memory.write(0x000e, 0xF9);

    var cycles = cpu.step();
    var flags = cpu.registers.getFlags();

    try testing.expectEqual(8, cycles);
    try testing.expectEqual(0x0002, cpu.registers.get(.PC));

    try testing.expectEqual(false, flags.carry);
    try testing.expectEqual(false, flags.half);
    try testing.expectEqual(false, flags.subtract);
    try testing.expectEqual(false, flags.zero);

    cycles = cpu.step();
    flags = cpu.registers.getFlags();

    try testing.expectEqual(12, cycles);
    try testing.expectEqual(0x000d, cpu.registers.get(.PC));

    try testing.expectEqual(false, flags.carry);
    try testing.expectEqual(false, flags.half);
    try testing.expectEqual(false, flags.subtract);
    try testing.expectEqual(false, flags.zero);

    cycles = cpu.step();
    flags = cpu.registers.getFlags();

    try testing.expectEqual(12, cycles);
    try testing.expectEqual(0x0008, cpu.registers.get(.PC));

    try testing.expectEqual(false, flags.carry);
    try testing.expectEqual(false, flags.half);
    try testing.expectEqual(false, flags.subtract);
    try testing.expectEqual(false, flags.zero);
}

test "JR imm8" {
    var cpu = Cpu.init();

    cpu.memory.write(0x0000, @intFromEnum(OpCodes.OpCode.JrImm8));
    cpu.memory.write(0x0001, 0x09);
    cpu.memory.write(0x000b, @intFromEnum(OpCodes.OpCode.JrImm8));
    cpu.memory.write(0x000c, 0xF9);

    var cycles = cpu.step();
    var flags = cpu.registers.getFlags();

    try testing.expectEqual(12, cycles);
    try testing.expectEqual(0x000b, cpu.registers.get(.PC));

    try testing.expectEqual(false, flags.carry);
    try testing.expectEqual(false, flags.half);
    try testing.expectEqual(false, flags.subtract);
    try testing.expectEqual(false, flags.zero);

    cycles = cpu.step();
    flags = cpu.registers.getFlags();

    try testing.expectEqual(12, cycles);
    try testing.expectEqual(0x0006, cpu.registers.get(.PC));

    try testing.expectEqual(false, flags.carry);
    try testing.expectEqual(false, flags.half);
    try testing.expectEqual(false, flags.subtract);
    try testing.expectEqual(false, flags.zero);
}

test "CALL imm16" {
    var cpu = Cpu.init();
    cpu.registers.set(.SP, 0xFF00);

    cpu.memory.write(0x0000, @intFromEnum(OpCodes.OpCode.CallImm16));
    cpu.memory.writeWord(0x0001, 0xC0D3);

    const cycles = cpu.step();
    const flags = cpu.registers.getFlags();

    try testing.expectEqual(24, cycles);
    try testing.expectEqual(0xC0D3, cpu.registers.get(.PC));
    try testing.expectEqual(0xFEFE, cpu.registers.get(.SP));
    try testing.expectEqual(0x0003, cpu.memory.readWord(0xFEFE));

    try testing.expectEqual(false, flags.carry);
    try testing.expectEqual(false, flags.half);
    try testing.expectEqual(false, flags.subtract);
    try testing.expectEqual(false, flags.zero);
}

test "RET" {
    var cpu = Cpu.init();
    cpu.registers.set(.SP, 0xFF00);

    cpu.memory.write(0x0000, @intFromEnum(OpCodes.OpCode.CallImm16));
    cpu.memory.writeWord(0x0001, 0xC0D3);

    cpu.memory.write(0xC0D3, @intFromEnum(OpCodes.OpCode.LdAImm8));
    cpu.memory.write(0xC0D4, 0xAB);
    cpu.memory.write(0xC0D5, @intFromEnum(OpCodes.OpCode.Ret));

    var cycles = cpu.step();
    var flags = cpu.registers.getFlags();

    try testing.expectEqual(24, cycles);
    try testing.expectEqual(0xC0D3, cpu.registers.get(.PC));
    try testing.expectEqual(0xFEFE, cpu.registers.get(.SP));
    try testing.expectEqual(0x0003, cpu.memory.readWord(0xFEFE));

    try testing.expectEqual(false, flags.carry);
    try testing.expectEqual(false, flags.half);
    try testing.expectEqual(false, flags.subtract);
    try testing.expectEqual(false, flags.zero);

    cycles = cpu.step();
    cycles = cpu.step();
    flags = cpu.registers.getFlags();

    try testing.expectEqual(16, cycles);
    try testing.expectEqual(0x0003, cpu.registers.get(.PC));
    try testing.expectEqual(0xFF00, cpu.registers.get(.SP));
    try testing.expectEqual(0xAB, cpu.registers.getUpper(.AF));

    try testing.expectEqual(false, flags.carry);
    try testing.expectEqual(false, flags.half);
    try testing.expectEqual(false, flags.subtract);
    try testing.expectEqual(false, flags.zero);
}
