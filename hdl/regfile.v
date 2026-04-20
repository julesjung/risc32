module regfile(
    input clk,
    input write_enable,
    input [4:0] waddr,
    input [31:0] wdata,
    input [4:0] raddr1,
    input [4:0] raddr2,
    output wire [31:0] rdata1,
    output wire [31:0] rdata2
);

reg [31:0] regs [0:31];

always @(posedge clk) begin
    if (write_enable) regs[waddr] <= wdata;
end

assign rdata1 = regs[raddr1];
assign rdata2 = regs[raddr2];

endmodule
