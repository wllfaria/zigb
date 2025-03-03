const std = @import("std");

const Instructions = @import("instructions.zig");
const Memory = @import("memory.zig");
const OpCodes = @import("op_codes.zig");
const Registers = @import("registers.zig");

/// 4.194304 MHz
const CPU_FREQUENCY: u32 = 4194304;

// Interrupt registers
const INTERRUPT_FLAG: u16 = 0xFF0F;
const INTERRUPT_ENABLE: u16 = 0xFFFF;

// Timer registers
/// DIV
const DIVIDER_REGISTER: u16 = 0xFF04;
/// TIMA
const TIMER_COUNTER: u16 = 0xFF05;
/// TMA
const TIMER_MODULO: u16 = 0xFF06;
/// TAC
const TIMER_CONTROL: u16 = 0xFF07;

const VBLANK_ADDRESS: u16 = 0x0040;
const LCD_ADDRESS: u16 = 0x0048;
const TIMER_ADDRESS: u16 = 0x0050;
const SERIAL_ADDRESS: u16 = 0x0058;
const JOYPAD_ADDRESS: u16 = 0x0060;

registers: Registers,
memory: Memory,
/// Interrupts Master Enable flag
ime: bool = false,
/// Tracks clock cycles for the DIV register
div_clocksum: u16 = 0,
/// Tracks clock cycles for the TIMA (Timer Counter) register
timer_clocksum: u16 = 0,

pub fn init() @This() {
    return @This(){
        .registers = Registers.init(),
        .memory = Memory.init(),
    };
}

pub fn step(self: *@This()) u16 {
    const op_code: OpCodes.OpCode = @enumFromInt(self.fetch());
    const instruction = self.decode(op_code);
    return self.execute(instruction);
}

fn fetch(self: *@This()) u8 {
    const op_code = self.memory.read(self.registers.get(.PC));
    self.registers.increment(.PC, 1);
    return op_code;
}

fn fetchWord(self: *@This()) u16 {
    const word = self.memory.readWord(self.registers.get(.PC));
    self.registers.increment(.PC, 2);
    return word;
}

// TODO(wiru): I dont like this, fix it
fn fetchCB(self: *@This()) OpCodes.CBOpCode {
    const op_code = self.memory.read(self.registers.get(.PC));
    self.registers.increment(.PC, 1);
    return @enumFromInt(op_code);
}

/// TODO(wiru): I don't think returning optional here is necessary..
fn decode(self: *@This(), op_code: OpCodes.OpCode) Instructions.Instruction {
    switch (op_code) {
        .Nop => return Instructions.Instruction.Nop,
        .LdBCImm16 => return Instructions.Instruction{ .LdR16Imm16 = .{
            .dest = .BC,
            .source = self.fetchWord(),
        } },
        .LdDEImm16 => return Instructions.Instruction{ .LdR16Imm16 = .{
            .dest = .DE,
            .source = self.fetchWord(),
        } },
        .LdHLImm16 => return Instructions.Instruction{ .LdR16Imm16 = .{
            .dest = .HL,
            .source = self.fetchWord(),
        } },
        .LdSPImm16 => return Instructions.Instruction{ .LdR16Imm16 = .{
            .dest = .SP,
            .source = self.fetchWord(),
        } },
        .LdDEMemA => return Instructions.Instruction{ .LdR16MemR8 = .{
            .dest = .DE,
            .source = .AF,
            .source_nibble = .Upper,
        } },
        .LdHLMemA => return Instructions.Instruction{ .LdR16MemR8 = .{
            .dest = .HL,
            .source = .AF,
            .source_nibble = .Upper,
        } },
        .LdHLMemSubA => return Instructions.Instruction{ .LdR16MemR8 = .{
            .dest = .HL,
            .decrement = true,
            .source = .AF,
            .source_nibble = .Upper,
        } },
        .LdHLMemAddA => return Instructions.Instruction{ .LdR16MemR8 = .{
            .dest = .HL,
            .increment = true,
            .source = .AF,
            .source_nibble = .Upper,
        } },
        .LdHLMemB => return Instructions.Instruction{ .LdR16MemR8 = .{
            .dest = .HL,
            .source = .BC,
            .source_nibble = .Upper,
        } },
        .LdHLMemE => return Instructions.Instruction{ .LdR16MemR8 = .{
            .dest = .HL,
            .source = .DE,
            .source_nibble = .Lower,
        } },
        .LdAImm8 => return Instructions.Instruction{ .LdR8Imm8 = .{
            .dest = .AF,
            .source = self.fetch(),
            .nibble = .Upper,
        } },
        .LdBImm8 => return Instructions.Instruction{ .LdR8Imm8 = .{
            .dest = .BC,
            .source = self.fetch(),
            .nibble = .Upper,
        } },
        .LdCImm8 => return Instructions.Instruction{ .LdR8Imm8 = .{
            .dest = .BC,
            .source = self.fetch(),
            .nibble = .Lower,
        } },
        .LdDImm8 => return Instructions.Instruction{ .LdR8Imm8 = .{
            .dest = .DE,
            .source = self.fetch(),
            .nibble = .Upper,
        } },
        .LdEImm8 => return Instructions.Instruction{ .LdR8Imm8 = .{
            .dest = .DE,
            .source = self.fetch(),
            .nibble = .Lower,
        } },
        .LdHImm8 => return Instructions.Instruction{ .LdR8Imm8 = .{
            .dest = .HL,
            .source = self.fetch(),
            .nibble = .Upper,
        } },
        .LdLImm8 => return Instructions.Instruction{ .LdR8Imm8 = .{
            .dest = .HL,
            .source = self.fetch(),
            .nibble = .Lower,
        } },
        .LdAA => return Instructions.Instruction{ .LdR8R8 = .{
            .dest = .AF,
            .dest_nibble = .Upper,
            .source = .AF,
            .source_nibble = .Upper,
        } },
        .LdAB => return Instructions.Instruction{ .LdR8R8 = .{
            .dest = .AF,
            .dest_nibble = .Upper,
            .source = .BC,
            .source_nibble = .Upper,
        } },
        .LdAC => return Instructions.Instruction{ .LdR8R8 = .{
            .dest = .AF,
            .dest_nibble = .Upper,
            .source = .BC,
            .source_nibble = .Lower,
        } },
        .LdAD => return Instructions.Instruction{ .LdR8R8 = .{
            .dest = .AF,
            .dest_nibble = .Upper,
            .source = .DE,
            .source_nibble = .Upper,
        } },
        .LdAE => return Instructions.Instruction{ .LdR8R8 = .{
            .dest = .AF,
            .dest_nibble = .Upper,
            .source = .DE,
            .source_nibble = .Lower,
        } },
        .LdAH => return Instructions.Instruction{ .LdR8R8 = .{
            .dest = .AF,
            .dest_nibble = .Upper,
            .source = .HL,
            .source_nibble = .Upper,
        } },
        .LdAL => return Instructions.Instruction{ .LdR8R8 = .{
            .dest = .AF,
            .dest_nibble = .Upper,
            .source = .HL,
            .source_nibble = .Lower,
        } },
        .LdBA => return Instructions.Instruction{ .LdR8R8 = .{
            .dest = .BC,
            .dest_nibble = .Upper,
            .source = .AF,
            .source_nibble = .Upper,
        } },
        .LdBB => return Instructions.Instruction{ .LdR8R8 = .{
            .dest = .BC,
            .dest_nibble = .Upper,
            .source = .BC,
            .source_nibble = .Upper,
        } },
        .LdBC => return Instructions.Instruction{ .LdR8R8 = .{
            .dest = .BC,
            .dest_nibble = .Upper,
            .source = .BC,
            .source_nibble = .Lower,
        } },
        .LdBD => return Instructions.Instruction{ .LdR8R8 = .{
            .dest = .BC,
            .dest_nibble = .Upper,
            .source = .DE,
            .source_nibble = .Upper,
        } },
        .LdBE => return Instructions.Instruction{ .LdR8R8 = .{
            .dest = .BC,
            .dest_nibble = .Upper,
            .source = .DE,
            .source_nibble = .Lower,
        } },
        .LdBH => return Instructions.Instruction{ .LdR8R8 = .{
            .dest = .BC,
            .dest_nibble = .Upper,
            .source = .HL,
            .source_nibble = .Upper,
        } },
        .LdBL => return Instructions.Instruction{ .LdR8R8 = .{
            .dest = .BC,
            .dest_nibble = .Upper,
            .source = .HL,
            .source_nibble = .Lower,
        } },
        .LdCA => return Instructions.Instruction{ .LdR8R8 = .{
            .dest = .BC,
            .dest_nibble = .Lower,
            .source = .AF,
            .source_nibble = .Upper,
        } },
        .LdCB => return Instructions.Instruction{ .LdR8R8 = .{
            .dest = .BC,
            .dest_nibble = .Lower,
            .source = .BC,
            .source_nibble = .Upper,
        } },
        .LdCC => return Instructions.Instruction{ .LdR8R8 = .{
            .dest = .BC,
            .dest_nibble = .Lower,
            .source = .BC,
            .source_nibble = .Lower,
        } },
        .LdCD => return Instructions.Instruction{ .LdR8R8 = .{
            .dest = .BC,
            .dest_nibble = .Lower,
            .source = .DE,
            .source_nibble = .Upper,
        } },
        .LdCE => return Instructions.Instruction{ .LdR8R8 = .{
            .dest = .BC,
            .dest_nibble = .Lower,
            .source = .DE,
            .source_nibble = .Lower,
        } },
        .LdCH => return Instructions.Instruction{ .LdR8R8 = .{
            .dest = .BC,
            .dest_nibble = .Lower,
            .source = .HL,
            .source_nibble = .Upper,
        } },
        .LdCL => return Instructions.Instruction{ .LdR8R8 = .{
            .dest = .BC,
            .dest_nibble = .Lower,
            .source = .HL,
            .source_nibble = .Lower,
        } },
        .LdDA => return Instructions.Instruction{ .LdR8R8 = .{
            .dest = .DE,
            .dest_nibble = .Upper,
            .source = .AF,
            .source_nibble = .Upper,
        } },
        .LdDB => return Instructions.Instruction{ .LdR8R8 = .{
            .dest = .DE,
            .dest_nibble = .Upper,
            .source = .BC,
            .source_nibble = .Upper,
        } },
        .LdDC => return Instructions.Instruction{ .LdR8R8 = .{
            .dest = .DE,
            .dest_nibble = .Upper,
            .source = .BC,
            .source_nibble = .Lower,
        } },
        .LdDD => return Instructions.Instruction{ .LdR8R8 = .{
            .dest = .DE,
            .dest_nibble = .Upper,
            .source = .DE,
            .source_nibble = .Upper,
        } },
        .LdDE => return Instructions.Instruction{ .LdR8R8 = .{
            .dest = .DE,
            .dest_nibble = .Upper,
            .source = .DE,
            .source_nibble = .Lower,
        } },
        .LdDH => return Instructions.Instruction{ .LdR8R8 = .{
            .dest = .DE,
            .dest_nibble = .Upper,
            .source = .HL,
            .source_nibble = .Upper,
        } },
        .LdDL => return Instructions.Instruction{ .LdR8R8 = .{
            .dest = .DE,
            .dest_nibble = .Upper,
            .source = .HL,
            .source_nibble = .Lower,
        } },
        .LdHA => return Instructions.Instruction{ .LdR8R8 = .{
            .dest = .HL,
            .dest_nibble = .Upper,
            .source = .AF,
            .source_nibble = .Upper,
        } },
        .LdHB => return Instructions.Instruction{ .LdR8R8 = .{
            .dest = .HL,
            .dest_nibble = .Upper,
            .source = .BC,
            .source_nibble = .Upper,
        } },
        .LdHC => return Instructions.Instruction{ .LdR8R8 = .{
            .dest = .HL,
            .dest_nibble = .Upper,
            .source = .BC,
            .source_nibble = .Lower,
        } },
        .LdHD => return Instructions.Instruction{ .LdR8R8 = .{
            .dest = .HL,
            .dest_nibble = .Upper,
            .source = .DE,
            .source_nibble = .Upper,
        } },
        .LdHE => return Instructions.Instruction{ .LdR8R8 = .{
            .dest = .HL,
            .dest_nibble = .Upper,
            .source = .DE,
            .source_nibble = .Lower,
        } },
        .LdHH => return Instructions.Instruction{ .LdR8R8 = .{
            .dest = .HL,
            .dest_nibble = .Upper,
            .source = .HL,
            .source_nibble = .Upper,
        } },
        .LdHL => return Instructions.Instruction{ .LdR8R8 = .{
            .dest = .HL,
            .dest_nibble = .Upper,
            .source = .HL,
            .source_nibble = .Lower,
        } },
        .LdLA => return Instructions.Instruction{ .LdR8R8 = .{
            .dest = .HL,
            .dest_nibble = .Lower,
            .source = .AF,
            .source_nibble = .Upper,
        } },
        .LdLB => return Instructions.Instruction{ .LdR8R8 = .{
            .dest = .HL,
            .dest_nibble = .Lower,
            .source = .BC,
            .source_nibble = .Upper,
        } },
        .LdLC => return Instructions.Instruction{ .LdR8R8 = .{
            .dest = .HL,
            .dest_nibble = .Lower,
            .source = .BC,
            .source_nibble = .Lower,
        } },
        .LdLD => return Instructions.Instruction{ .LdR8R8 = .{
            .dest = .HL,
            .dest_nibble = .Lower,
            .source = .DE,
            .source_nibble = .Upper,
        } },
        .LdLE => return Instructions.Instruction{ .LdR8R8 = .{
            .dest = .HL,
            .dest_nibble = .Lower,
            .source = .DE,
            .source_nibble = .Lower,
        } },
        .LdLH => return Instructions.Instruction{ .LdR8R8 = .{
            .dest = .HL,
            .dest_nibble = .Lower,
            .source = .HL,
            .source_nibble = .Upper,
        } },
        .LdLL => return Instructions.Instruction{ .LdR8R8 = .{
            .dest = .HL,
            .dest_nibble = .Lower,
            .source = .HL,
            .source_nibble = .Lower,
        } },
        .JrNZImm8 => return Instructions.Instruction{ .JrCondImm8 = .{
            .cond = .NotZero,
            .source = self.fetch(),
        } },
        .JrNCImm8 => return Instructions.Instruction{ .JrCondImm8 = .{
            .cond = .NoCarry,
            .source = self.fetch(),
        } },
        .JrZImm8 => return Instructions.Instruction{ .JrCondImm8 = .{
            .cond = .Zero,
            .source = self.fetch(),
        } },
        .XorAA => return Instructions.Instruction{ .XorAR8 = .{
            .source = .AF,
            .nibble = .Upper,
        } },
        .XorAC => return Instructions.Instruction{ .XorAR8 = .{
            .source = .BC,
            .nibble = .Lower,
        } },
        .AndAImm8 => return Instructions.Instruction{ .AndAImm8 = .{
            .source = self.fetch(),
        } },
        .LdAImm16Mem => return Instructions.Instruction{ .LdAImm16Mem = .{
            .source = self.fetchWord(),
        } },
        .JpImm16 => return Instructions.Instruction{ .JpImm16 = .{
            .source = self.fetchWord(),
        } },
        .JpNZImm16 => return Instructions.Instruction{ .JpCondImm16 = .{
            .cond = .NotZero,
            .source = self.fetchWord(),
        } },
        .JpHL => return Instructions.Instruction.JpHL,
        .IncA => return Instructions.Instruction{ .IncR8 = .{
            .dest = .AF,
            .nibble = .Upper,
        } },
        .IncB => return Instructions.Instruction{ .IncR8 = .{
            .dest = .BC,
            .nibble = .Upper,
        } },
        .IncC => return Instructions.Instruction{ .IncR8 = .{
            .dest = .BC,
            .nibble = .Lower,
        } },
        .IncD => return Instructions.Instruction{ .IncR8 = .{
            .dest = .DE,
            .nibble = .Upper,
        } },
        .IncE => return Instructions.Instruction{ .IncR8 = .{
            .dest = .DE,
            .nibble = .Lower,
        } },
        .IncH => return Instructions.Instruction{ .IncR8 = .{
            .dest = .HL,
            .nibble = .Upper,
        } },
        .IncL => return Instructions.Instruction{ .IncR8 = .{
            .dest = .HL,
            .nibble = .Lower,
        } },
        .IncBC => return Instructions.Instruction{ .IncR16 = .{
            .dest = .BC,
        } },
        .AddAImm8 => return Instructions.Instruction{ .AddAImm8 = .{
            .source = self.fetch(),
        } },
        .AdcAImm8 => return Instructions.Instruction{ .AdcAImm8 = .{
            .source = self.fetch(),
        } },
        .SubAImm8 => return Instructions.Instruction{ .SubAImm8 = .{
            .source = self.fetch(),
        } },
        .LdhCMemA => return Instructions.Instruction.LdhCMemA,
        .LdhAImm8Mem => return Instructions.Instruction{ .LdhAImm8Mem = .{
            .source = self.fetch(),
        } },
        .LdhImm8MemA => return Instructions.Instruction{ .LdhImm8MemA = .{
            .dest = self.fetch(),
        } },
        .LdABCMem => return Instructions.Instruction{ .LdAR16Mem = .{
            .source = .BC,
        } },
        .LdADEMem => return Instructions.Instruction{ .LdAR16Mem = .{
            .source = .DE,
        } },
        .CallImm16 => return Instructions.Instruction{ .CallImm16 = .{
            .source = self.fetchWord(),
        } },
        .CallNZImm16 => return Instructions.Instruction{ .CallCondImm16 = .{
            .cond = .NotZero,
            .source = self.fetchWord(),
        } },
        .LdAHLMem => return Instructions.Instruction{ .LdAR16Mem = .{
            .source = .HL,
        } },
        .LdAHLMemAdd => return Instructions.Instruction{ .LdAR16Mem = .{
            .source = .HL,
            .increment = true,
        } },
        .LdAHLMemSub => return Instructions.Instruction{ .LdAR16Mem = .{
            .source = .HL,
            .decrement = true,
        } },
        .JrImm8 => return Instructions.Instruction{ .JrImm8 = .{
            .source = self.fetch(),
        } },
        .PushAF => return Instructions.Instruction{ .PushR16 = .{
            .source = .AF,
        } },
        .PushBC => return Instructions.Instruction{ .PushR16 = .{
            .source = .BC,
        } },
        .PushDE => return Instructions.Instruction{ .PushR16 = .{
            .source = .DE,
        } },
        .PushHL => return Instructions.Instruction{ .PushR16 = .{
            .source = .HL,
        } },
        .PopAF => return Instructions.Instruction{ .PopR16 = .{
            .dest = .AF,
        } },
        .PopBC => return Instructions.Instruction{ .PopR16 = .{
            .dest = .BC,
        } },
        .PopDE => return Instructions.Instruction{ .PopR16 = .{
            .dest = .DE,
        } },
        .PopHL => return Instructions.Instruction{ .PopR16 = .{
            .dest = .HL,
        } },
        .Rra => return Instructions.Instruction{ .RrR8 = .{
            .dest = .AF,
            .nibble = .Upper,
        } },
        .Rla => return Instructions.Instruction{ .RlR8 = .{
            .dest = .AF,
            .nibble = .Upper,
        } },
        .DecA => return Instructions.Instruction{ .DecR8 = .{
            .dest = .AF,
            .nibble = .Upper,
        } },
        .DecB => return Instructions.Instruction{ .DecR8 = .{
            .dest = .BC,
            .nibble = .Upper,
        } },
        .DecC => return Instructions.Instruction{ .DecR8 = .{
            .dest = .BC,
            .nibble = .Lower,
        } },
        .DecD => return Instructions.Instruction{ .DecR8 = .{
            .dest = .DE,
            .nibble = .Upper,
        } },
        .DecE => return Instructions.Instruction{ .DecR8 = .{
            .dest = .DE,
            .nibble = .Lower,
        } },
        .DecH => return Instructions.Instruction{ .DecR8 = .{
            .dest = .HL,
            .nibble = .Upper,
        } },
        .DecL => return Instructions.Instruction{ .DecR8 = .{
            .dest = .HL,
            .nibble = .Lower,
        } },
        .IncHL => return Instructions.Instruction{ .IncR16 = .{
            .dest = .HL,
        } },
        .IncDE => return Instructions.Instruction{ .IncR16 = .{
            .dest = .DE,
        } },
        .CpAImm8 => return Instructions.Instruction{ .CpAImm8 = .{
            .source = self.fetch(),
        } },
        .CpAA => return Instructions.Instruction{ .CpAR8 = .{
            .source = .AF,
            .nibble = .Upper,
        } },
        .CpAB => return Instructions.Instruction{ .CpAR8 = .{
            .source = .BC,
            .nibble = .Upper,
        } },
        .CpAC => return Instructions.Instruction{ .CpAR8 = .{
            .source = .BC,
            .nibble = .Lower,
        } },
        .CpAD => return Instructions.Instruction{ .CpAR8 = .{
            .source = .DE,
            .nibble = .Upper,
        } },
        .CpAE => return Instructions.Instruction{ .CpAR8 = .{
            .source = .DE,
            .nibble = .Lower,
        } },
        .CpAH => return Instructions.Instruction{ .CpAR8 = .{
            .source = .HL,
            .nibble = .Upper,
        } },
        .CpAL => return Instructions.Instruction{ .CpAR8 = .{
            .source = .HL,
            .nibble = .Lower,
        } },
        .Di => return Instructions.Instruction.Di,
        .Ei => return Instructions.Instruction.Ei,
        .Ret => return Instructions.Instruction.Ret,
        .RetZ => return Instructions.Instruction{ .RetCond = .{
            .cond = .Zero,
        } },
        .RetNZ => return Instructions.Instruction{ .RetCond = .{
            .cond = .NotZero,
        } },
        .RetC => return Instructions.Instruction{ .RetCond = .{
            .cond = .Carry,
        } },
        .RetNC => return Instructions.Instruction{ .RetCond = .{
            .cond = .NoCarry,
        } },
        .LdImm16MemA => return Instructions.Instruction{ .LdImm16MemA = .{
            .dest = self.fetchWord(),
        } },
        .OrAA => return Instructions.Instruction{ .OrAR8 = .{
            .source = .AF,
            .nibble = .Upper,
        } },
        .OrAB => return Instructions.Instruction{ .OrAR8 = .{
            .source = .BC,
            .nibble = .Upper,
        } },
        .OrAC => return Instructions.Instruction{ .OrAR8 = .{
            .source = .BC,
            .nibble = .Lower,
        } },
        .OrAD => return Instructions.Instruction{ .OrAR8 = .{
            .source = .DE,
            .nibble = .Upper,
        } },
        .OrAE => return Instructions.Instruction{ .OrAR8 = .{
            .source = .DE,
            .nibble = .Lower,
        } },
        .OrAH => return Instructions.Instruction{ .OrAR8 = .{
            .source = .HL,
            .nibble = .Upper,
        } },
        .OrAL => return Instructions.Instruction{ .OrAR8 = .{
            .source = .HL,
            .nibble = .Lower,
        } },
        .CbPrefix => switch (self.fetchCB()) {
            .Bit7H => return Instructions.Instruction{ .BitB3R8 = .{
                .dest = .HL,
                .source = 7,
            } },
            .RlC => return Instructions.Instruction{ .RlR8 = .{
                .dest = .BC,
                .nibble = .Lower,
            } },
            else => |op| {
                const pc = self.registers.get(.PC) - 1;
                std.debug.print("Unsupported CB opcode: 0x{X:02} ({s}) at 0x{X:04}\n\n\n", .{ @intFromEnum(op), @tagName(op), pc });
                @panic("NOT YET IMPLEMENTED");
            },
        },
        else => |op| {
            const pc = self.registers.get(.PC) - 1;
            std.debug.print("Unsupported opcode: 0x{X:02} ({s}) at 0x{X:04}\n\n\n", .{ @intFromEnum(op), @tagName(op), pc });
            @panic("NOT YET IMPLEMENTED");
        },
    }
}

fn execute(self: *@This(), instruction: Instructions.Instruction) u16 {
    switch (instruction) {
        .Nop => return 4,
        .LdR16Imm16 => |inst| {
            self.registers.set(inst.dest, inst.source);
            return instruction.cycles(false);
        },
        .XorAR8 => |inst| {
            const a = self.registers.getUpper(.AF);
            const value = switch (inst.nibble) {
                .Upper => self.registers.getUpper(inst.source),
                .Lower => self.registers.getLower(inst.source),
            };
            const result = a ^ value;
            self.registers.setUpper(.AF, result);

            var new_flags: Registers.Flags = .{};
            new_flags.zero = result == 0;

            return instruction.cycles(false);
        },
        .LdR16MemR8 => |inst| {
            const address = self.registers.get(inst.dest);
            const value = switch (inst.source_nibble) {
                .Upper => self.registers.getUpper(inst.source),
                .Lower => self.registers.getLower(inst.source),
            };

            self.memory.write(address, value);

            if (inst.increment) self.registers.increment(inst.dest, 1);
            if (inst.decrement) self.registers.decrement(inst.dest, 1);

            return instruction.cycles(false);
        },
        .LdAR16Mem => |inst| {
            const address = self.registers.get(inst.source);
            const value = self.memory.read(address);
            self.registers.setUpper(.AF, value);

            if (inst.increment) self.registers.increment(inst.source, 1);
            if (inst.decrement) self.registers.decrement(inst.source, 1);

            return instruction.cycles(false);
        },
        .BitB3R8 => |inst| {
            const dest = self.registers.getUpper(inst.dest);
            var flags = self.registers.getFlags();

            if (((dest >> inst.source) & 0x01) == 0) {
                flags.zero = true;
            } else {
                flags.zero = false;
            }

            flags.subtract = false;
            flags.half = false;

            self.registers.setFlags(flags);

            return instruction.cycles(false);
        },
        .AddAImm8 => |inst| {
            const a = self.registers.getUpper(.AF);
            const result = a +% inst.source;
            const carry_bits: u16 = a ^ inst.source ^ result;

            self.registers.setUpper(.AF, result);

            var new_flags: Registers.Flags = .{};
            new_flags.zero = result == 0;
            new_flags.carry = (carry_bits & 0x100) != 0;
            new_flags.half = (carry_bits & 0x10) != 0;

            self.registers.setFlags(new_flags);
            return instruction.cycles(false);
        },
        .SubAImm8 => |inst| {
            const a = self.registers.getUpper(.AF);
            const result = a -% inst.source;
            const borrow = a < inst.source;
            const half_borrow = (a & 0xF) < (inst.source & 0xF);

            self.registers.setUpper(.AF, result);

            var new_flags: Registers.Flags = .{};
            new_flags.subtract = true;
            new_flags.zero = result == 0;
            new_flags.carry = borrow;
            new_flags.half = half_borrow;

            self.registers.setFlags(new_flags);
            return instruction.cycles(false);
        },
        .LdAImm16Mem => |inst| {
            const value = self.memory.read(inst.source);
            self.registers.setUpper(.AF, value);
            return instruction.cycles(false);
        },
        .JrCondImm8 => |inst| {
            const flags = self.registers.getFlags();
            const offset: i8 = @bitCast(inst.source);

            switch (inst.cond) {
                .NotZero => if (!flags.zero) {
                    self.registers.set(.PC, self.calculateRelativePC(offset));
                    return instruction.cycles(true);
                },
                .Zero => if (flags.zero) {
                    self.registers.set(.PC, self.calculateRelativePC(offset));
                    return instruction.cycles(true);
                },
                .NoCarry => if (!flags.carry) {
                    self.registers.set(.PC, self.calculateRelativePC(offset));
                    return instruction.cycles(true);
                },
                .Carry => if (flags.carry) {
                    self.registers.set(.PC, self.calculateRelativePC(offset));
                    return instruction.cycles(true);
                },
            }

            return instruction.cycles(false);
        },
        .JrImm8 => |inst| {
            const offset: i8 = @bitCast(inst.source);
            self.registers.set(.PC, self.calculateRelativePC(offset));
            return instruction.cycles(false);
        },
        .LdR8Imm8 => |inst| {
            switch (inst.nibble) {
                .Upper => self.registers.setUpper(inst.dest, inst.source),
                .Lower => self.registers.setLower(inst.dest, inst.source),
            }
            return instruction.cycles(false);
        },
        .LdhCMemA => {
            const lower = self.registers.getLower(.BC);
            const address = 0xFF00 + @as(u16, lower);
            self.memory.write(address, self.registers.getUpper(.AF));
            return instruction.cycles(false);
        },
        .LdhImm8MemA => |inst| {
            const address = 0xFF00 + @as(u16, inst.dest);
            self.memory.write(address, self.registers.getUpper(.AF));
            return instruction.cycles(false);
        },
        .LdhAImm8Mem => |inst| {
            const address = 0xFF00 + @as(u16, inst.source);
            const value = self.memory.read(address);
            self.registers.setUpper(.AF, value);
            return instruction.cycles(false);
        },
        .CallImm16 => |inst| {
            self.memory.pushWord(&self.registers, self.registers.get(.PC));
            self.registers.set(.PC, inst.source);
            return instruction.cycles(false);
        },
        .CallCondImm16 => |inst| {
            const flags = self.registers.getFlags();

            switch (inst.cond) {
                .Zero => if (flags.zero) {
                    self.memory.pushWord(&self.registers, self.registers.get(.PC));
                    self.registers.set(.PC, inst.source);
                    return instruction.cycles(true);
                },
                .NotZero => if (!flags.zero) {
                    self.memory.pushWord(&self.registers, self.registers.get(.PC));
                    self.registers.set(.PC, inst.source);
                    return instruction.cycles(true);
                },
                .Carry => if (flags.carry) {
                    self.memory.pushWord(&self.registers, self.registers.get(.PC));
                    self.registers.set(.PC, inst.source);
                    return instruction.cycles(true);
                },
                .NoCarry => if (!flags.carry) {
                    self.memory.pushWord(&self.registers, self.registers.get(.PC));
                    self.registers.set(.PC, inst.source);
                    return instruction.cycles(true);
                },
            }

            return instruction.cycles(false);
        },
        .Ret => {
            const address = self.memory.popWord(&self.registers);
            self.registers.set(.PC, address);
            return instruction.cycles(false);
        },
        .RetCond => |inst| {
            const flags = self.registers.getFlags();
            switch (inst.cond) {
                .Zero => if (flags.zero) {
                    const address = self.memory.popWord(&self.registers);
                    self.registers.set(.PC, address);
                    return instruction.cycles(true);
                },
                .NotZero => if (!flags.zero) {
                    const address = self.memory.popWord(&self.registers);
                    self.registers.set(.PC, address);
                    return instruction.cycles(true);
                },
                .Carry => if (flags.carry) {
                    const address = self.memory.popWord(&self.registers);
                    self.registers.set(.PC, address);
                    return instruction.cycles(true);
                },
                .NoCarry => if (!flags.carry) {
                    const address = self.memory.popWord(&self.registers);
                    self.registers.set(.PC, address);
                    return instruction.cycles(true);
                },
            }
            return instruction.cycles(false);
        },
        .LdR8R8 => |inst| {
            const value = switch (inst.source_nibble) {
                .Upper => self.registers.getUpper(inst.source),
                .Lower => self.registers.getLower(inst.source),
            };
            switch (inst.dest_nibble) {
                .Upper => self.registers.setUpper(inst.dest, value),
                .Lower => self.registers.setLower(inst.dest, value),
            }
            return instruction.cycles(false);
        },
        .PushR16 => |inst| {
            const value = self.registers.get(inst.source);
            self.memory.pushWord(&self.registers, value);
            return instruction.cycles(false);
        },
        .PopR16 => |inst| {
            const value = self.memory.popWord(&self.registers);
            self.registers.set(inst.dest, value);
            return instruction.cycles(false);
        },
        .DecR8 => |inst| {
            switch (inst.nibble) {
                .Upper => self.registers.decrementUpper(inst.dest, 1),
                .Lower => self.registers.decrementLower(inst.dest, 1),
            }

            const value = switch (inst.nibble) {
                .Upper => self.registers.getUpper(inst.dest),
                .Lower => self.registers.getLower(inst.dest),
            };

            const flags = self.registers.getFlags();

            var new_flags: Registers.Flags = .{};
            new_flags.subtract = true;
            new_flags.carry = flags.carry;
            new_flags.zero = value == 0;
            new_flags.half = (value & 0x0F) == 0x0F;

            self.registers.setFlags(new_flags);
            return instruction.cycles(false);
        },
        .IncR8 => |inst| {
            switch (inst.nibble) {
                .Upper => self.registers.incrementUpper(inst.dest, 1),
                .Lower => self.registers.incrementLower(inst.dest, 1),
            }

            const value = switch (inst.nibble) {
                .Upper => self.registers.getUpper(inst.dest),
                .Lower => self.registers.getLower(inst.dest),
            };

            const flags = self.registers.getFlags();
            var new_flags: Registers.Flags = .{};
            new_flags.carry = flags.carry;
            new_flags.zero = value == 0;
            new_flags.half = (value & 0x0F) == 0x00;

            self.registers.setFlags(new_flags);
            return instruction.cycles(false);
        },
        .IncR16 => |inst| {
            self.registers.increment(inst.dest, 1);
            return instruction.cycles(false);
        },
        .JpImm16 => |inst| {
            self.registers.set(.PC, inst.source);
            return instruction.cycles(false);
        },
        .JpCondImm16 => |inst| {
            const flags = self.registers.getFlags();

            switch (inst.cond) {
                .NotZero => if (!flags.zero) {
                    self.registers.set(.PC, inst.source);
                    return instruction.cycles(true);
                },
                .Zero => if (flags.zero) {
                    self.registers.set(.PC, inst.source);
                    return instruction.cycles(true);
                },
                .NoCarry => if (!flags.carry) {
                    self.registers.set(.PC, inst.source);
                    return instruction.cycles(true);
                },
                .Carry => if (flags.carry) {
                    self.registers.set(.PC, inst.source);
                    return instruction.cycles(true);
                },
            }
            return instruction.cycles(false);
        },
        .JpHL => {
            self.registers.set(.PC, self.registers.get(.HL));
            return instruction.cycles(false);
        },
        .RlR8 => |inst| {
            const flags = self.registers.getFlags();
            const carry: u8 = if (flags.carry) 1 else 0;

            var value = switch (inst.nibble) {
                .Upper => self.registers.getUpper(inst.dest),
                .Lower => self.registers.getLower(inst.dest),
            };

            var new_flags: Registers.Flags = .{};
            new_flags.carry = (value & 0x80) != 0;

            value <<= 1;
            value |= carry;

            if (inst.dest != .AF or inst.nibble != .Upper) {
                new_flags.zero = (value == 0);
            }

            switch (inst.nibble) {
                .Upper => self.registers.setUpper(inst.dest, value),
                .Lower => self.registers.setLower(inst.dest, value),
            }

            self.registers.setFlags(new_flags);
            return instruction.cycles(false);
        },
        .RrR8 => |inst| {
            const flags = self.registers.getFlags();
            const carry: u8 = if (flags.carry) 0x80 else 0;

            var value = switch (inst.nibble) {
                .Upper => self.registers.getUpper(inst.dest),
                .Lower => self.registers.getLower(inst.dest),
            };

            var new_flags: Registers.Flags = .{};
            new_flags.carry = (value & 0x01) != 0;

            value >>= 1;
            value |= carry;

            if (inst.dest != .AF or inst.nibble != .Upper) {
                new_flags.zero = (value == 0);
            }

            switch (inst.nibble) {
                .Upper => self.registers.setUpper(inst.dest, value),
                .Lower => self.registers.setLower(inst.dest, value),
            }

            self.registers.setFlags(new_flags);
            return instruction.cycles(false);
        },
        .CpAImm8 => |inst| {
            const a = self.registers.getUpper(.AF);
            var flags = self.registers.getFlags();

            flags.subtract = true;
            flags.carry = (a < inst.source);
            flags.zero = (inst.source == a);
            flags.half = (inst.source & 0xF) > (a & 0xF);

            self.registers.setFlags(flags);
            return instruction.cycles(false);
        },
        .CpAR8 => |inst| {
            const a = self.registers.getUpper(.AF);
            var flags = self.registers.getFlags();
            const value = switch (inst.nibble) {
                .Upper => self.registers.getUpper(inst.source),
                .Lower => self.registers.getLower(inst.source),
            };

            flags.subtract = true;
            flags.carry = (a < value);
            flags.zero = (value == a);
            flags.half = (value & 0xF) > (a & 0xF);

            self.registers.setFlags(flags);
            return instruction.cycles(false);
        },
        .LdImm16MemA => |inst| {
            self.memory.write(inst.dest, self.registers.getUpper(.AF));
            return instruction.cycles(false);
        },
        .Di => {
            self.ime = false;
            return instruction.cycles(false);
        },
        .Ei => {
            self.ime = true;
            return instruction.cycles(false);
        },
        .OrAR8 => |inst| {
            const a = self.registers.getUpper(.AF);
            const value = switch (inst.nibble) {
                .Upper => self.registers.getUpper(inst.source),
                .Lower => self.registers.getLower(inst.source),
            };
            const result = a | value;
            self.registers.setUpper(.AF, result);

            var new_flags: Registers.Flags = .{};
            new_flags.zero = result == 0;

            return instruction.cycles(false);
        },
        .AndAImm8 => |inst| {
            const a = self.registers.getUpper(.AF);
            const result = a & inst.source;
            self.registers.setUpper(.AF, result);

            var new_flags: Registers.Flags = .{};
            new_flags.half = true;
            new_flags.zero = result == 0;
            self.registers.setFlags(new_flags);

            return instruction.cycles(false);
        },
        .AdcAImm8 => |inst| {
            const flags = self.registers.getFlags();
            const carry: u8 = if (flags.carry) 1 else 0;

            const a = self.registers.getUpper(.AF);
            const result: u16 = @as(u16, a) + @as(u16, inst.source) + @as(u16, carry);

            var new_flags: Registers.Flags = .{};
            new_flags.zero = result == 0;
            new_flags.carry = result > 0xFF;
            new_flags.half = ((a & 0x0F) + (inst.source & 0x0F) + carry) > 0x0F;

            self.registers.setUpper(.AF, @truncate(result));
            return instruction.cycles(false);
        },
        else => @panic("TODO"),
    }
}

pub fn serviceInterrupts(self: *@This()) void {
    // if interrupt master enable flag is false, no interrupt should be serviced
    if (!self.ime) return;

    const interrupt_enable = self.memory.read(INTERRUPT_ENABLE);
    const interrupt_flag = self.memory.read(INTERRUPT_FLAG);

    // some interrupt is enabled and allowed
    if ((interrupt_enable & interrupt_flag) != 0) {
        self.ime = false;
        self.memory.pushWord(&self.registers, self.registers.get(.PC));

        var pending_interrupts: Registers.InterruptFlags = @bitCast(interrupt_flag);

        // interrupts are handled in order of priority, where the LSB of the
        // flags has the highest priority, and the HSB has the lowest priority,
        // making the order:
        // - VBLANK
        // - LCD
        // - TIMER
        // - SERIAL
        // - JOYPAD
        if (pending_interrupts.v_blank) {
            self.registers.set(.PC, VBLANK_ADDRESS);
            pending_interrupts.v_blank = false;
        } else if (pending_interrupts.lcd) {
            self.registers.set(.PC, LCD_ADDRESS);
            pending_interrupts.lcd = false;
        } else if (pending_interrupts.timer) {
            self.registers.set(.PC, TIMER_ADDRESS);
            pending_interrupts.timer = false;
        } else if (pending_interrupts.serial) {
            self.registers.set(.PC, SERIAL_ADDRESS);
            pending_interrupts.serial = false;
        } else if (pending_interrupts.joypad) {
            self.registers.set(.PC, JOYPAD_ADDRESS);
            pending_interrupts.joypad = false;
        }

        self.memory.write(INTERRUPT_FLAG, @bitCast(pending_interrupts));
    }
}

pub fn handleTimer(self: *@This(), cycles: u16) void {
    self.div_clocksum += cycles;
    // DIV increments at 16384 Hz, that means it increments by one every 256 cpu
    // cycles, as the CPU runs at 4.194304 MHz
    if (self.div_clocksum >= 256) {
        self.div_clocksum -= 256;
        const div = self.memory.read(DIVIDER_REGISTER);
        self.memory.write(DIVIDER_REGISTER, div +% 1);
    }

    // The TAC register has the following structure
    // ┌───┬───┬───┬───┬───┬────────┬───────┐
    // │ 7 │ 6 │ 5 │ 4 │ 3 │    2   │  1 0  │
    // │ - │ - │ - │ - │ - │ Enable │ Clock │
    // └───┴───┴───┴───┴───┴────────┴───────┘
    const tac = self.memory.read(TIMER_CONTROL);

    // the second bit of TAC enables the timer
    if ((tac & 0x04) != 0) {
        // The clock timings are:
        // ┌──────┬───────────┬──────────────────────┐
        // │ Bits │ Frequency │ Clocks per increment │
        // │  00  │ 4096 Hz   │ 1024                 │
        // │  01  │ 262144 Hz │ 16                   │
        // │  10  │ 65536 Hz  │ 64                   │
        // │  11  │ 16384 Hz  │ 256                  │
        // └──────┴───────────┴──────────────────────┘
        const freq: u32 = switch (tac & 0x03) {
            0b00 => 4096,
            0b01 => 262144,
            0b10 => 65536,
            0b11 => 16384,
            else => unreachable,
        };

        self.timer_clocksum += cycles;
        const cycles_per_increment: u16 = @intCast(CPU_FREQUENCY / freq);
        while (self.timer_clocksum >= cycles_per_increment) {
            self.timer_clocksum -= cycles_per_increment;

            const tima = self.memory.read(TIMER_COUNTER);
            // TIMA overflows, so two things must be done:
            // - Reset TIMA to TMA
            // - Request a TIMER interrupt
            if (tima == 0xFF) {
                const tma = self.memory.read(TIMER_MODULO);
                self.memory.write(TIMER_COUNTER, tma);

                const ifs = self.memory.read(INTERRUPT_FLAG);
                var interrupt_flags: Registers.InterruptFlags = @bitCast(ifs);
                interrupt_flags.timer = true;
                self.memory.write(INTERRUPT_FLAG, @bitCast(interrupt_flags));
            } else {
                self.memory.write(TIMER_COUNTER, tima + 1);
            }
        }
    }
}

fn calculateRelativePC(self: *@This(), offset: i8) u16 {
    const pc = self.registers.get(.PC);
    const signed_pc: i32 = @intCast(pc);
    const signed_offset: i32 = @intCast(offset);
    const new_pc: u16 = @intCast(signed_pc + signed_offset);
    return new_pc;
}

pub fn loadDmgBootRom(self: *@This(), file_path: []const u8) anyerror!void {
    try self.memory.loadBootRoom(file_path, .DMG);
}

pub fn loadRom(self: *@This(), file_path: []const u8) anyerror!void {
    try self.memory.loadRom(file_path);
}
