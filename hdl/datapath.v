module datapath(
    input clk,
    input [1:0] state,
    input ebreak,
    input reg_write_enable,
    input [4:0] reg_waddr,
    input [4:0] reg_raddr1,
    input [3:0] alu_op,
    input alu_imm_enable,
    input [31:0] alu_imm,
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

wire [4:0] reg_raddr2;
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

alu alu_inst(
    .op(alu_op),
    .a(alu_a),
    .b(alu_b),
    .result(alu_result)
);

always @(posedge clk) begin
    $display("instruction: %08h, state: %1d, x1: %08h, x2: %08h, alu_result: %08h", instruction, state, regfile_inst.regs[1], regfile_inst.regs[2], alu_result);
    case (state)
        2'd0: begin
            memory_raddr <= pc;
            pc <= pc + 4;
        end
        2'd1: begin
            instruction <= memory_rdata;
        end
        2'd2: begin
            if (ebreak) $finish;
        end
        default: begin end
    endcase
end

endmodule
