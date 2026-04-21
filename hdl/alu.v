`include "hdl/opcodes.v";

module alu(
    input [3:0] opcode,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] result,
    output wire zero_flag,
    output wire sign_flag,
    output wire carry_flag,
    output wire overflow_flag
);

wire [32:0] sum = { 1'b0, a } + { 1'b0, b };
wire [32:0] difference = { 1'b0, a } + { 1'b0, ~b } + 1;

always @(*) begin
    case (opcode)
        `ALU_ADD: begin
            result = sum[31:0];
        end
        `ALU_SUB: begin
            result = difference[31:0];
        end
        default: result = 0;
    endcase
end

assign zero_flag = (result == 0);
assign sign_flag = result[31];
assign carry_flag =
    (opcode == `ALU_ADD) ? sum[32] :
    (opcode == `ALU_SUB) ?  difference[32] :
    1'b0;
assign overflow_flag =
    (opcode == `ALU_ADD) ?
        (a[31] == b[31]) && (sum[31] != a[31]) :
    (opcode == `ALU_SUB) ?
        (a[31] != b[31]) && (difference[31] != a[31]) :
    1'b0;

endmodule
