module regfile(
    input wire clk,
    input wire [4:0] raddr,
    output wire [31:0] rdata
);

reg [31:0] regs [0:31];

initial begin
    regs[1] = 5;
end

assign rdata = regs[raddr];

endmodule
