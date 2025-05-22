module ImmGen(
    input  wire [31:0] InstCode,
    output reg  [31:0] ImmOut
);
    wire [6:0] opcode = InstCode[6:0];
    always @(*) begin
        case (opcode)
            7'b0010011: // I-type (e.g. addi)
                ImmOut = {{20{InstCode[31]}}, InstCode[31:20]};
            7'b0100011: // S-type (e.g. sw)
                ImmOut = {{20{InstCode[31]}}, InstCode[31:25], InstCode[11:7]};
            7'b1100011: // B-type (e.g. beq)
                ImmOut = {{19{InstCode[31]}}, InstCode[31], InstCode[7], InstCode[30:25], InstCode[11:8], 1'b0};
            7'b0110111: // U-type (e.g. lui)
                ImmOut = {InstCode[31:12], 12'h000};
            7'b1101111: // J-type (e.g. jal)
                ImmOut = {{11{InstCode[31]}}, InstCode[31], InstCode[19:12], InstCode[20], InstCode[30:21], 1'b0};
            default: ImmOut = 32'h00;
        endcase
    end
endmodule