module FlipFlop (
    input  wire       CLK,
    input  wire       Reset,
    input  wire [7:0] d,
    output reg  [7:0] q
);
    always @(posedge CLK or posedge Reset) begin
        if (Reset)
            q <= 8'h00;
        else
            q <= d;
    end
endmodule