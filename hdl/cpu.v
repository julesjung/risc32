module cpu(
    input clk
);

wire [31:0] instruction;
reg [1:0] state;
wire ebreak;
wire reg_write_enable;
wire [4:0] reg_waddr;
wire [4:0] reg_raddr1;
wire [4:0] reg_raddr2;
wire [3:0] alu_op;
wire alu_imm_enable;
wire [31:0] alu_imm;
wire jump_enable;
wire signed [31:0] jump_offset;
wire branch_enable;
wire [2:0] branch_type;
wire signed [31:0] branch_offset;

control ctrl(
    .instruction(instruction),
    .state(state),
    .ebreak(ebreak),
    .reg_write_enable(reg_write_enable),
    .reg_waddr(reg_waddr),
    .reg_raddr1(reg_raddr1),
    .reg_raddr2(reg_raddr2),
    .alu_op(alu_op),
    .alu_imm_enable(alu_imm_enable),
    .alu_imm(alu_imm),
    .jump_enable(jump_enable),
    .jump_offset(jump_offset),
    .branch_enable(branch_enable),
    .branch_type(branch_type),
    .branch_offset(branch_offset)
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
    .jump_enable(jump_enable),
    .jump_offset(jump_offset),
    .branch_enable(branch_enable),
    .branch_type(branch_type),
    .branch_offset(branch_offset),
    .instruction(instruction)
);

always @(posedge clk) begin
    case (state)
        2'd0: state <= 2'd1;
        2'd1: state <= 2'd2;
        2'd2: state <= 2'd0;
        default: state <= 2'd0;
    endcase
end

endmodule
