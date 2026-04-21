`include "hdl/opcodes.v";

module control(
    input [31:0] instruction,
    input [1:0] state,
    output reg ebreak,
    output reg reg_write_enable,
    output reg [4:0] reg_waddr,
    output reg [4:0] reg_raddr1,
    output reg [4:0] reg_raddr2,
    output reg [3:0] alu_op,
    output reg alu_imm_enable,
    output reg [31:0] alu_imm,
    output reg jump_enable,
    output reg signed [31:0] jump_offset,
    output reg branch_enable,
    output reg [2:0] branch_type,
    output reg signed [31:0] branch_offset
);

wire [6:0] opcode = instruction[6:0];
wire [4:0] rd = instruction[11:7];
wire [4:0] rs1 = instruction[19:15];
wire [4:0] rs2 = instruction[24:20];
wire [11:0] imm12 = instruction[31:20];
wire [19:0] imm20j = {
    instruction[31],
    instruction[19:12],
    instruction[20],
    instruction[30:21]
};
wire [11:0] imm12b = {
    instruction[31],
    instruction[7],
    instruction[30:25],
    instruction[11:8]
};
wire [2:0] funct3 = instruction[14:12];
wire [6:0] funct7 = instruction[31:25];
wire [11:0] funct12 = instruction[31:20];

always @(*) begin
    ebreak = 0;
    reg_write_enable = 0;
    reg_waddr = 0;
    reg_raddr1 = 0;
    reg_raddr2 = 0;
    alu_imm_enable = 0;
    alu_imm = 0;
    alu_op = 0;
    jump_enable = 0;
    jump_offset = 0;
    branch_enable = 0;
    branch_type = 0;
    branch_offset = 0;

    if (state == 2) case (opcode)
        `OPCODE_BRANCH: begin
            reg_raddr1 = rs1;
            reg_raddr2 = rs2;
            alu_op = `ALU_SUB;
            branch_enable = 1;
            branch_type = funct3;
            branch_offset = {
                {19{imm12b[11]}},
                imm12b,
                1'b0
            };
        end
        `OPCODE_JAL: begin
            jump_enable = 1;
            jump_offset = {
                {11{imm20j[19]}},
                imm20j,
                1'b0
            };
        end
        `OPCODE_OP_IMM: begin
            reg_waddr = rd;
            reg_raddr1 = rs1;
            reg_write_enable = 1;
            alu_imm_enable = 1;
            alu_imm = {{20{imm12[11]}}, imm12};
            case (funct3)
                `FUNCT3_ADDI: begin
                    alu_op = `ALU_ADD;
                end
                default: begin end
            endcase
        end
        `OPCODE_OP: begin
            reg_waddr = rd;
            reg_raddr1 = rs1;
            reg_raddr2 = rs2;
            reg_write_enable = 1;
            case (funct3)
                `FUNCT3_ADD: begin
                    case (funct7)
                        `FUNCT7_ADD: alu_op = `ALU_ADD;
                        default: begin end
                    endcase
                end
                default: begin end
            endcase
        end
        `OPCODE_SYSTEM: if (funct3 == `FUNCT3_PRIV && funct12 == `FUNCT12_EBREAK) ebreak = 1;
        default: begin end
    endcase
end

endmodule
