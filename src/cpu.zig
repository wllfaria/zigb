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
        .JrZImm8 => return Instructions.Instruction{ .JrCondImm8 = .{
            .cond = .Zero,
            .source = self.fetch(),
        } },
        .LdCImm8 => return Instructions.Instruction{ .LdR8Imm8 = .{
            .dest = .BC,
            .source = self.fetch(),
            .nibble = .Upper,
        } },
        .JpImm16 => return Instructions.Instruction{ .JpImm16 = .{
            .source = self.fetchWord(),
        } },
        .LdEImm8 => return Instructions.Instruction{ .LdR8Imm8 = .{
            .dest = .DE,
            .source = self.fetch(),
            .nibble = .Lower,
        } },
        .LdAImm8 => return Instructions.Instruction{ .LdR8Imm8 = .{
            .dest = .AF,
            .source = self.fetch(),
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
        .LdAB => return Instructions.Instruction{ .LdR8R8 = .{
            .dest = .AF,
            .dest_nibble = .Upper,
            .source = .BC,
            .source_nibble = .Upper,
        } },
        .LdhCMemA => return Instructions.Instruction.LdhCMemA,
        .LdhAImm8Mem => return Instructions.Instruction{ .LdhAImm8Mem = .{
            .source = self.fetch(),
        } },
        .LdHLMemA => return Instructions.Instruction{ .LdR16MemA = .{
            .dest = .HL,
        } },
        .LdhImm8MemA => return Instructions.Instruction{ .LdhImm8MemA = .{
            .dest = self.fetch(),
        } },
        .LdDEImm16 => return Instructions.Instruction{ .LdR16Imm16 = .{
            .dest = .DE,
            .source = self.fetchWord(),
        } },
        .LdADEMem => return Instructions.Instruction{ .LdAR16Mem = .{
            .source = .DE,
        } },
        .CallImm16 => return Instructions.Instruction{ .CallImm16 = .{
            .source = self.fetchWord(),
        } },
        .LdAE => return Instructions.Instruction{ .LdR8R8 = .{
            .dest = .AF,
            .dest_nibble = .Upper,
            .source = .DE,
            .source_nibble = .Lower,
        } },
        .LdCA => return Instructions.Instruction{ .LdR8R8 = .{
            .dest = .BC,
            .dest_nibble = .Lower,
            .source = .AF,
            .source_nibble = .Upper,
        } },
        .LdBA => return Instructions.Instruction{ .LdR8R8 = .{
            .dest = .BC,
            .dest_nibble = .Upper,
            .source = .AF,
            .source_nibble = .Upper,
        } },
        .LdDEMemA => return Instructions.Instruction{ .LdR16MemA = .{
            .dest = .DE,
        } },
        .LdAHLMemAdd => return Instructions.Instruction{ .LdAR16Mem = .{
            .source = .HL,
            .increment = true,
        } },
        .LdHA => return Instructions.Instruction{ .LdR8R8 = .{
            .dest = .HL,
            .dest_nibble = .Upper,
            .source = .AF,
            .source_nibble = .Upper,
        } },
        .LdDA => return Instructions.Instruction{ .LdR8R8 = .{
            .dest = .DE,
            .dest_nibble = .Upper,
            .source = .AF,
            .source_nibble = .Upper,
        } },
        .LdBImm8 => return Instructions.Instruction{ .LdR8Imm8 = .{
            .dest = .BC,
            .source = self.fetch(),
            .nibble = .Upper,
        } },
        .PushBC => return Instructions.Instruction{ .PushR16 = .{
            .source = .BC,
        } },
        .PopBC => return Instructions.Instruction{ .PopR16 = .{
            .dest = .BC,
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
        .IncHL => return Instructions.Instruction{ .IncR16 = .{
            .dest = .HL,
        } },
        .IncDE => return Instructions.Instruction{ .IncR16 = .{
            .dest = .DE,
        } },
        .CpAImm8 => return Instructions.Instruction{ .CpAImm8 = .{
            .source = self.fetch(),
        } },
        .LdHLMemAddA => return Instructions.Instruction{ .LdR16MemA = .{
            .dest = .HL,
            .increment = true,
        } },
        .Di => return Instructions.Instruction.Di,
        .Ei => return Instructions.Instruction.Ei,
        .Ret => return Instructions.Instruction.Ret,
        .LdImm16MemA => return Instructions.Instruction{ .LdImm16MemA = .{
            .dest = self.fetchWord(),
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
        .XorAR8 => |inst| switch (inst.source) {
            .AF => {
                const source = self.registers.getUpper(.AF);
                const result = self.registers.getUpper(.AF) ^ source;
                self.registers.setUpper(.AF, result);
                self.registers.setFlags(inst.flags);

                return instruction.cycles(false);
            },
            else => @panic("TODO"),
        },
        .LdR16MemA => |inst| {
            const address = self.registers.get(inst.dest);
            const value = self.registers.getUpper(.AF);

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
        .Ret => {
            const address = self.memory.popWord(&self.registers);
            self.registers.set(.PC, address);
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

            if (flags.carry) {
                new_flags.carry = true;
            }

            if (value == 0) {
                new_flags.zero = true;
            }

            if ((value & 0x0F) == 0x0F) {
                new_flags.half = true;
            }

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

            if (flags.carry) {
                new_flags.carry = true;
            }

            if (value == 0) {
                new_flags.zero = true;
            }

            if ((value & 0x0F) == 0x00) {
                new_flags.half = true;
            }

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
        .RlR8 => |inst| {
            const flags = self.registers.getFlags();
            const carry: u8 = if (flags.carry) 1 else 0;

            var value = switch (inst.nibble) {
                .Upper => self.registers.getUpper(inst.dest),
                .Lower => self.registers.getLower(inst.dest),
            };

            var new_flags: Registers.Flags = .{};
            if ((value & 0x80) != 0) {
                new_flags.carry = true;
            }

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
