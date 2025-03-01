/// List of Instructions OpCodes on GameBoy Specification, this was taken from
/// various places, mostly from:
///
/// [GBDEV Pandocs](https://gbdev.io/pandocs/CPU_Instruction_Set.html)
/// [GBDEV Instruction set table](https://gbdev.io/gb-opcodes/optables/)
/// [GB Programmer Manual](https://archive.org/details/GameBoyProgManVer1.1/page/n114/mode/1up?view=theater&q=instruction)
pub const OpCode = enum(u8) {
    /// NOP
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Nop = 0x00,
    /// LD BC, Imm16
    /// Bytes: 3
    /// Cycles: 12
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdBCImm16 = 0x01,
    /// LD BC, A
    /// Bytes: 1
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdBCMemA = 0x02,
    /// INC BC
    /// Bytes: 1
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    IncBC = 0x03,
    /// INC B
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: Z, N: 0, H: H, C: -
    IncB = 0x04,
    /// DEC B
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: Z, N: 1, H: H, C: -
    DecB = 0x05,
    /// LD B, Imm8
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdBImm8 = 0x06,
    /// RLCA
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: 0, N: 0, H: 0, C: C
    Rlca = 0x07,
    /// LD Imm16, SP
    /// Bytes: 3
    /// Cycles: 20
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdImm16MemSP = 0x08,
    /// ADD HL, BC
    /// Bytes: 1
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: 0, H: H, C: C
    AddHLBC = 0x09,
    /// LD A, BC
    /// Bytes: 1
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdABCMem = 0x0A,
    /// DEC BC
    /// Bytes: 1
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    DecBC = 0x0B,
    /// INC C
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: Z, N: 0, H: H, C: -
    IncC = 0x0C,
    /// DEC C
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: Z, N: 1, H: H, C: -
    DecC = 0x0D,
    /// LD C, Imm8
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdCImm8 = 0x0E,
    /// RRCA
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: 0, N: 0, H: 0, C: C
    Rrca = 0x0F,
    /// STOP Imm8
    /// Bytes: 2
    /// Cycles: 4
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    StopImm8 = 0x10,
    /// LD DE, Imm16
    /// Bytes: 3
    /// Cycles: 12
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdDEImm16 = 0x11,
    /// LD DE, A
    /// Bytes: 1
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdDEMemA = 0x12,
    /// INC DE
    /// Bytes: 1
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    IncDE = 0x13,
    /// INC D
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: Z, N: 0, H: H, C: -
    IncD = 0x14,
    /// DEC D
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: Z, N: 1, H: H, C: -
    DecD = 0x15,
    /// LD D, Imm8
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdDImm8 = 0x16,
    /// RLA
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: 0, N: 0, H: 0, C: C
    Rla = 0x17,
    /// JR Imm8
    /// Bytes: 2
    /// Cycles: 12
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    JrImm8 = 0x18,
    /// ADD HL, DE
    /// Bytes: 1
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: 0, H: H, C: C
    AddHLDE = 0x19,
    /// LD A, DE
    /// Bytes: 1
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdADEMem = 0x1A,
    /// DEC DE
    /// Bytes: 1
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    DecDE = 0x1B,
    /// INC E
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: Z, N: 0, H: H, C: -
    IncE = 0x1C,
    /// DEC E
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: Z, N: 1, H: H, C: -
    DecE = 0x1D,
    /// LD E, Imm8
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdEImm8 = 0x1E,
    /// RRA
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: 0, N: 0, H: 0, C: C
    Rra = 0x1F,
    /// JR NZ, Imm8
    /// Bytes: 2
    /// Cycles: 12, 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    JrNZImm8 = 0x20,
    /// LD HL, Imm16
    /// Bytes: 3
    /// Cycles: 12
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdHLImm16 = 0x21,
    /// LD HL, A
    /// Bytes: 1
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdHLMemAddA = 0x22,
    /// INC HL
    /// Bytes: 1
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    IncHL = 0x23,
    /// INC H
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: Z, N: 0, H: H, C: -
    IncH = 0x24,
    /// DEC H
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: Z, N: 1, H: H, C: -
    DecH = 0x25,
    /// LD H, Imm8
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdHImm8 = 0x26,
    /// DAA
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: Z, N: -, H: 0, C: C
    Daa = 0x27,
    /// JR Z, Imm8
    /// Bytes: 2
    /// Cycles: 12, 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    JrZImm8 = 0x28,
    /// ADD HL, HL
    /// Bytes: 1
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: 0, H: H, C: C
    AddHLHL = 0x29,
    /// LD A, HL
    /// Bytes: 1
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdAHLMemAdd = 0x2A,
    /// DEC HL
    /// Bytes: 1
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    DecHL = 0x2B,
    /// INC L
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: Z, N: 0, H: H, C: -
    IncL = 0x2C,
    /// DEC L
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: Z, N: 1, H: H, C: -
    DecL = 0x2D,
    /// LD L, Imm8
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdLImm8 = 0x2E,
    /// CPL
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: -, N: 1, H: 1, C: -
    Cpl = 0x2F,
    /// JR NC, Imm8
    /// Bytes: 2
    /// Cycles: 12, 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    JrNCImm8 = 0x30,
    /// LD SP, Imm16
    /// Bytes: 3
    /// Cycles: 12
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdSPImm16 = 0x31,
    /// LD HL, A
    /// Bytes: 1
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdHLMemSubA = 0x32,
    /// INC SP
    /// Bytes: 1
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    IncSP = 0x33,
    /// INC HL
    /// Bytes: 1
    /// Cycles: 12
    /// Flags:
    /// Z: Z, N: 0, H: H, C: -
    IncHLMem = 0x34,
    /// DEC HL
    /// Bytes: 1
    /// Cycles: 12
    /// Flags:
    /// Z: Z, N: 1, H: H, C: -
    DecHLMem = 0x35,
    /// LD HL, Imm8
    /// Bytes: 2
    /// Cycles: 12
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdHLMemImm8 = 0x36,
    /// SCF
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: -, N: 0, H: 0, C: 1
    Scf = 0x37,
    /// JR C, Imm8
    /// Bytes: 2
    /// Cycles: 12, 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    JrCImm8 = 0x38,
    /// ADD HL, SP
    /// Bytes: 1
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: 0, H: H, C: C
    AddHLSP = 0x39,
    /// LD A, HL
    /// Bytes: 1
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdAHLMemSub = 0x3A,
    /// DEC SP
    /// Bytes: 1
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    DecSP = 0x3B,
    /// INC A
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: Z, N: 0, H: H, C: -
    IncA = 0x3C,
    /// DEC A
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: Z, N: 1, H: H, C: -
    DecA = 0x3D,
    /// LD A, Imm8
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdAImm8 = 0x3E,
    /// CCF
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: -, N: 0, H: 0, C: C
    Ccf = 0x3F,
    /// LD B, B
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdBB = 0x40,
    /// LD B, C
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdBC = 0x41,
    /// LD B, D
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdBD = 0x42,
    /// LD B, E
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdBE = 0x43,
    /// LD B, H
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdBH = 0x44,
    /// LD B, L
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdBL = 0x45,
    /// LD B, HL
    /// Bytes: 1
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdBHLMem = 0x46,
    /// LD B, A
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdBA = 0x47,
    /// LD C, B
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdCB = 0x48,
    /// LD C, C
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdCC = 0x49,
    /// LD C, D
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdCD = 0x4A,
    /// LD C, E
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdCE = 0x4B,
    /// LD C, H
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdCH = 0x4C,
    /// LD C, L
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdCL = 0x4D,
    /// LD C, HL
    /// Bytes: 1
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdCHLMem = 0x4E,
    /// LD C, A
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdCA = 0x4F,
    /// LD D, B
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdDB = 0x50,
    /// LD D, C
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdDC = 0x51,
    /// LD D, D
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdDD = 0x52,
    /// LD D, E
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdDE = 0x53,
    /// LD D, H
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdDH = 0x54,
    /// LD D, L
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdDL = 0x55,
    /// LD D, HL
    /// Bytes: 1
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdDHLMem = 0x56,
    /// LD D, A
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdDA = 0x57,
    /// LD E, B
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdEB = 0x58,
    /// LD E, C
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdEC = 0x59,
    /// LD E, D
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdED = 0x5A,
    /// LD E, E
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdEE = 0x5B,
    /// LD E, H
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdEH = 0x5C,
    /// LD E, L
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdEL = 0x5D,
    /// LD E, HL
    /// Bytes: 1
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdEHLMem = 0x5E,
    /// LD E, A
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdEA = 0x5F,
    /// LD H, B
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdHB = 0x60,
    /// LD H, C
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdHC = 0x61,
    /// LD H, D
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdHD = 0x62,
    /// LD H, E
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdHE = 0x63,
    /// LD H, H
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdHH = 0x64,
    /// LD H, L
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdHL = 0x65,
    /// LD H, HL
    /// Bytes: 1
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdHHLMem = 0x66,
    /// LD H, A
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdHA = 0x67,
    /// LD L, B
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdLB = 0x68,
    /// LD L, C
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdLC = 0x69,
    /// LD L, D
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdLD = 0x6A,
    /// LD L, E
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdLE = 0x6B,
    /// LD L, H
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdLH = 0x6C,
    /// LD L, L
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdLL = 0x6D,
    /// LD L, HL
    /// Bytes: 1
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdLHLMem = 0x6E,
    /// LD L, A
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdLA = 0x6F,
    /// LD HL, B
    /// Bytes: 1
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdHLMemB = 0x70,
    /// LD HL, C
    /// Bytes: 1
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdHLMemC = 0x71,
    /// LD HL, D
    /// Bytes: 1
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdHLMemD = 0x72,
    /// LD HL, E
    /// Bytes: 1
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdHLMemE = 0x73,
    /// LD HL, H
    /// Bytes: 1
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdHLMemH = 0x74,
    /// LD HL, L
    /// Bytes: 1
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdHLMemL = 0x75,
    /// HALT
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Halt = 0x76,
    /// LD HL, A
    /// Bytes: 1
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdHLMemA = 0x77,
    /// LD A, B
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdAB = 0x78,
    /// LD A, C
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdAC = 0x79,
    /// LD A, D
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdAD = 0x7A,
    /// LD A, E
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdAE = 0x7B,
    /// LD A, H
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdAH = 0x7C,
    /// LD A, L
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdAL = 0x7D,
    /// LD A, HL
    /// Bytes: 1
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdAHLMem = 0x7E,
    /// LD A, A
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdAA = 0x7F,
    /// ADD A, B
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: Z, N: 0, H: H, C: C
    AddAB = 0x80,
    /// ADD A, C
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: Z, N: 0, H: H, C: C
    AddAC = 0x81,
    /// ADD A, D
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: Z, N: 0, H: H, C: C
    AddAD = 0x82,
    /// ADD A, E
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: Z, N: 0, H: H, C: C
    AddAE = 0x83,
    /// ADD A, H
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: Z, N: 0, H: H, C: C
    AddAH = 0x84,
    /// ADD A, L
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: Z, N: 0, H: H, C: C
    AddAL = 0x85,
    /// ADD A, HL
    /// Bytes: 1
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: H, C: C
    AddAHLMem = 0x86,
    /// ADD A, A
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: Z, N: 0, H: H, C: C
    AddAA = 0x87,
    /// ADC A, B
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: Z, N: 0, H: H, C: C
    AdcAB = 0x88,
    /// ADC A, C
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: Z, N: 0, H: H, C: C
    AdcAC = 0x89,
    /// ADC A, D
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: Z, N: 0, H: H, C: C
    AdcAD = 0x8A,
    /// ADC A, E
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: Z, N: 0, H: H, C: C
    AdcAE = 0x8B,
    /// ADC A, H
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: Z, N: 0, H: H, C: C
    AdcAH = 0x8C,
    /// ADC A, L
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: Z, N: 0, H: H, C: C
    AdcAL = 0x8D,
    /// ADC A, HL
    /// Bytes: 1
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: H, C: C
    AdcAHLMem = 0x8E,
    /// ADC A, A
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: Z, N: 0, H: H, C: C
    AdcAA = 0x8F,
    /// SUB A, B
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: Z, N: 1, H: H, C: C
    SubAB = 0x90,
    /// SUB A, C
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: Z, N: 1, H: H, C: C
    SubAC = 0x91,
    /// SUB A, D
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: Z, N: 1, H: H, C: C
    SubAD = 0x92,
    /// SUB A, E
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: Z, N: 1, H: H, C: C
    SubAE = 0x93,
    /// SUB A, H
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: Z, N: 1, H: H, C: C
    SubAH = 0x94,
    /// SUB A, L
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: Z, N: 1, H: H, C: C
    SubAL = 0x95,
    /// SUB A, HL
    /// Bytes: 1
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 1, H: H, C: C
    SubAHLMem = 0x96,
    /// SUB A, A
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: 1, N: 1, H: 0, C: 0
    SubAA = 0x97,
    /// SBC A, B
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: Z, N: 1, H: H, C: C
    SbcAB = 0x98,
    /// SBC A, C
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: Z, N: 1, H: H, C: C
    SbcAC = 0x99,
    /// SBC A, D
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: Z, N: 1, H: H, C: C
    SbcAD = 0x9A,
    /// SBC A, E
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: Z, N: 1, H: H, C: C
    SbcAE = 0x9B,
    /// SBC A, H
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: Z, N: 1, H: H, C: C
    SbcAH = 0x9C,
    /// SBC A, L
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: Z, N: 1, H: H, C: C
    SbcAL = 0x9D,
    /// SBC A, HL
    /// Bytes: 1
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 1, H: H, C: C
    SbcAHLMem = 0x9E,
    /// SBC A, A
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: Z, N: 1, H: H, C: -
    SbcAA = 0x9F,
    /// AND A, B
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: Z, N: 0, H: 1, C: 0
    AndAB = 0xA0,
    /// AND A, C
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: Z, N: 0, H: 1, C: 0
    AndAC = 0xA1,
    /// AND A, D
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: Z, N: 0, H: 1, C: 0
    AndAD = 0xA2,
    /// AND A, E
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: Z, N: 0, H: 1, C: 0
    AndAE = 0xA3,
    /// AND A, H
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: Z, N: 0, H: 1, C: 0
    AndAH = 0xA4,
    /// AND A, L
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: Z, N: 0, H: 1, C: 0
    AndAL = 0xA5,
    /// AND A, HL
    /// Bytes: 1
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 1, C: 0
    AndAHLMem = 0xA6,
    /// AND A, A
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: Z, N: 0, H: 1, C: 0
    AndAA = 0xA7,
    /// XOR A, B
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: Z, N: 0, H: 0, C: 0
    XorAB = 0xA8,
    /// XOR A, C
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: Z, N: 0, H: 0, C: 0
    XorAC = 0xA9,
    /// XOR A, D
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: Z, N: 0, H: 0, C: 0
    XorAD = 0xAA,
    /// XOR A, E
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: Z, N: 0, H: 0, C: 0
    XorAE = 0xAB,
    /// XOR A, H
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: Z, N: 0, H: 0, C: 0
    XorAH = 0xAC,
    /// XOR A, L
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: Z, N: 0, H: 0, C: 0
    XorAL = 0xAD,
    /// XOR A, HL
    /// Bytes: 1
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 0, C: 0
    XorAHLMem = 0xAE,
    /// XOR A, A
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: 1, N: 0, H: 0, C: 0
    XorAA = 0xAF,
    /// OR A, B
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: Z, N: 0, H: 0, C: 0
    OrAB = 0xB0,
    /// OR A, C
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: Z, N: 0, H: 0, C: 0
    OrAC = 0xB1,
    /// OR A, D
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: Z, N: 0, H: 0, C: 0
    OrAD = 0xB2,
    /// OR A, E
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: Z, N: 0, H: 0, C: 0
    OrAE = 0xB3,
    /// OR A, H
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: Z, N: 0, H: 0, C: 0
    OrAH = 0xB4,
    /// OR A, L
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: Z, N: 0, H: 0, C: 0
    OrAL = 0xB5,
    /// OR A, HL
    /// Bytes: 1
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 0, C: 0
    OrAHLMem = 0xB6,
    /// OR A, A
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: Z, N: 0, H: 0, C: 0
    OrAA = 0xB7,
    /// CP A, B
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: Z, N: 1, H: H, C: C
    CpAB = 0xB8,
    /// CP A, C
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: Z, N: 1, H: H, C: C
    CpAC = 0xB9,
    /// CP A, D
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: Z, N: 1, H: H, C: C
    CpAD = 0xBA,
    /// CP A, E
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: Z, N: 1, H: H, C: C
    CpAE = 0xBB,
    /// CP A, H
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: Z, N: 1, H: H, C: C
    CpAH = 0xBC,
    /// CP A, L
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: Z, N: 1, H: H, C: C
    CpAL = 0xBD,
    /// CP A, HL
    /// Bytes: 1
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 1, H: H, C: C
    CpAHLMem = 0xBE,
    /// CP A, A
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: 1, N: 1, H: 0, C: 0
    CpAA = 0xBF,
    /// RET NZ
    /// Bytes: 1
    /// Cycles: 20, 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    RetNZ = 0xC0,
    /// POP BC
    /// Bytes: 1
    /// Cycles: 12
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    PopBC = 0xC1,
    /// JP NZ, Imm16
    /// Bytes: 3
    /// Cycles: 16, 12
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    JpNZImm16 = 0xC2,
    /// JP Imm16
    /// Bytes: 3
    /// Cycles: 16
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    JpImm16 = 0xC3,
    /// CALL NZ, Imm16
    /// Bytes: 3
    /// Cycles: 24, 12
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    CallNZImm16 = 0xC4,
    /// PUSH BC
    /// Bytes: 1
    /// Cycles: 16
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    PushBC = 0xC5,
    /// ADD A, Imm8
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: H, C: C
    AddAImm8 = 0xC6,
    /// RST 00h
    /// Bytes: 1
    /// Cycles: 16
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Rst00h = 0xC7,
    /// RET Z
    /// Bytes: 1
    /// Cycles: 20, 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    RetZ = 0xC8,
    /// RET
    /// Bytes: 1
    /// Cycles: 16
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Ret = 0xC9,
    /// JP Z, Imm16
    /// Bytes: 3
    /// Cycles: 16, 12
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    JpZImm16 = 0xCA,
    /// PREFIX
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    CbPrefix = 0xCB,
    /// CALL Z, Imm16
    /// Bytes: 3
    /// Cycles: 24, 12
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    CallZImm16 = 0xCC,
    /// CALL Imm16
    /// Bytes: 3
    /// Cycles: 24
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    CallImm16 = 0xCD,
    /// ADC A, Imm8
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: H, C: C
    AdcAImm8 = 0xCE,
    /// RST 08h
    /// Bytes: 1
    /// Cycles: 16
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Rst08h = 0xCF,
    /// RET NC
    /// Bytes: 1
    /// Cycles: 20, 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    RetNC = 0xD0,
    /// POP DE
    /// Bytes: 1
    /// Cycles: 12
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    PopDE = 0xD1,
    /// JP NC, Imm16
    /// Bytes: 3
    /// Cycles: 16, 12
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    JpNCImm16 = 0xD2,
    /// CALL NC, Imm16
    /// Bytes: 3
    /// Cycles: 24, 12
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    CallNCImm16 = 0xD4,
    /// PUSH DE
    /// Bytes: 1
    /// Cycles: 16
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    PushDE = 0xD5,
    /// SUB A, Imm8
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 1, H: H, C: C
    SubAImm8 = 0xD6,
    /// RST 10h
    /// Bytes: 1
    /// Cycles: 16
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Rst10h = 0xD7,
    /// RET C
    /// Bytes: 1
    /// Cycles: 20, 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    RetC = 0xD8,
    /// RETI
    /// Bytes: 1
    /// Cycles: 16
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Reti = 0xD9,
    /// JP C, Imm16
    /// Bytes: 3
    /// Cycles: 16, 12
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    JpCImm16 = 0xDA,
    /// CALL C, Imm16
    /// Bytes: 3
    /// Cycles: 24, 12
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    CallCImm16 = 0xDC,
    /// SBC A, Imm8
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 1, H: H, C: C
    SbcAImm8 = 0xDE,
    /// RST 18h
    /// Bytes: 1
    /// Cycles: 16
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Rst18h = 0xDF,
    /// LDH Imm8, A
    /// Bytes: 2
    /// Cycles: 12
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdhImm8MemA = 0xE0,
    /// POP HL
    /// Bytes: 1
    /// Cycles: 12
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    PopHL = 0xE1,
    /// LDH C, A
    /// Bytes: 1
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdhCMemA = 0xE2,
    /// PUSH HL
    /// Bytes: 1
    /// Cycles: 16
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    PushHL = 0xE5,
    /// AND A, Imm8
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 1, C: 0
    AndAImm8 = 0xE6,
    /// RST 20h
    /// Bytes: 1
    /// Cycles: 16
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Rst20h = 0xE7,
    /// ADD SP, Imm8
    /// Bytes: 2
    /// Cycles: 16
    /// Flags:
    /// Z: 0, N: 0, H: H, C: C
    AddSPImm8 = 0xE8,
    /// JP HL
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    JpHL = 0xE9,
    /// LD Imm16, A
    /// Bytes: 3
    /// Cycles: 16
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdImm16MemA = 0xEA,
    /// XOR A, Imm8
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 0, C: 0
    XorAImm8 = 0xEE,
    /// RST 28h
    /// Bytes: 1
    /// Cycles: 16
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Rst28h = 0xEF,
    /// LDH A, Imm8
    /// Bytes: 2
    /// Cycles: 12
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdhAImm8Mem = 0xF0,
    /// POP AF
    /// Bytes: 1
    /// Cycles: 12
    /// Flags:
    /// Z: Z, N: N, H: H, C: C
    PopAF = 0xF1,
    /// LDH A, C
    /// Bytes: 1
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdhACMem = 0xF2,
    /// DI
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Di = 0xF3,
    /// PUSH AF
    /// Bytes: 1
    /// Cycles: 16
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    PushAF = 0xF5,
    /// OR A, Imm8
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 0, C: 0
    OrAImm8 = 0xF6,
    /// RST 30h
    /// Bytes: 1
    /// Cycles: 16
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Rst30h = 0xF7,
    /// LD HL, SP, Imm8
    /// Bytes: 2
    /// Cycles: 12
    /// Flags:
    /// Z: 0, N: 0, H: H, C: C
    LdHLSPAddImm8 = 0xF8,
    /// LD SP, HL
    /// Bytes: 1
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdSPHL = 0xF9,
    /// LD A, Imm16
    /// Bytes: 3
    /// Cycles: 16
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    LdAImm16Mem = 0xFA,
    /// EI
    /// Bytes: 1
    /// Cycles: 4
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Ei = 0xFB,
    /// CP A, Imm8
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 1, H: H, C: C
    CpAImm8 = 0xFE,
    /// RST 38h
    /// Bytes: 1
    /// Cycles: 16
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Rst38h = 0xFF,
};

/// List of Instructions CB prefixed OpCodes on GameBoy Specification, this was
/// taken from various places, mostly from:
///
/// [GBDEV Pandocs](https://gbdev.io/pandocs/CPU_Instruction_Set.html)
/// [GBDEV Instruction set table](https://gbdev.io/gb-opcodes/optables/)
/// [GB Programmer Manual](https://archive.org/details/GameBoyProgManVer1.1/page/n114/mode/1up?view=theater&q=instruction)
pub const CBOpCode = enum(u8) {
    /// RLC B
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 0, C: C
    RlcB = 0x00,
    /// RLC C
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 0, C: C
    RlcC = 0x01,
    /// RLC D
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 0, C: C
    RlcD = 0x02,
    /// RLC E
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 0, C: C
    RlcE = 0x03,
    /// RLC H
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 0, C: C
    RlcH = 0x04,
    /// RLC L
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 0, C: C
    RlcL = 0x05,
    /// RLC HL
    /// Bytes: 2
    /// Cycles: 16
    /// Flags:
    /// Z: Z, N: 0, H: 0, C: C
    RlcHLMem = 0x06,
    /// RLC A
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 0, C: C
    RlcA = 0x07,
    /// RRC B
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 0, C: C
    RrcB = 0x08,
    /// RRC C
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 0, C: C
    RrcC = 0x09,
    /// RRC D
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 0, C: C
    RrcD = 0x0A,
    /// RRC E
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 0, C: C
    RrcE = 0x0B,
    /// RRC H
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 0, C: C
    RrcH = 0x0C,
    /// RRC L
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 0, C: C
    RrcL = 0x0D,
    /// RRC HL
    /// Bytes: 2
    /// Cycles: 16
    /// Flags:
    /// Z: Z, N: 0, H: 0, C: C
    RrcHLMem = 0x0E,
    /// RRC A
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 0, C: C
    RrcA = 0x0F,
    /// RL B
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 0, C: C
    RlB = 0x10,
    /// RL C
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 0, C: C
    RlC = 0x11,
    /// RL D
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 0, C: C
    RlD = 0x12,
    /// RL E
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 0, C: C
    RlE = 0x13,
    /// RL H
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 0, C: C
    RlH = 0x14,
    /// RL L
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 0, C: C
    RlL = 0x15,
    /// RL HL
    /// Bytes: 2
    /// Cycles: 16
    /// Flags:
    /// Z: Z, N: 0, H: 0, C: C
    RlHLMem = 0x16,
    /// RL A
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 0, C: C
    RlA = 0x17,
    /// RR B
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 0, C: C
    RrB = 0x18,
    /// RR C
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 0, C: C
    RrC = 0x19,
    /// RR D
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 0, C: C
    RrD = 0x1A,
    /// RR E
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 0, C: C
    RrE = 0x1B,
    /// RR H
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 0, C: C
    RrH = 0x1C,
    /// RR L
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 0, C: C
    RrL = 0x1D,
    /// RR HL
    /// Bytes: 2
    /// Cycles: 16
    /// Flags:
    /// Z: Z, N: 0, H: 0, C: C
    RrHLMem = 0x1E,
    /// RR A
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 0, C: C
    RrA = 0x1F,
    /// SLA B
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 0, C: C
    SlaB = 0x20,
    /// SLA C
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 0, C: C
    SlaC = 0x21,
    /// SLA D
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 0, C: C
    SlaD = 0x22,
    /// SLA E
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 0, C: C
    SlaE = 0x23,
    /// SLA H
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 0, C: C
    SlaH = 0x24,
    /// SLA L
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 0, C: C
    SlaL = 0x25,
    /// SLA HL
    /// Bytes: 2
    /// Cycles: 16
    /// Flags:
    /// Z: Z, N: 0, H: 0, C: C
    SlaHLMem = 0x26,
    /// SLA A
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 0, C: C
    SlaA = 0x27,
    /// SRA B
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 0, C: C
    SraB = 0x28,
    /// SRA C
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 0, C: C
    SraC = 0x29,
    /// SRA D
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 0, C: C
    SraD = 0x2A,
    /// SRA E
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 0, C: C
    SraE = 0x2B,
    /// SRA H
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 0, C: C
    SraH = 0x2C,
    /// SRA L
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 0, C: C
    SraL = 0x2D,
    /// SRA HL
    /// Bytes: 2
    /// Cycles: 16
    /// Flags:
    /// Z: Z, N: 0, H: 0, C: C
    SraHLMem = 0x2E,
    /// SRA A
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 0, C: C
    SraA = 0x2F,
    /// SWAP B
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 0, C: 0
    SwapB = 0x30,
    /// SWAP C
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 0, C: 0
    SwapC = 0x31,
    /// SWAP D
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 0, C: 0
    SwapD = 0x32,
    /// SWAP E
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 0, C: 0
    SwapE = 0x33,
    /// SWAP H
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 0, C: 0
    SwapH = 0x34,
    /// SWAP L
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 0, C: 0
    SwapL = 0x35,
    /// SWAP HL
    /// Bytes: 2
    /// Cycles: 16
    /// Flags:
    /// Z: Z, N: 0, H: 0, C: 0
    SwapHLMem = 0x36,
    /// SWAP A
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 0, C: 0
    SwapA = 0x37,
    /// SRL B
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 0, C: C
    SrlB = 0x38,
    /// SRL C
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 0, C: C
    SrlC = 0x39,
    /// SRL D
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 0, C: C
    SrlD = 0x3A,
    /// SRL E
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 0, C: C
    SrlE = 0x3B,
    /// SRL H
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 0, C: C
    SrlH = 0x3C,
    /// SRL L
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 0, C: C
    SrlL = 0x3D,
    /// SRL HL
    /// Bytes: 2
    /// Cycles: 16
    /// Flags:
    /// Z: Z, N: 0, H: 0, C: C
    SrlHLMem = 0x3E,
    /// SRL A
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 0, C: C
    SrlA = 0x3F,
    /// BIT 0, B
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 1, C: -
    Bit0B = 0x40,
    /// BIT 0, C
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 1, C: -
    Bit0C = 0x41,
    /// BIT 0, D
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 1, C: -
    Bit0D = 0x42,
    /// BIT 0, E
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 1, C: -
    Bit0E = 0x43,
    /// BIT 0, H
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 1, C: -
    Bit0H = 0x44,
    /// BIT 0, L
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 1, C: -
    Bit0L = 0x45,
    /// BIT 0, HL
    /// Bytes: 2
    /// Cycles: 12
    /// Flags:
    /// Z: Z, N: 0, H: 1, C: -
    Bit0HLMem = 0x46,
    /// BIT 0, A
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 1, C: -
    Bit0A = 0x47,
    /// BIT 1, B
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 1, C: -
    Bit1B = 0x48,
    /// BIT 1, C
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 1, C: -
    Bit1C = 0x49,
    /// BIT 1, D
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 1, C: -
    Bit1D = 0x4A,
    /// BIT 1, E
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 1, C: -
    Bit1E = 0x4B,
    /// BIT 1, H
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 1, C: -
    Bit1H = 0x4C,
    /// BIT 1, L
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 1, C: -
    Bit1L = 0x4D,
    /// BIT 1, HL
    /// Bytes: 2
    /// Cycles: 12
    /// Flags:
    /// Z: Z, N: 0, H: 1, C: -
    Bit1HLMem = 0x4E,
    /// BIT 1, A
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 1, C: -
    Bit1A = 0x4F,
    /// BIT 2, B
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 1, C: -
    Bit2B = 0x50,
    /// BIT 2, C
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 1, C: -
    Bit2C = 0x51,
    /// BIT 2, D
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 1, C: -
    Bit2D = 0x52,
    /// BIT 2, E
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 1, C: -
    Bit2E = 0x53,
    /// BIT 2, H
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 1, C: -
    Bit2H = 0x54,
    /// BIT 2, L
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 1, C: -
    Bit2L = 0x55,
    /// BIT 2, HL
    /// Bytes: 2
    /// Cycles: 12
    /// Flags:
    /// Z: Z, N: 0, H: 1, C: -
    Bit2HLMem = 0x56,
    /// BIT 2, A
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 1, C: -
    Bit2A = 0x57,
    /// BIT 3, B
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 1, C: -
    Bit3B = 0x58,
    /// BIT 3, C
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 1, C: -
    Bit3C = 0x59,
    /// BIT 3, D
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 1, C: -
    Bit3D = 0x5A,
    /// BIT 3, E
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 1, C: -
    Bit3E = 0x5B,
    /// BIT 3, H
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 1, C: -
    Bit3H = 0x5C,
    /// BIT 3, L
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 1, C: -
    Bit3L = 0x5D,
    /// BIT 3, HL
    /// Bytes: 2
    /// Cycles: 12
    /// Flags:
    /// Z: Z, N: 0, H: 1, C: -
    Bit3HLMem = 0x5E,
    /// BIT 3, A
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 1, C: -
    Bit3A = 0x5F,
    /// BIT 4, B
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 1, C: -
    Bit4B = 0x60,
    /// BIT 4, C
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 1, C: -
    Bit4C = 0x61,
    /// BIT 4, D
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 1, C: -
    Bit4D = 0x62,
    /// BIT 4, E
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 1, C: -
    Bit4E = 0x63,
    /// BIT 4, H
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 1, C: -
    Bit4H = 0x64,
    /// BIT 4, L
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 1, C: -
    Bit4L = 0x65,
    /// BIT 4, HL
    /// Bytes: 2
    /// Cycles: 12
    /// Flags:
    /// Z: Z, N: 0, H: 1, C: -
    Bit4HLMem = 0x66,
    /// BIT 4, A
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 1, C: -
    Bit4A = 0x67,
    /// BIT 5, B
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 1, C: -
    Bit5B = 0x68,
    /// BIT 5, C
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 1, C: -
    Bit5C = 0x69,
    /// BIT 5, D
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 1, C: -
    Bit5D = 0x6A,
    /// BIT 5, E
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 1, C: -
    Bit5E = 0x6B,
    /// BIT 5, H
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 1, C: -
    Bit5H = 0x6C,
    /// BIT 5, L
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 1, C: -
    Bit5L = 0x6D,
    /// BIT 5, HL
    /// Bytes: 2
    /// Cycles: 12
    /// Flags:
    /// Z: Z, N: 0, H: 1, C: -
    Bit5HLMem = 0x6E,
    /// BIT 5, A
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 1, C: -
    Bit5A = 0x6F,
    /// BIT 6, B
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 1, C: -
    Bit6B = 0x70,
    /// BIT 6, C
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 1, C: -
    Bit6C = 0x71,
    /// BIT 6, D
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 1, C: -
    Bit6D = 0x72,
    /// BIT 6, E
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 1, C: -
    Bit6E = 0x73,
    /// BIT 6, H
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 1, C: -
    Bit6H = 0x74,
    /// BIT 6, L
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 1, C: -
    Bit6L = 0x75,
    /// BIT 6, HL
    /// Bytes: 2
    /// Cycles: 12
    /// Flags:
    /// Z: Z, N: 0, H: 1, C: -
    Bit6HLMem = 0x76,
    /// BIT 6, A
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 1, C: -
    Bit6A = 0x77,
    /// BIT 7, B
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 1, C: -
    Bit7B = 0x78,
    /// BIT 7, C
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 1, C: -
    Bit7C = 0x79,
    /// BIT 7, D
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 1, C: -
    Bit7D = 0x7A,
    /// BIT 7, E
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 1, C: -
    Bit7E = 0x7B,
    /// BIT 7, H
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 1, C: -
    Bit7H = 0x7C,
    /// BIT 7, L
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 1, C: -
    Bit7L = 0x7D,
    /// BIT 7, HL
    /// Bytes: 2
    /// Cycles: 12
    /// Flags:
    /// Z: Z, N: 0, H: 1, C: -
    Bit7HLMem = 0x7E,
    /// BIT 7, A
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: Z, N: 0, H: 1, C: -
    Bit7A = 0x7F,
    /// RES 0, B
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Res0B = 0x80,
    /// RES 0, C
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Res0C = 0x81,
    /// RES 0, D
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Res0D = 0x82,
    /// RES 0, E
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Res0E = 0x83,
    /// RES 0, H
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Res0H = 0x84,
    /// RES 0, L
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Res0L = 0x85,
    /// RES 0, HL
    /// Bytes: 2
    /// Cycles: 16
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Res0HLMem = 0x86,
    /// RES 0, A
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Res0A = 0x87,
    /// RES 1, B
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Res1B = 0x88,
    /// RES 1, C
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Res1C = 0x89,
    /// RES 1, D
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Res1D = 0x8A,
    /// RES 1, E
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Res1E = 0x8B,
    /// RES 1, H
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Res1H = 0x8C,
    /// RES 1, L
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Res1L = 0x8D,
    /// RES 1, HL
    /// Bytes: 2
    /// Cycles: 16
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Res1HLMem = 0x8E,
    /// RES 1, A
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Res1A = 0x8F,
    /// RES 2, B
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Res2B = 0x90,
    /// RES 2, C
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Res2C = 0x91,
    /// RES 2, D
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Res2D = 0x92,
    /// RES 2, E
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Res2E = 0x93,
    /// RES 2, H
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Res2H = 0x94,
    /// RES 2, L
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Res2L = 0x95,
    /// RES 2, HL
    /// Bytes: 2
    /// Cycles: 16
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Res2HLMem = 0x96,
    /// RES 2, A
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Res2A = 0x97,
    /// RES 3, B
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Res3B = 0x98,
    /// RES 3, C
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Res3C = 0x99,
    /// RES 3, D
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Res3D = 0x9A,
    /// RES 3, E
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Res3E = 0x9B,
    /// RES 3, H
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Res3H = 0x9C,
    /// RES 3, L
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Res3L = 0x9D,
    /// RES 3, HL
    /// Bytes: 2
    /// Cycles: 16
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Res3HLMem = 0x9E,
    /// RES 3, A
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Res3A = 0x9F,
    /// RES 4, B
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Res4B = 0xA0,
    /// RES 4, C
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Res4C = 0xA1,
    /// RES 4, D
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Res4D = 0xA2,
    /// RES 4, E
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Res4E = 0xA3,
    /// RES 4, H
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Res4H = 0xA4,
    /// RES 4, L
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Res4L = 0xA5,
    /// RES 4, HL
    /// Bytes: 2
    /// Cycles: 16
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Res4HLMem = 0xA6,
    /// RES 4, A
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Res4A = 0xA7,
    /// RES 5, B
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Res5B = 0xA8,
    /// RES 5, C
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Res5C = 0xA9,
    /// RES 5, D
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Res5D = 0xAA,
    /// RES 5, E
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Res5E = 0xAB,
    /// RES 5, H
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Res5H = 0xAC,
    /// RES 5, L
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Res5L = 0xAD,
    /// RES 5, HL
    /// Bytes: 2
    /// Cycles: 16
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Res5HLMem = 0xAE,
    /// RES 5, A
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Res5A = 0xAF,
    /// RES 6, B
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Res6B = 0xB0,
    /// RES 6, C
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Res6C = 0xB1,
    /// RES 6, D
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Res6D = 0xB2,
    /// RES 6, E
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Res6E = 0xB3,
    /// RES 6, H
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Res6H = 0xB4,
    /// RES 6, L
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Res6L = 0xB5,
    /// RES 6, HL
    /// Bytes: 2
    /// Cycles: 16
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Res6HLMem = 0xB6,
    /// RES 6, A
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Res6A = 0xB7,
    /// RES 7, B
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Res7B = 0xB8,
    /// RES 7, C
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Res7C = 0xB9,
    /// RES 7, D
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Res7D = 0xBA,
    /// RES 7, E
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Res7E = 0xBB,
    /// RES 7, H
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Res7H = 0xBC,
    /// RES 7, L
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Res7L = 0xBD,
    /// RES 7, HL
    /// Bytes: 2
    /// Cycles: 16
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Res7HLMem = 0xBE,
    /// RES 7, A
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Res7A = 0xBF,
    /// SET 0, B
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Set0B = 0xC0,
    /// SET 0, C
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Set0C = 0xC1,
    /// SET 0, D
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Set0D = 0xC2,
    /// SET 0, E
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Set0E = 0xC3,
    /// SET 0, H
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Set0H = 0xC4,
    /// SET 0, L
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Set0L = 0xC5,
    /// SET 0, HL
    /// Bytes: 2
    /// Cycles: 16
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Set0HLMem = 0xC6,
    /// SET 0, A
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Set0A = 0xC7,
    /// SET 1, B
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Set1B = 0xC8,
    /// SET 1, C
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Set1C = 0xC9,
    /// SET 1, D
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Set1D = 0xCA,
    /// SET 1, E
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Set1E = 0xCB,
    /// SET 1, H
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Set1H = 0xCC,
    /// SET 1, L
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Set1L = 0xCD,
    /// SET 1, HL
    /// Bytes: 2
    /// Cycles: 16
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Set1HLMem = 0xCE,
    /// SET 1, A
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Set1A = 0xCF,
    /// SET 2, B
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Set2B = 0xD0,
    /// SET 2, C
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Set2C = 0xD1,
    /// SET 2, D
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Set2D = 0xD2,
    /// SET 2, E
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Set2E = 0xD3,
    /// SET 2, H
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Set2H = 0xD4,
    /// SET 2, L
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Set2L = 0xD5,
    /// SET 2, HL
    /// Bytes: 2
    /// Cycles: 16
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Set2HLMem = 0xD6,
    /// SET 2, A
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Set2A = 0xD7,
    /// SET 3, B
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Set3B = 0xD8,
    /// SET 3, C
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Set3C = 0xD9,
    /// SET 3, D
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Set3D = 0xDA,
    /// SET 3, E
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Set3E = 0xDB,
    /// SET 3, H
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Set3H = 0xDC,
    /// SET 3, L
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Set3L = 0xDD,
    /// SET 3, HL
    /// Bytes: 2
    /// Cycles: 16
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Set3HLMem = 0xDE,
    /// SET 3, A
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Set3A = 0xDF,
    /// SET 4, B
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Set4B = 0xE0,
    /// SET 4, C
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Set4C = 0xE1,
    /// SET 4, D
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Set4D = 0xE2,
    /// SET 4, E
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Set4E = 0xE3,
    /// SET 4, H
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Set4H = 0xE4,
    /// SET 4, L
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Set4L = 0xE5,
    /// SET 4, HL
    /// Bytes: 2
    /// Cycles: 16
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Set4HLMem = 0xE6,
    /// SET 4, A
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Set4A = 0xE7,
    /// SET 5, B
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Set5B = 0xE8,
    /// SET 5, C
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Set5C = 0xE9,
    /// SET 5, D
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Set5D = 0xEA,
    /// SET 5, E
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Set5E = 0xEB,
    /// SET 5, H
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Set5H = 0xEC,
    /// SET 5, L
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Set5L = 0xED,
    /// SET 5, HL
    /// Bytes: 2
    /// Cycles: 16
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Set5HLMem = 0xEE,
    /// SET 5, A
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Set5A = 0xEF,
    /// SET 6, B
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Set6B = 0xF0,
    /// SET 6, C
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Set6C = 0xF1,
    /// SET 6, D
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Set6D = 0xF2,
    /// SET 6, E
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Set6E = 0xF3,
    /// SET 6, H
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Set6H = 0xF4,
    /// SET 6, L
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Set6L = 0xF5,
    /// SET 6, HL
    /// Bytes: 2
    /// Cycles: 16
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Set6HLMem = 0xF6,
    /// SET 6, A
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Set6A = 0xF7,
    /// SET 7, B
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Set7B = 0xF8,
    /// SET 7, C
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Set7C = 0xF9,
    /// SET 7, D
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Set7D = 0xFA,
    /// SET 7, E
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Set7E = 0xFB,
    /// SET 7, H
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Set7H = 0xFC,
    /// SET 7, L
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Set7L = 0xFD,
    /// SET 7, HL
    /// Bytes: 2
    /// Cycles: 16
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Set7HLMem = 0xFE,
    /// SET 7, A
    /// Bytes: 2
    /// Cycles: 8
    /// Flags:
    /// Z: -, N: -, H: -, C: -
    Set7A = 0xFF,
};
