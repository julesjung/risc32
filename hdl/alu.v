`include "hdl/opcodes.v";

module alu(
    input [3:0] op,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] result
);

always @(*) begin
    case (op)
        `ALU_ADD: result = a + b;
        default: begin end
    endcase
end

endmodule
