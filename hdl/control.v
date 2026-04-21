`include "hdl/opcodes.v";

module control(
    input [31:0] instruction,
    input [1:0] state,
    output reg ebreak,
    output reg reg_write_enable,
    output reg [4:0] reg_write_addr,
    output reg [4:0] reg_read_addr1,
    output reg [4:0] reg_read_addr2,
    output reg [3:0] alu_opcode,
    output reg alu_write_enable,
    output reg alu_immediate_enable,
    output reg [31:0] immediate,
    output reg jump_enable,
    output reg branch_enable,
    output reg [2:0] branch_type,
    output reg signed [31:0] address_offset
);

wire [6:0] opcode = instruction[6:0];
wire [4:0] rd = instruction[11:7];
wire [4:0] rs1 = instruction[19:15];
wire [4:0] rs2 = instruction[24:20];
wire [11:0] imm12i = instruction[31:20];
wire [11:0] imm12b = {
    instruction[31],
    instruction[7],
    instruction[30:25],
    instruction[11:8]
};
wire [19:0] imm20u = instruction[31:12];
wire [19:0] imm20j = {
    instruction[31],
    instruction[19:12],
    instruction[20],
    instruction[30:21]
};
wire [2:0] funct3 = instruction[14:12];
wire [6:0] funct7 = instruction[31:25];
wire [11:0] funct12 = instruction[31:20];

always @(*) begin
    ebreak = 0;
    reg_write_enable = 0;
    reg_write_addr = 0;
    reg_read_addr1 = 0;
    reg_read_addr2 = 0;
    alu_opcode = 0;
    alu_write_enable = 0;
    alu_immediate_enable = 0;
    immediate = 0;
    jump_enable = 0;
    branch_enable = 0;
    branch_type = 0;
    address_offset = 0;

    if (state == 2) case (opcode)
        `OPCODE_OP_IMM: begin
            reg_write_enable = 1;
            reg_write_addr = rd;
            reg_read_addr1 = rs1;
            case (funct3)
                `FUNCT3_ADDI: begin
                    alu_opcode = `ALU_ADD;
                end
                default: begin end
            endcase
            alu_write_enable = 1;
            alu_immediate_enable = 1;
            immediate = { {20{imm12i[11]}}, imm12i };
        end
        `OPCODE_OP: begin
            reg_write_enable = 1;
            reg_write_addr = rd;
            reg_read_addr1 = rs1;
            reg_read_addr2 = rs2;
            case (funct3)
                `FUNCT3_ADD: begin
                    case (funct7)
                        `FUNCT7_ADD: alu_opcode = `ALU_ADD;
                        default: begin end
                    endcase
                end
                default: begin end
            endcase
            alu_write_enable = 1;
        end
        `OPCODE_LUI: begin
            reg_write_enable = 1;
            reg_write_addr = rd;
            immediate = { imm20u, 12'b0 };
        end
        `OPCODE_BRANCH: begin
            reg_read_addr1 = rs1;
            reg_read_addr2 = rs2;
            alu_opcode = `ALU_SUB;
            branch_enable = 1;
            branch_type = funct3;
            address_offset = {
                {19{imm12b[11]}},
                imm12b,
                1'b0
            };
        end
        `OPCODE_JAL: begin
            jump_enable = 1;
            address_offset = {
                {11{imm20j[19]}},
                imm20j,
                1'b0
            };
        end
        `OPCODE_SYSTEM: if (funct3 == `FUNCT3_PRIV && funct12 == `FUNCT12_EBREAK) ebreak = 1;
        default: begin end
    endcase
end

endmodule
