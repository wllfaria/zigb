const std = @import("std");

const Registers = @import("registers.zig");

/// Instruction set grouped by "family", as many op codes can be grouped as more
/// general families, such as "LdR16Imm16" for every different op code that
/// moves a 16-bit immediate value into a 16-bit register pair
pub const Instruction = union(enum) {
    Nop,
    /// LD r16, imm16
    LdR16Imm16: struct { dest: Registers.Register, source: u16 },
    /// LD [r16], r8
    LdR16MemR8: struct {
        dest: Registers.Register,
        increment: bool = false,
        decrement: bool = false,
        source: Registers.Register,
        source_nibble: Registers.Nibble,
    },
    /// LD a, [r16]
    LdAR16Mem: struct {
        source: Registers.Register,
        increment: bool = false,
        decrement: bool = false,
    },
    OrAR16Mem: struct { source: Registers.Register },
    /// LD [r16], SP
    LdImm16MemSP: struct { dest: u16 },
    /// INC r16
    IncR16: struct { dest: Registers.Register },
    /// DEC r16
    DecR16: struct { dest: Registers.Register },
    /// ADD HL, r16
    AddHLR16: struct { dest: Registers.Register },
    /// INC r8
    IncR8: struct { dest: Registers.Register, nibble: Registers.Nibble },
    /// DEC r8
    DecR8: struct { dest: Registers.Register, nibble: Registers.Nibble },
    /// LD r8, imm8
    LdR8Imm8: struct {
        dest: Registers.Register,
        source: u8,
        nibble: Registers.Nibble,
    },
    /// JR imm8
    JrImm8: struct { source: u8 },
    /// JR COND, imm8
    JrCondImm8: struct { source: u8, cond: Registers.Condition },
    /// LD, r8, r8
    LdR8R8: struct {
        dest: Registers.Register,
        dest_nibble: Registers.Nibble,
        source: Registers.Register,
        source_nibble: Registers.Nibble,
    },
    Halt,
    /// ADD a, r8
    AddAR8: struct { source: Registers.Register, nibble: Registers.Nibble },
    /// ADC a, r8
    AdcAR8: struct { source: Registers.Register, nibble: Registers.Nibble },
    /// SUB a, r8
    SubAR8: struct { source: Registers.Register, nibble: Registers.Nibble },
    /// SBC a, r8
    SbcAR8: struct { source: Registers.Register, nibble: Registers.Nibble },
    /// AND a, r8
    AndAR8: struct { source: Registers.Register, nibble: Registers.Nibble },
    /// XOR a, r8
    XorAR8: struct { source: Registers.Register, nibble: Registers.Nibble },
    /// OR a, r8
    OrAR8: struct { source: Registers.Register, nibble: Registers.Nibble },
    /// CP a, r8
    CpAR8: struct { source: Registers.Register, nibble: Registers.Nibble },
    /// ADD a, imm8
    AddAImm8: struct { source: u8 },
    /// ADC a, imm8
    AdcAImm8: struct { source: u8 },
    /// SUB a, imm8
    SubAImm8: struct { source: u8 },
    /// SBC a, imm8
    SbcAImm8: struct { source: u8 },
    /// AND a, imm8
    AndAImm8: struct { source: u8 },
    /// XOR a, imm8
    XorAImm8: struct { source: u8, flags: Registers.Flags },
    /// OR a, imm8
    OrAImm8: struct { source: u8 },
    /// CP a, imm8
    CpAImm8: struct { source: u8 },
    /// RET COND
    RetCond: struct { cond: Registers.Condition },
    /// RET
    Ret,
    /// RETI
    Reti,
    /// JP COND, imm16
    JpCondImm16: struct { cond: Registers.Condition, source: u16 },
    /// JP imm16
    JpImm16: struct { source: u16 },
    /// JP HL
    JpHL,
    /// CALL COND, imm16
    CallCondImm16: struct { cond: Registers.Condition, source: u16 },
    /// CALL imm16
    CallImm16: struct { source: u16 },
    /// POP r16
    PopR16: struct { dest: Registers.Register },
    /// PUSH r16
    PushR16: struct { source: Registers.Register },
    /// LDH [c], a
    LdhCMemA,
    /// LDH [imm8], a
    LdhImm8MemA: struct { dest: u8 },
    /// LD [imm16], a
    LdImm16MemA: struct { dest: u16 },
    /// LDH A, [c]
    LdhACMem,
    /// LDH A, [imm8]
    LdhAImm8Mem: struct { source: u8 },
    /// LD A, [imm16]
    LdAImm16Mem: struct { source: u16 },
    /// ADD SP, imm8
    AddSPImm8: struct { source: u8 },
    /// LD HL, SP + imm8
    LdHLSPPlusImm8: struct { source: u8 },
    /// LD SP, HL
    LdSPHL,
    /// DI
    Di,
    /// EI
    Ei,
    // CB PREFIXED INSTRUCTIONS
    //
    /// RLC r8
    RlcR8: struct { dest: Registers.Register, nibble: Registers.Nibble },
    /// RRC r8
    RrcR8: struct { dest: Registers.Register, nibble: Registers.Nibble },
    /// RL r8
    RlR8: struct { dest: Registers.Register, nibble: Registers.Nibble },
    /// RR r8
    RrR8: struct { dest: Registers.Register, nibble: Registers.Nibble },
    /// SLA r8
    SlaR8: struct { dest: Registers.Register, nibble: Registers.Nibble },
    /// SRA r8
    SraR8: struct { dest: Registers.Register, nibble: Registers.Nibble },
    /// SWAP r8
    SwapR8: struct { dest: Registers.Register, nibble: Registers.Nibble },
    /// SRL r8
    SrlR8: struct { dest: Registers.Register, nibble: Registers.Nibble },
    /// BIT b3, r8
    BitB3R8: struct { dest: Registers.Register, source: u3, nibble: Registers.Nibble },
    /// RES b3, r8
    ResB3R8: struct { dest: Registers.Register, source: u3, nibble: Registers.Nibble },
    /// SET b3, r8
    SetB3R8: struct { dest: Registers.Register, source: u3, nibble: Registers.Nibble },

    pub fn cycles(self: Instruction, condition_status: bool) u16 {
        const total_cycles: u16 = switch (self) {
            .Nop => 4,
            .LdR16Imm16 => 12,
            .LdR16MemR8 => 8,
            .LdAR16Mem => 8,
            .LdImm16MemSP => 20,
            .IncR16 => 8,
            .DecR16 => 8,
            .AddHLR16 => 8,
            .IncR8 => 4,
            .DecR8 => 4,
            .LdR8Imm8 => 8,
            .JrImm8 => 12,
            .JrCondImm8 => if (condition_status) 12 else 8,
            .LdR8R8 => 4,
            .Halt => 4,
            .AddAR8 => 4,
            .AdcAR8 => 4,
            .SubAR8 => 4,
            .SbcAR8 => 4,
            .AndAR8 => 4,
            .XorAR8 => 4,
            .OrAR8 => 4,
            .CpAR8 => 4,
            .AddAImm8 => 8,
            .AdcAImm8 => 8,
            .SubAImm8 => 8,
            .SbcAImm8 => 8,
            .AndAImm8 => 8,
            .XorAImm8 => 8,
            .OrAImm8 => 8,
            .OrAR16Mem => 8,
            .CpAImm8 => 8,
            .RetCond => if (condition_status) 20 else 8,
            .Ret => 16,
            .Reti => 16,
            .JpCondImm16 => if (condition_status) 16 else 12,
            .JpImm16 => 16,
            .JpHL => 4,
            .CallCondImm16 => if (condition_status) 24 else 12,
            .CallImm16 => 24,
            .PopR16 => 12,
            .PushR16 => 16,
            .LdhCMemA => 8,
            .LdhImm8MemA => 12,
            .LdImm16MemA => 16,
            .LdhACMem => 8,
            .LdhAImm8Mem => 12,
            .LdAImm16Mem => 16,
            .AddSPImm8 => 16,
            .LdHLSPPlusImm8 => 12,
            .LdSPHL => 8,
            .Di => 4,
            .Ei => 4,
            .RlcR8 => 8,
            .RrcR8 => 8,
            .RlR8 => 8,
            .RrR8 => 8,
            .SlaR8 => 8,
            .SraR8 => 8,
            .SwapR8 => 8,
            .SrlR8 => 8,
            .BitB3R8 => 8,
            .ResB3R8 => 8,
            .SetB3R8 => 8,
        };
        return total_cycles;
    }

    pub fn prettyPrint(self: Instruction) void {
        switch (self) {
            .Nop => std.debug.print("NOP\n", .{}),
            .LdAR16Mem => |inst| if (inst.increment) {
                std.debug.print("LD A, [HL+]\n", .{});
            } else if (inst.decrement) {
                std.debug.print("LD A, [HL-]\n", .{});
            } else {
                std.debug.print("LD A, [HL]\n", .{});
            },
            .LdImm16MemSP => |inst| std.debug.print("LD [0x{X:04}], SP\n", .{inst.dest}),
            .IncR16 => |inst| std.debug.print("INC {s}\n", .{@tagName(inst.dest)}),
            .DecR16 => |inst| std.debug.print("DEC {s}\n", .{@tagName(inst.dest)}),
            .IncR8 => |inst| std.debug.print("INC {s} {s}\n", .{ @tagName(inst.dest), @tagName(inst.nibble) }),
            .DecR8 => |inst| std.debug.print("DEC {s} {s}\n", .{ @tagName(inst.dest), @tagName(inst.nibble) }),
            .LdR8Imm8 => |inst| std.debug.print("LD {s} {s}, 0x{X:02}\n", .{ @tagName(inst.dest), @tagName(inst.nibble), inst.source }),
            .LdR16Imm16 => |inst| std.debug.print("LD {s}, 0x{X:04}\n", .{ @tagName(inst.dest), inst.source }),
            .LdR16MemR8 => |inst| if (inst.increment) {
                std.debug.print("LD [{s}+], {s} {s}\n", .{ @tagName(inst.dest), @tagName(inst.source), @tagName(inst.source_nibble) });
            } else if (inst.decrement) {
                std.debug.print("LD [{s}-], {s} {s}\n", .{ @tagName(inst.dest), @tagName(inst.source), @tagName(inst.source_nibble) });
            } else {
                std.debug.print("LD [{s}], {s} {s}\n", .{ @tagName(inst.dest), @tagName(inst.source), @tagName(inst.source_nibble) });
            },
            .AddHLR16 => |inst| std.debug.print("ADD HL, {s}\n", .{@tagName(inst.dest)}),
            .JrImm8 => |inst| std.debug.print("JR 0x{X:02}\n", .{inst.source}),
            .JrCondImm8 => |inst| std.debug.print("JR {s}, 0x{X:02}\n", .{ @tagName(inst.cond), inst.source }),
            .LdR8R8 => |inst| std.debug.print("LD {s} {s}, {s} {s}\n", .{ @tagName(inst.dest), @tagName(inst.dest_nibble), @tagName(inst.source), @tagName(inst.source_nibble) }),
            .Halt => std.debug.print("HALT\n", .{}),
            .AddAR8 => |inst| std.debug.print("ADD A, {s} {s}\n", .{ @tagName(inst.source), @tagName(inst.nibble) }),
            .AdcAR8 => |inst| std.debug.print("ADC A, {s} {s}\n", .{ @tagName(inst.source), @tagName(inst.nibble) }),
            .SubAR8 => |inst| std.debug.print("SUB A, {s} {s}\n", .{ @tagName(inst.source), @tagName(inst.nibble) }),
            .SbcAR8 => |inst| std.debug.print("SBC A, {s} {s}\n", .{ @tagName(inst.source), @tagName(inst.nibble) }),
            .AndAR8 => |inst| std.debug.print("AND A, {s} {s}\n", .{ @tagName(inst.source), @tagName(inst.nibble) }),
            .XorAR8 => |inst| std.debug.print("XOR A, {s} {s}\n", .{ @tagName(inst.source), @tagName(inst.nibble) }),
            .OrAR8 => |inst| std.debug.print("OR A, {s} {s}\n", .{ @tagName(inst.source), @tagName(inst.nibble) }),
            .CpAR8 => |inst| std.debug.print("CP A, {s} {s}\n", .{ @tagName(inst.source), @tagName(inst.nibble) }),
            .AddAImm8 => |inst| std.debug.print("ADD A, 0x{X:02}\n", .{inst.source}),
            .AdcAImm8 => |inst| std.debug.print("ADC A, 0x{X:02}\n", .{inst.source}),
            .SubAImm8 => |inst| std.debug.print("SUB A, 0x{X:02}\n", .{inst.source}),
            .SbcAImm8 => |inst| std.debug.print("SBC A, 0x{X:02}\n", .{inst.source}),
            .AndAImm8 => |inst| std.debug.print("AND A, 0x{X:02}\n", .{inst.source}),
            .XorAImm8 => |inst| std.debug.print("XOR A, 0x{X:02}\n", .{inst.source}),
            .OrAImm8 => |inst| std.debug.print("OR A, 0x{X:02}\n", .{inst.source}),
            .OrAR16Mem => |inst| std.debug.print("OR A, [{s}]", .{@tagName(inst.source)}),
            .CpAImm8 => |inst| std.debug.print("CP A, 0x{X:02}\n", .{inst.source}),
            .RetCond => |inst| std.debug.print("RET {s}\n", .{@tagName(inst.cond)}),
            .Ret => std.debug.print("RET\n", .{}),
            .Reti => std.debug.print("RETI\n", .{}),
            .JpCondImm16 => |inst| std.debug.print("JP {s}, 0x{X:04}\n", .{ @tagName(inst.cond), inst.source }),
            .JpImm16 => |inst| std.debug.print("JP 0x{X:04}\n", .{inst.source}),
            .JpHL => std.debug.print("JP HL\n", .{}),
            .CallCondImm16 => |inst| std.debug.print("CALL {s}, 0x{X:04}\n", .{ @tagName(inst.cond), inst.source }),
            .CallImm16 => |inst| std.debug.print("CALL 0x{X:04}\n", .{inst.source}),
            .PopR16 => |inst| std.debug.print("POP {s}\n", .{@tagName(inst.dest)}),
            .PushR16 => |inst| std.debug.print("PUSH {s}\n", .{@tagName(inst.source)}),
            .LdhCMemA => std.debug.print("LDH [C], A\n", .{}),
            .LdhImm8MemA => |inst| std.debug.print("LDH [0x{X:02}], A\n", .{inst.dest}),
            .LdImm16MemA => |inst| std.debug.print("LD [0x{X:04}], A\n", .{inst.dest}),
            .LdhACMem => std.debug.print("LDH A, [C]\n", .{}),
            .LdhAImm8Mem => |inst| std.debug.print("LDH A, [0x{X:02}]\n", .{inst.source}),
            .LdAImm16Mem => |inst| std.debug.print("LD A, [0x{X:04}]\n", .{inst.source}),
            .AddSPImm8 => |inst| std.debug.print("ADD SP, 0x{X:02}\n", .{inst.source}),
            .LdHLSPPlusImm8 => |inst| std.debug.print("LD HL, SP + 0x{X:02}\n", .{inst.source}),
            .LdSPHL => std.debug.print("LD SP, HL\n", .{}),
            .Di => std.debug.print("DI\n", .{}),
            .Ei => std.debug.print("EI\n", .{}),
            .RlcR8 => |inst| std.debug.print("RLC {s} {s}\n", .{ @tagName(inst.dest), @tagName(inst.nibble) }),
            .RrcR8 => |inst| std.debug.print("RRC {s} {s}\n", .{ @tagName(inst.dest), @tagName(inst.nibble) }),
            .RlR8 => |inst| std.debug.print("RL {s} {s}\n", .{ @tagName(inst.dest), @tagName(inst.nibble) }),
            .RrR8 => |inst| std.debug.print("RR {s} {s}\n", .{ @tagName(inst.dest), @tagName(inst.nibble) }),
            .SlaR8 => |inst| std.debug.print("SLA {s} {s}\n", .{ @tagName(inst.dest), @tagName(inst.nibble) }),
            .SraR8 => |inst| std.debug.print("SRA {s} {s}\n", .{ @tagName(inst.dest), @tagName(inst.nibble) }),
            .SwapR8 => |inst| std.debug.print("SWAP {s} {s}\n", .{ @tagName(inst.dest), @tagName(inst.nibble) }),
            .SrlR8 => |inst| std.debug.print("SRL {s} {s}\n", .{ @tagName(inst.dest), @tagName(inst.nibble) }),
            .ResB3R8 => |inst| std.debug.print("RES 3, {s} {s}\n", .{ @tagName(inst.dest), @tagName(inst.nibble) }),
            .BitB3R8 => |inst| std.debug.print("BIT 3, {s} {s}\n", .{ @tagName(inst.dest), @tagName(inst.nibble) }),
            .SetB3R8 => |inst| std.debug.print("SET 3, {s} {s}\n", .{ @tagName(inst.dest), @tagName(inst.nibble) }),
        }
    }
};
