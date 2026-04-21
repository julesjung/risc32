`define OPCODE_OP_IMM   7'b0010011
`define OPCODE_OP       7'b0110011
`define OPCODE_BRANCH   7'b1100011
`define OPCODE_JAL      7'b1101111
`define OPCODE_SYSTEM   7'b1110011

`define FUNCT3_ADDI     3'b000
`define FUNCT3_ADD      3'b000
`define FUNCT3_BEQ      3'b000
`define FUNCT3_BNE      3'b001
`define FUNCT3_PRIV     3'b000

`define FUNCT7_ADD      7'b0000000

`define FUNCT12_ECALL   12'b0000_0000_0000
`define FUNCT12_EBREAK  12'b0000_0000_0001

`define ALU_ADD         4'b0000
`define ALU_SUB         4'b0001
