module cpu(
    input clk
);

wire [31:0] instruction;
reg [1:0] state;
wire ebreak;
wire reg_write_enable;
wire [4:0] reg_write_addr;
wire [4:0] reg_read_addr1;
wire [4:0] reg_read_addr2;
wire [2:0] alu_opcode;
wire alu_write_enable;
wire alu_immediate_enable;
wire [31:0] immediate;
wire jump_enable;
wire branch_enable;
wire [2:0] branch_type;
wire signed [31:0] address_offset;

control ctrl(
    .instruction(instruction),
    .state(state),
    .ebreak(ebreak),
    .reg_write_enable(reg_write_enable),
    .reg_write_addr(reg_write_addr),
    .reg_read_addr1(reg_read_addr1),
    .reg_read_addr2(reg_read_addr2),
    .alu_opcode(alu_opcode),
    .alu_write_enable(alu_write_enable),
    .alu_immediate_enable(alu_immediate_enable),
    .immediate(immediate),
    .jump_enable(jump_enable),
    .branch_enable(branch_enable),
    .branch_type(branch_type),
    .address_offset(address_offset)
);

datapath dp(
    .clk(clk),
    .state(state),
    .ebreak(ebreak),
    .reg_write_enable(reg_write_enable),
    .reg_write_addr(reg_write_addr),
    .reg_read_addr1(reg_read_addr1),
    .reg_read_addr2(reg_read_addr2),
    .alu_opcode(alu_opcode),
    .alu_write_enable(alu_write_enable),
    .alu_immediate_enable(alu_immediate_enable),
    .immediate(immediate),
    .jump_enable(jump_enable),
    .branch_enable(branch_enable),
    .branch_type(branch_type),
    .address_offset(address_offset),
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
