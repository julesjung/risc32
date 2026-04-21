`include "hdl/opcodes.v"

module datapath(
    input clk,
    input [1:0] state,
    input ebreak,
    input reg_write_enable,
    input [4:0] reg_waddr,
    input [4:0] reg_raddr1,
    input [4:0] reg_raddr2,
    input [3:0] alu_op,
    input alu_imm_enable,
    input [31:0] alu_imm,
    input jump_enable,
    input signed [31:0] jump_offset,
    input branch_enable,
    input [2:0] branch_type,
    input signed [31:0] branch_offset,
    output reg [31:0] instruction
);

reg [31:0] pc;

reg [31:0] memory_raddr;
wire [31:0] memory_rdata;

memory mem(
    .clk(clk),
    .raddr(memory_raddr),
    .rdata(memory_rdata)
);

wire [31:0] reg_wdata = alu_result;

wire [31:0] reg_rdata1, reg_rdata2;

regfile regfile_inst(
    .clk(clk),
    .write_enable(reg_write_enable),
    .waddr(reg_waddr),
    .wdata(reg_wdata),
    .raddr1(reg_raddr1),
    .raddr2(reg_raddr2),
    .rdata1(reg_rdata1),
    .rdata2(reg_rdata2)
);

wire [31:0] alu_a = reg_rdata1;
wire [31:0] alu_b = alu_imm_enable ? alu_imm : reg_rdata2;
wire [31:0] alu_result;
wire zero_flag;

alu alu_inst(
    .op(alu_op),
    .a(alu_a),
    .b(alu_b),
    .result(alu_result),
    .zero_flag(zero_flag)
);

wire take_branch = (branch_enable) ? (branch_type == `FUNCT3_BEQ && zero_flag) || (branch_type == `FUNCT3_BNE && !zero_flag) : 0;

initial begin
    pc = 0;
    memory_raddr = pc;
end

always @(posedge clk) begin
    case (state)
        2'd0: begin
            memory_raddr <= pc;
        end
        2'd1: begin
            instruction <= memory_rdata;
        end
        2'd2: begin
            if (branch_enable && zero_flag) $finish;
            if (ebreak)
                $finish;
            else if (jump_enable)
                pc <= pc + jump_offset;
            else if (take_branch)
                pc <= pc + branch_offset;
            else
                pc <= pc + 4;
        end
        default: begin end
    endcase
end

endmodule
