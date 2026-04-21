module regfile(
    input clk,
    input write_enable,
    input [4:0] write_addr,
    input [31:0] write_data,
    input [4:0] read_addr1,
    input [4:0] read_addr2,
    output wire [31:0] read_data1,
    output wire [31:0] read_data2
);

reg [31:0] regs [0:31];

always @(posedge clk) begin
    if (write_enable && write_addr != 0)
        regs[write_addr] <= write_data;
end

assign read_data1 = (read_addr1 == 0) ? 0 : regs[read_addr1];
assign read_data2 = (read_addr2 == 0) ? 0 : regs[read_addr2];

endmodule
