`include "hdl/opcodes.v"

module control(
    input wire [31:0] instruction
);

always @(*) begin
    case (instruction[6:0])
        `OPCODE_SYSTEM: if (instruction[14:12] == `FUNCT3_PRIV && instruction[31:20] == `FUNCT12_EBREAK) begin
            $finish();
        end
        default: ;
    endcase
end

endmodule
