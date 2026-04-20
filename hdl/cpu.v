module cpu(
    input wire clk
);

reg [1:0] state;

wire [4:0] reg_raddr;
wire [31:0] reg_rdata;

regfile regfile_inst(
    .raddr(reg_raddr),
    .rdata(reg_rdata)
);

reg [31:0] instruction;

reg [31:0] memory_raddr;
wire [31:0] memory_rdata;

memory memory_inst(
    .clk(clk),
    .raddr(memory_raddr),
    .rdata(memory_rdata)
);

reg [31:0] pc;

always @(posedge clk) begin
    case (state)
        2'd0: begin
            memory_raddr <= pc;
            pc <= pc + 4;
            state <= 2'd1;
        end
        2'd1: begin
            state <= 2'd2;
        end
        2'd2: begin
            state <= 2'd0;
        end
        default: state <= 2'd0;
    endcase
    if (ebreak) begin
        $finish();
    end
end

wire ebreak;

control control_inst(
    .instruction(memory_rdata),
    .state(state),
    .ebreak(ebreak)
);

endmodule
