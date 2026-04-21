module top(
    input wire clk,
    output wire [31:0] pc,
    output wire [1:0] state,
    output wire [31:0] regs [0:31],
    output wire [31:0] instruction
);

assign pc = cpu_inst.dp.pc;
assign state = cpu_inst.state;
assign regs = cpu_inst.dp.regfile_inst.regs;
assign instruction = cpu_inst.instruction;

cpu cpu_inst(
    .clk(clk)
);

endmodule
