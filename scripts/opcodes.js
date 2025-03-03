import path from "path";
import fs from "fs";

/**
 * This script generates every OpCode both unprefixed and 0xCB prefixed as two
 * separate zig enums, with some specification of cycles and other useful
 * information
 **/

(async () => {
  const immediateMap = {
    n16: "imm16",
    n8: "imm8",
    a8: "imm8",
    a16: "imm16",
    e8: "imm8",
    PREFIX: "CbPrefix",
  };

  const REGULAR_OP_CODE_ENUM = [
    "/// List of Instructions OpCodes on GameBoy Specification, this was taken from",
    "/// various places, mostly from:",
    "///",
    "/// [GBDEV Pandocs](https://gbdev.io/pandocs/CPU_Instruction_Set.html)",
    "/// [GBDEV Instruction set table](https://gbdev.io/gb-opcodes/optables/)",
    "/// [GB Programmer Manual](https://archive.org/details/GameBoyProgManVer1.1/page/n114/mode/1up?view=theater&q=instruction)",
    "pub const OpCode = enum(u8) {",
  ];

  const CB_OP_CODE_ENUM = [
    "/// List of Instructions CB prefixed OpCodes on GameBoy Specification, this was",
    "/// taken from various places, mostly from:",
    "///",
    "/// [GBDEV Pandocs](https://gbdev.io/pandocs/CPU_Instruction_Set.html)",
    "/// [GBDEV Instruction set table](https://gbdev.io/gb-opcodes/optables/)",
    "/// [GB Programmer Manual](https://archive.org/details/GameBoyProgManVer1.1/page/n114/mode/1up?view=theater&q=instruction)",
    "pub const CBOpCode = enum(u8) {",
  ];

  /**
   * @param {Record<string, CodeMap>} opCodeMap
   * @param {string[]} zigEnum
   * @returns {string}
   * */
  function makeEnum(opCodeMap, zigEnum) {
    let keys = 0;

    for (const [mnemonic, codeMap] of Object.entries(opCodeMap)) {
      makeDocComment(zigEnum, codeMap);
      const key = makeEnumKey(mnemonic, codeMap);

      keys += 1;

      zigEnum.push(key);
    }

    zigEnum.push("};");

    return zigEnum.join("\n");
  }

  /**
   * @param {string[]} zigEnum
   * @param {CodeMap} codeMap
   * @returns {string}
   * */
  function makeDocComment(zigEnum, codeMap) {
    const indentation = " ".repeat(4);
    let title = `${indentation}/// ${codeMap.instruction} `;

    codeMap.operands.forEach((op, idx, arr) => {
      const mappedName = immediateMap[op.name];

      if (!op.immediate) title += "[";

      if (!!mappedName) title += capitalize(mappedName);
      else if (op.name.includes("$")) title += `${op.name.slice(1)}h`;
      else title += op.name;

      if (op.increment) title += "+";
      if (op.decrement) title += "-";

      if (!op.immediate) title += "]";

      const isLast = idx === arr.length - 1;
      if (!isLast) title += ", ";
    });

    zigEnum.push(title.trimEnd());
    zigEnum.push(`${indentation}/// Bytes: ${codeMap.bytes}`);
    zigEnum.push(`${indentation}/// Cycles: ${codeMap.cycles.join(", ")}`);

    const { Z, N, H, C } = codeMap.flags;
    zigEnum.push(`${indentation}/// Flags:`);
    zigEnum.push(`${indentation}/// Z: ${Z}, N: ${N}, H: ${H}, C: ${C}`);
  }

  /**
   * @param {string} mnemonic
   * @param {CodeMap} codeMap
   * @returns string
   * */
  function makeEnumKey(mnemonic, codeMap) {
    const indentation = " ".repeat(4);
    return `${indentation}${mnemonic} = ${codeMap.code},`;
  }

  /**
   * @param {string} str
   * @returns {string}
   * */
  function capitalize(str) {
    if (immediateMap[str]) return immediateMap[str];
    return str.charAt(0).toUpperCase() + str.toLowerCase().slice(1);
  }

  /** @param {OpCode} info */
  function makeMnemonic(info) {
    let mnemonic = capitalize(info.mnemonic);

    for (const { name, immediate, increment, decrement } of info.operands) {
      /** @type {string} */
      const mappedName = immediateMap[name];

      if (!!mappedName) mnemonic += capitalize(mappedName);
      else if (name.includes("$")) mnemonic += `${name.slice(1)}h`;
      else mnemonic += name;

      if (!immediate) mnemonic += "Mem";
      if (increment) mnemonic += "Add";
      if (decrement) mnemonic += "Sub";
    }

    return mnemonic;
  }

  const res = await fetch("https://gbdev.io/gb-opcodes/Opcodes.json");
  const json = /** @type {Res} */ (await res.json());

  /** @type {Record<string, CodeMap>} */
  const opCodeMap = {};
  /** @type {Record<string, CodeMap>} */
  const cbOpCodeMap = {};

  for (const [op, info] of Object.entries(json.unprefixed)) {
    const mnemonic = makeMnemonic(info);
    if (mnemonic.toLowerCase().includes("illegal")) continue;

    opCodeMap[mnemonic] = {
      code: op,
      instruction: info.mnemonic,
      operands: info.operands,
      cycles: info.cycles,
      flags: info.flags,
      bytes: info.bytes,
      immediate: info.immediate,
    };
  }

  for (const [op, info] of Object.entries(json.cbprefixed)) {
    const mnemonic = makeMnemonic(info);
    cbOpCodeMap[mnemonic] = {
      code: op,
      instruction: info.mnemonic,
      operands: info.operands,
      cycles: info.cycles,
      flags: info.flags,
      bytes: info.bytes,
      immediate: info.immediate,
    };
  }

  const enumStr = makeEnum(opCodeMap, REGULAR_OP_CODE_ENUM);
  const cbEnumStr = makeEnum(cbOpCodeMap, CB_OP_CODE_ENUM);

  const bothEnums = enumStr + "\n\n" + cbEnumStr;

  const dirPath = path.resolve(path.dirname(""));
  const filePath = path.join(dirPath, "src", "op_codes.zig");

  fs.writeFileSync(filePath, bothEnums);
})();

/**
 * @typedef {Object} Res
 * @property {Record<string, OpCode>} unprefixed
 * @property {Record<string, OpCode>} cbprefixed
 * */

/**
 * @typedef {Object} OpCode
 * @property {string} mnemonic
 * @property {number} bytes
 * @property {number[]} cycles
 * @property {Operand[]} operands
 * @property {boolean} immediate
 * @property {Flags} flags
 * */

/**
 * @typedef {Object} Operand
 * @property {string} name
 * @property {number?} bytes
 * @property {string} immediate
 * @property {boolean} increment
 * @property {boolean} decrement
 * */

/**
 * @typedef {Object} Flags
 * @property {string} Z
 * @property {string} N
 * @property {string} H
 * @property {string} C
 * */

/**
 * @typedef {Object} CodeMap
 * @property {string} code
 * @property {string} instruction
 * @property {Operand[]} operands
 * @property {number[]} cycles
 * @property {Flags} flags
 * @property {boolean} immediate
 * @property {number} bytes
 * */
