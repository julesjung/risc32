`include "hdl/opcodes.v"

module datapath(
    input clk,
    input [1:0] state,
    input ebreak,
    input reg_write_enable,
    input [4:0] reg_write_addr,
    input [4:0] reg_read_addr1,
    input [4:0] reg_read_addr2,
    input [3:0] alu_opcode,
    input alu_write_enable,
    input alu_immediate_enable,
    input [31:0] immediate,
    input jump_enable,
    input branch_enable,
    input [2:0] branch_type,
    input signed [31:0] address_offset,
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

wire [31:0] reg_write_data = (alu_write_enable) ? alu_result : immediate;

wire [31:0] reg_read_data1, reg_read_data2;

regfile regfile_inst(
    .clk(clk),
    .write_enable(reg_write_enable),
    .write_addr(reg_write_addr),
    .write_data(reg_write_data),
    .read_addr1(reg_read_addr1),
    .read_addr2(reg_read_addr2),
    .read_data1(reg_read_data1),
    .read_data2(reg_read_data2)
);

wire [31:0] alu_a = reg_read_data1;
wire [31:0] alu_b = (alu_immediate_enable) ? immediate : reg_read_data2;
wire [31:0] alu_result;
wire zero_flag;

alu alu_inst(
    .opcode(alu_opcode),
    .a(alu_a),
    .b(alu_b),
    .result(alu_result),
    .zero_flag(zero_flag)
);

wire take_branch = (branch_enable) ? (branch_type == `FUNCT3_BEQ && zero_flag) || (branch_type == `FUNCT3_BNE && !zero_flag) : 0;

initial begin
    pc = 0;
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
            if (ebreak)
                $finish;
            else if (jump_enable || take_branch)
                pc <= pc + address_offset;
            else
                pc <= pc + 4;
        end
        default: begin end
    endcase
end

endmodule
