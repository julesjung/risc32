module control(
    input reg [1:0] state,
    input wire [31:0] instruction,
    output reg ebreak
);

localparam OPCODE_OP_IMM = 7'b001_0011;
localparam FUNCT3_ADDI = 3'b000;
localparam OPCODE_SYSTEM = 7'b111_0011;
localparam FUNCT3_PRIV = 3'b000;
localparam FUNCT12_ECALL = 12'b0000_0000_0000;
localparam FUNCT12_EBREAK = 12'b0000_0000_0001;

wire [6:0] opcode = instruction[6:0];
wire [4:0] rd = instruction[11:7];
wire [4:0] rs1 = instruction[19:15];
wire [4:0] rs2 = instruction[24:20];
wire [11:0] imm12 = instruction[31:20];
wire [2:0] funct3 = instruction[14:12];
wire [6:0] funct7 = instruction[31:25];
wire [11:0] funct12 = instruction[31:20];

always @(*) begin
    ebreak = 0'b0;

    if (state == 2) case (opcode)
        OPCODE_OP_IMM: case (funct3)
            FUNCT3_ADDI: begin
                $display("addi");
            end
            default: begin end
        endcase
        OPCODE_SYSTEM: if (funct3 == FUNCT3_PRIV && funct12 == FUNCT12_EBREAK) begin
            $display("ebreak");
            ebreak = 1'b1;
        end
        default: begin end
    endcase
end

endmodule
