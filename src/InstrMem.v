module Instr_mem (
    input  wire [7:0]  Addr,
    output wire [31:0] Data
);
    reg [31:0] memory [0:63];
    initial begin
        $readmemh("program.mem", memory);
    end
    assign Data = memory[Addr[7:2]];
endmodule