`include "hdl/opcodes.v";

module alu(
    input [3:0] op,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] result,
    output wire zero_flag
);

always @(*) begin
    case (op)
        `ALU_ADD: result = a + b;
        `ALU_SUB: result = a - b;
        default: begin end
    endcase
end

assign zero_flag = (result == 0);

endmodule
