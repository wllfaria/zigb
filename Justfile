default:
    just --list

make_op_codes:
    echo "generating op_codes.zig"
    node ./scripts/opcodes.js
