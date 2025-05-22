module DataMem (
    input  wire        MemRead,
    input  wire        MemWrite,
    input  wire [8:0]  add,
    input  wire [31:0] write_data,
    output reg  [31:0] read_data
);
    reg [31:0] memory [0:127];
    initial begin
        $readmemh("data.mem", memory);
    end
    assign read_data = (MemRead) ? memory[add[8:2]] : 32'hxxxxxxxx;
    always @(*) begin
        if (MemWrite)
            memory[add[8:2]] = write_data;
    end
endmodule
