module Adder (
    input  wire [7:0] A,
    input  wire [7:0] B,
    output wire [7:0] Sum,
    output wire       Cout
);
    assign {Cout, Sum} = A + B;
endmodule