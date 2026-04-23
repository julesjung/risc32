`include "../../../rtl/opcodes.v"
`include "../../../rtl/alu.v"
`include "../../../rtl/control.v"
`include "../../../rtl/cpu.v"
`include "../../../rtl/datapath.v"
`include "../../../rtl/opcodes.v"
`include "../../../rtl/regfile.v"

module top(
    input clk,
    output wire [5:0] leds
);

cpu cpu_inst(
    .clk(clk)
);

assign leds = cpu_inst.dp.regfile_inst.regs[7][5:0];

endmodule
