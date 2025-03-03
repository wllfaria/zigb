/// CPU Registers in the GameBoy
/// ┌────────┬───────┬───────┬─────────────────────┐
/// │ 16-bit │ Upper │ Lower │ Name / Function     │
/// │ AF     │   A   │   -   │ Accumulator & Flags │
/// │ BC     │   B   │   C   │ BC                  │
/// │ DE     │   D   │   E   │ DE                  │
/// │ HL     │   H   │   L   │ HL                  │
/// │ SP     │   -   │   -   │ Stack Pointer       │
/// │ PC     │   -   │   -   │ Program Counter     │
/// └────────┴───────┴───────┴─────────────────────┘
/// Some registers can be accessed as a single 16-bit register or as two
/// separate 8-bit registers.
/// [See specification](https://gbdev.io/pandocs/CPU_Registers_and_Flags.html)
pub const Register = enum(u3) {
    /// # Accumulator & Flags
    ///
    /// ## The Flags Register (lower 8 bits of AF)
    /// Contains information about the result of the most recent instruction
    /// that has affected flags
    /// ┌───────┬──────┬─────┬──────┬────────────────────────┐
    /// │ n-Bit │ Name │ Set │ Zero │ Explanation            │
    /// │   7   │ z    │  Z  │  NZ  │ Zero Flag              │
    /// │   6   │ n    │  -  │  --  │ Subtraction Flag (BCD) │
    /// │   5   │ h    │  -  │  --  │ Half Carry Flag (BCD)  │
    /// │   4   │ c    │  C  │  NC  │ Carry Flag             │
    /// │  3-0  │ -    │  -  │  --  │ Not used (always zero) │
    /// └───────┴──────┴─────┴──────┴────────────────────────┘
    AF,
    /// General Purpose Register that can be used as a pair of 8-bit registers
    /// or as a single 16-bit register
    BC,
    /// General Purpose Register that can be used as a pair of 8-bit registers
    /// or as a single 16-bit register
    DE,
    /// General Purpose Register that can be used as a pair of 8-bit registers
    /// or as a single 16-bit register
    ///
    /// This is also often used to reference memory locations in certain
    /// instructions. [see here](https://gbdev.io/pandocs/CPU_Instruction_Set.html)
    HL,
    /// Stack Pointer
    /// No separation of High and Low bits
    SP,
    /// Program Counter
    /// No separation of High and Low bits
    PC,
};

pub const InterruptFlags = packed struct {
    v_blank: bool,
    lcd: bool,
    timer: bool,
    serial: bool,
    joypad: bool,
    _pad: u3 = 0,
};

/// Packed struct to represent flags as a bit field, used by instructions to
/// specify which flags it should affect
pub const Flags = packed struct {
    // padding to ensure struct is 1 byte long, this is added as the LSB bits of
    // the struct as zig fills in as LSB to MSB
    _pad: u4 = 0,
    carry: bool = false,
    half: bool = false,
    subtract: bool = false,
    zero: bool = false,
};

/// Some instructions are condition based, this enum is simply naming them
pub const Condition = enum(u2) {
    NotZero = 0b00,
    Zero = 0b01,
    NoCarry = 0b10,
    Carry = 0b11,
};

/// Simple way for instructions to identify which pair of registers to use
pub const Nibble = enum(u1) {
    Upper,
    Lower,
};

registers: [6]u16,

pub fn init() @This() {
    return @This(){ .registers = .{0} ** 6 };
}

pub fn get(self: *@This(), register: Register) u16 {
    return self.registers[@intFromEnum(register)];
}

pub fn set(self: *@This(), register: Register, value: u16) void {
    self.registers[@intFromEnum(register)] = value;
}

pub fn getLower(self: *@This(), register: Register) u8 {
    return @truncate(self.registers[@intFromEnum(register)]);
}

pub fn getUpper(self: *@This(), register: Register) u8 {
    return @truncate(self.registers[@intFromEnum(register)] >> 8);
}

pub fn setLower(self: *@This(), register: Register, value: u8) void {
    const idx = @intFromEnum(register);
    // first clear the lower bits on the register, and then append the new value
    self.registers[idx] = (self.registers[idx] & 0xFF00) | value;
}

// TODO(wiru): i'm not sure if clearing the lower bits is necessary
pub fn getFlags(self: *@This()) Flags {
    return @bitCast(self.getLower(.AF) & 0xF0);
}

pub fn setFlags(self: *@This(), flags: Flags) void {
    self.setLower(.AF, @bitCast(flags));
}

pub fn setUpper(self: *@This(), register: Register, value: u8) void {
    const idx = @intFromEnum(register);
    // first clear the upper bits on the register, then shift the u8 as a u16 to
    // move the bits to the upper part, and then append the new value
    const new_value = (self.registers[idx] & 0x00FF) | (@as(u16, value) << 8);
    self.registers[idx] = new_value;
}

pub fn increment(self: *@This(), register: Register, amount: u16) void {
    self.set(register, self.get(register) +% amount);
}

pub fn incrementLower(self: *@This(), register: Register, amount: u8) void {
    self.setLower(register, self.getLower(register) +% amount);
}

pub fn incrementUpper(self: *@This(), register: Register, amount: u8) void {
    self.setUpper(register, self.getUpper(register) +% amount);
}

pub fn decrement(self: *@This(), register: Register, amount: u16) void {
    self.set(register, self.get(register) -% amount);
}

pub fn decrementLower(self: *@This(), register: Register, amount: u8) void {
    self.setLower(register, self.getLower(register) -% amount);
}

pub fn decrementUpper(self: *@This(), register: Register, amount: u8) void {
    self.setUpper(register, self.getUpper(register) -% amount);
}

test "should set lower bits correctly" {
    const testing = @import("std").testing;

    var r = init();
    r.set(.BC, 0xABCD);

    const initial = r.get(.BC);
    try testing.expectEqual(initial, 0xABCD);

    r.setLower(.BC, 0xFF);
    const full = r.get(.BC);
    const lower = r.getLower(.BC);
    const upper = r.getUpper(.BC);

    try testing.expectEqual(full, 0xABFF);
    try testing.expectEqual(lower, 0xFF);
    try testing.expectEqual(upper, 0xAB);
}

test "should set higher bits correctly" {
    const testing = @import("std").testing;

    var r = init();
    r.set(.BC, 0xABCD);

    const initial = r.get(.BC);
    try testing.expectEqual(initial, 0xABCD);

    r.setUpper(.BC, 0xFF);
    const full = r.get(.BC);
    const lower = r.getLower(.BC);
    const upper = r.getUpper(.BC);

    try testing.expectEqual(full, 0xFFCD);
    try testing.expectEqual(lower, 0xCD);
    try testing.expectEqual(upper, 0xFF);
}
