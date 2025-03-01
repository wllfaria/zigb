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
    LdAR16Mem: struct { dest: Registers.Register },
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
    DecR8: struct { dest: Registers.Register },
    /// LD r8, imm8
    LdR8Imm8: struct { dest: Registers.Register, source: u8, nibble: Registers.Nibble },
    /// JR imm8
    JrImm8: struct { source: u8 },
    /// JR COND, imm8
    JrCondImm8: struct { source: u8, cond: Registers.Condition },
    /// LD, r8, r8
    LdR8R8: struct { dest: Registers.Register, source: Registers.Register },
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
    /// BIT b3, r8
    BitB3R8: struct { dest: Registers.Register, source: u3 },
    /// RES b3, r8
    ResB3R8: struct { dest: Registers.Register, source: u3 },
    /// SET b3, r8
    SetB3R8: struct { dest: Registers.Register, source: u3 },
    /// LDH [C], a
    LdhCMemA,
};
