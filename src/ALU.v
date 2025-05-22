module ALU (
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire [3:0]  ALU_Operation,
    output reg  [31:0] Result,
    output reg         Carry_out,
    output reg         zero,
    output reg         overflow
);
always @(*) begin
    Carry_out = 1'b0;
    overflow  = 1'b0;
    case(ALU_Operation)
        4'b0000: Result = a & b;
        4'b0001: Result = a | b;
        default: begin // 4'b0010
            Result = $signed(a) + $signed(b);
            Carry_out = ({1'b0, a} + {1'b0, b}) >> 32;
            overflow = (a[31] == b[31]) & (a[31] != Result[31]);
        end
        4'b0110: begin
            Result = $signed(a) - $signed(b);
            overflow = (a[31] != b[31]) & (a[31] != Result[31]);
        end
        4'b0111: Result = $signed(a) < $signed(b);
        4'b1100: Result = ~(a | b);
        4'b1111: Result = a == b;
    endcase
    zero = Result == 32'h00000000;
end
endmodule