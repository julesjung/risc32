`define OPCODE_OP_IMM   7'b0010011
`define OPCODE_OP       7'b0110011
`define OPCODE_LUI      7'b0110111
`define OPCODE_BRANCH   7'b1100011
`define OPCODE_JAL      7'b1101111
`define OPCODE_SYSTEM   7'b1110011

`define FUNCT3_ADDI     3'b000

`define FUNCT3_ADDSUB   3'b000
`define FUNCT3_SLL      3'b001
`define FUNCT3_XOR      3'b100
`define FUNCT3_SR       3'b101
`define FUNCT3_OR       3'b110
`define FUNCT3_AND      3'b111

`define FUNCT3_BEQ      3'b000
`define FUNCT3_BNE      3'b001
`define FUNCT3_BLT      3'b100
`define FUNCT3_BGE      3'b101
`define FUNCT3_BLTU     3'b110
`define FUNCT3_BGEU     3'b111

`define FUNCT3_PRIV     3'b000

`define FUNCT7_ADD      7'b0000000
`define FUNCT7_SUB      7'b0100000
`define FUNCT7_SLL      7'b0000000
`define FUNCT7_XOR      7'b0000000
`define FUNCT7_SRL      7'b0000000
`define FUNCT7_SRA      7'b0100000
`define FUNCT7_OR       7'b0000000
`define FUNCT7_AND      7'b0000000

`define FUNCT12_ECALL   12'b0000_0000_0000
`define FUNCT12_EBREAK  12'b0000_0000_0001

`define ALU_ADD         3'b000
`define ALU_SUB         3'b001
`define ALU_SLL         3'b010
`define ALU_XOR         3'b011
`define ALU_SRL         3'b100
`define ALU_SRA         3'b101
`define ALU_OR          3'b110
`define ALU_AND         3'b111
