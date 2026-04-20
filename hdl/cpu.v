module cpu(
    input clk
);

reg [1:0] state;

always @(posedge clk) begin
    case (state)
        2'd0: state <= 2'd1;
        2'd1: state <= 2'd2;
        2'd2: state <= 2'd0;
        default: state <= 2'd0;
    endcase
end

wire [31:0] instruction;
wire ebreak;
wire reg_write_enable;
wire [4:0] reg_waddr;
wire [4:0] reg_raddr1;
wire [4:0] reg_raddr2;
wire [3:0] alu_op;
wire alu_imm_enable;
wire [31:0] alu_imm;

control ctrl(
    .instruction(instruction),
    .state(state),
    .reg_write_enable(reg_write_enable),
    .reg_waddr(reg_waddr),
    .reg_raddr1(reg_raddr1),
    .reg_raddr2(reg_raddr2),
    .alu_imm_enable(alu_imm_enable),
    .alu_imm(alu_imm),
    .alu_op(alu_op),
    .ebreak(ebreak)
);

datapath dp(
    .clk(clk),
    .state(state),
    .ebreak(ebreak),
    .reg_write_enable(reg_write_enable),
    .reg_waddr(reg_waddr),
    .reg_raddr1(reg_raddr1),
    .reg_raddr2(reg_raddr2),
    .alu_op(alu_op),
    .alu_imm_enable(alu_imm_enable),
    .alu_imm(alu_imm),
    .instruction(instruction)
);

endmodule
