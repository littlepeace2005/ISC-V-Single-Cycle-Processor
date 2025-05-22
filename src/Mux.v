module Mux (
    input  wire [31:0] d0,
    input  wire [31:0] d1,
    input  wire        S,
    output wire [31:0] y
);
    assign y = S ? d1 : d0;
endmodule