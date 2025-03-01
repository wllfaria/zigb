const std = @import("std");

const Memory = @import("memory.zig");
const OpCodes = @import("op_codes.zig");
const Instructions = @import("instructions.zig");
const Registers = @import("registers.zig");

registers: Registers,
memory: Memory,

pub fn init() @This() {
    return @This(){
        .registers = Registers.init(),
        .memory = Memory.init(),
    };
}

pub fn step(self: *@This()) void {
    const op_code: OpCodes.OpCode = @enumFromInt(self.fetch());
    const instruction = self.decode(op_code);

    if (instruction != null) {
        self.execute(instruction.?);
    }
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
fn decode(self: *@This(), op_code: OpCodes.OpCode) ?Instructions.Instruction {
    switch (op_code) {
        .Nop => return null,
        .XorAA => return Instructions.Instruction{ .XorAR8 = .{
            .source = .AF,
            .flags = .{ .zero = true },
        } },
        .LdSPImm16 => return Instructions.Instruction{ .LdR16Imm16 = .{
            .dest = .SP,
            .source = self.fetchWord(),
        } },
        .LdHLImm16 => return Instructions.Instruction{ .LdR16Imm16 = .{
            .dest = .HL,
            .source = self.fetchWord(),
        } },
        .LdHLMemSubA => return Instructions.Instruction{ .LdR16MemA = .{
            .dest = .HL,
            .decrement = true,
        } },
        .JrNZImm8 => return Instructions.Instruction{ .JrCondImm8 = .{
            .cond = .NotZero,
            .source = self.fetch(),
        } },
        .LdCImm8 => return Instructions.Instruction{ .LdR8Imm8 = .{
            .dest = .BC,
            .source = self.fetch(),
            .nibble = .Upper,
        } },
        .LdAImm8 => return Instructions.Instruction{ .LdR8Imm8 = .{
            .dest = .AF,
            .source = self.fetch(),
            .nibble = .Upper,
        } },
        .IncC => return Instructions.Instruction{ .IncR8 = .{
            .dest = .BC,
            .nibble = .Lower,
        } },
        .LdhCMemA => return Instructions.Instruction.LdhCMemA,
        .CbPrefix => switch (self.fetchCB()) {
            .Bit7H => return Instructions.Instruction{ .BitB3R8 = .{
                .dest = .HL,
                .source = 7,
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

fn execute(self: *@This(), instruction: Instructions.Instruction) void {
    switch (instruction) {
        .Nop => {},
        .LdR16Imm16 => |inst| self.registers.set(inst.dest, inst.source),
        .XorAR8 => |inst| switch (inst.source) {
            .AF => {
                const source = self.registers.getUpper(.AF);
                const result = self.registers.getUpper(.AF) ^ source;
                self.registers.setUpper(.AF, result);
                self.registers.setLower(.AF, @bitCast(inst.flags));
            },
            else => @panic("TODO"),
        },
        .LdR16MemA => |inst| {
            const address = self.registers.get(inst.dest);
            const value = self.registers.getUpper(.AF);

            self.memory.write(address, value);

            if (inst.increment) self.registers.increment(inst.dest, 1);
            if (inst.decrement) self.registers.decrement(inst.dest, 1);
        },
        .BitB3R8 => |inst| {
            const dest = self.registers.getUpper(inst.dest);
            var flags = self.registers.getFlags();

            if (((dest >> inst.source) & 0x01) == 0) {
                flags.zero = true;
            } else {
                flags.zero = false;
            }

            flags.negative = false;
            flags.half = false;

            self.registers.setLower(.AF, @bitCast(flags));
        },
        .JrCondImm8 => |inst| {
            const flags = self.registers.getFlags();
            const offset: i8 = @bitCast(inst.source);

            switch (inst.cond) {
                .NotZero => if (!flags.zero) {
                    const pc = self.registers.get(.PC);
                    const signed_pc: i32 = @intCast(pc);
                    const signed_offset: i32 = @intCast(offset);
                    const new_pc: u16 = @intCast(signed_pc + signed_offset);
                    self.registers.set(.PC, new_pc);
                },
                .Zero => {},
                .NoCarry => {},
                .Carry => {},
            }
        },
        .LdR8Imm8 => |inst| switch (inst.nibble) {
            .Upper => self.registers.setUpper(inst.dest, inst.source),
            .Lower => self.registers.setLower(inst.dest, inst.source),
        },
        .LdhCMemA => {
            const lower = self.registers.getLower(.BC);
            self.memory.write(0xFF00 + @as(u16, lower), self.registers.getUpper(.AF));
        },
        .IncR8 => |inst| switch (inst.nibble) {
            .Upper => self.registers.setUpper(inst.dest, self.registers.getUpper(inst.dest) + 1),
            .Lower => self.registers.setLower(inst.dest, self.registers.getLower(inst.dest) + 1),
        },
        else => @panic("TODO"),
    }
}

pub fn loadDmgBootRom(self: *@This(), file_path: []const u8) anyerror!void {
    try self.memory.loadBootRoom(file_path, .DMG);
}
