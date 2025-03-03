const std = @import("std");

const Registers = @import("registers.zig");

/// Instruction set grouped by "family", as many op codes can be grouped as more
/// general families, such as "LdR16Imm16" for every different op code that
/// moves a 16-bit immediate value into a 16-bit register pair
pub const Instruction = union(enum) {
    Nop,
    /// LD r16, imm16
    LdR16Imm16: struct { dest: Registers.Register, source: u16 },
    /// LD [r16], a
    LdR16MemA: struct {
        dest: Registers.Register,
        increment: bool = false,
        decrement: bool = false,
    },
    /// LD a, [r16]
    LdAR16Mem: struct {
        source: Registers.Register,
        increment: bool = false,
        decrement: bool = false,
    },
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
    AddAR8: struct { source: Registers.Register },
    /// ADC a, r8
    AdcAR8: struct { source: Registers.Register },
    /// SUB a, r8
    SubAR8: struct { source: Registers.Register },
    /// SBC a, r8
    SbcAR8: struct { source: Registers.Register },
    /// AND a, r8
    AndAR8: struct { source: Registers.Register },
    /// XOR a, r8
    XorAR8: struct { source: Registers.Register, flags: Registers.Flags },
    /// OR a, r8
    OrAR8: struct { source: Registers.Register },
    /// CP a, r8
    CpAR8: struct { source: Registers.Register },
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
    BitB3R8: struct { dest: Registers.Register, source: u3 },
    /// RES b3, r8
    ResB3R8: struct { dest: Registers.Register, source: u3 },
    /// SET b3, r8
    SetB3R8: struct { dest: Registers.Register, source: u3 },

    pub fn cycles(self: Instruction, condition_status: bool) u16 {
        const total_cycles: u16 = switch (self) {
            .Nop => 4,
            .LdR16Imm16 => 12,
            .LdR16MemA => 8,
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
};
