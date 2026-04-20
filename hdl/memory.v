module memory(
    input clk,
    input [31:0] raddr,
    output reg [31:0] rdata
);

reg [7:0] ram [0:65535];

initial begin
    string memfile;

    if ($value$plusargs("mem=%s", memfile)) begin
        $readmemh(memfile, ram);
    end
end

assign rdata = {
    ram[raddr + 3],
    ram[raddr + 2],
    ram[raddr + 1],
    ram[raddr]
};

endmodule
