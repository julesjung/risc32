module cpu(
    input wire clk
);

wire [4:0] reg_raddr;
wire [31:0] reg_rdata;

regfile regfile_inst(
    .clk(clk),
    .raddr(reg_raddr),
    .rdata(reg_rdata)
);

reg [31:0] pc;

always @(posedge clk) begin
    pc <= pc + 4;
end

wire [31:0] instruction = 32'h00100073;

control control_inst(
    .instruction(instruction)
);

endmodule
