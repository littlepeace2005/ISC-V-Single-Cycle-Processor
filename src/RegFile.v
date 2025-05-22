module RegFile(
    input  wire        CLK,
    input  wire        Reset,
    input  wire        rg_wrt_en,
    input  wire [4:0]  rg_wrt_addr,
    input  wire [4:0]  rg_rd_addr1,
    input  wire [4:0]  rg_rd_addr2,
    input  wire [31:0] rg_wrt_data,
    output wire [31:0] rg_rd_data1,
    output wire [31:0] rg_rd_data2
);
    reg [31:0] reg_file [0:31];
    integer i;
    assign rg_rd_data1 = reg_file[rg_rd_addr1];
    assign rg_rd_data2 = reg_file[rg_rd_addr2];
    always @(posedge CLK or posedge Reset) begin
        if (reset) begin
            for (i = 0; i < 32; i = i + 1) begin
                reg_file[i] = 32'h00000000;
            end
        end
        else if (rg_wrt_en) begin
            reg_file[rg_wrt_addr] <= rg_wrt_data;
        end
    end
endmodule