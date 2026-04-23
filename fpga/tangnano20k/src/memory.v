module memory(
    input clk,
    input [31:0] raddr,
    output wire [31:0] rdata
);

reg [7:0] ram [0:65535];

initial begin
    $readmemh("../../../build/program.mem", ram);
end

assign rdata = {
    ram[raddr + 3],
    ram[raddr + 2],
    ram[raddr + 1],
    ram[raddr]
};

endmodule
