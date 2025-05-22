module Datapath #(
    parameter PC_W = 8,
    parameter INS_W = 32,
    parameter RF_ADDRESS = 5,
    parameter DATA_W = 32,
    parameter DM_ADDRESS = 9,
    parameter ALU_CC_W = 4
)(
    input  wire                CLK,
    input  wire                Reset,
    input  wire                RegWrite,
    input  wire                MemtoReg,
    input  wire                ALUSrc,
    input  wire                MemWrite,
    input  wire                MemRead,
    input  wire [ALU_CC_W-1:0] ALUCC,
    output wire [6:0]          opcode,
    output wire [6:0]          Funct7,
    output wire [2:0]          Funct3,
    output wire [DATA_W-1:0]   Datapath_Result
);
    wire [PC_W-1:0]   PC, PCPlus4;
    wire [INS_W-1:0]  Instruction;
    wire [DATA_W-1:0] Reg1, Reg2;
    wire [DATA_W-1:0] SrcB;
    wire [DATA_W-1:0] ExtImm;
    wire [DATA_W-1:0] ALU_Result;
    wire [DATA_W-1:0] DataMem_read;
    wire [DATA_W-1:0] WriteBack_Data;
    FlipFlop flipFlop (
        .CLK(CLK),
        .Reset(Reset),
        .d(PCPlus4),
        .q(PC)
    );
    Adder adder (
        .a(PC),
        .b(8'h04),
        .sum(PCPlus4)
    );
    Instr_mem instrmem (
        .Addr(PC),
        .Data(Instruction)
    );
    assign opcode = Instruction[6:0];
    assign Funct3 = Instruction[14:12];
    assign Funct7 = Instruction[31:25];
    RegFile regfile (
        .CLK(CLK),
        .Reset(Reset),
        .rg_wrt_en(RegWrite),
        .rg_wrt_addr(Instruction[11:7]),
        .rg_rd_addr1(Instruction[19:15]),
        .rg_rd_addr2(Instruction[24:20]),
        .rg_wrt_data(WriteBack_Data),
        .rg_rd_data1(Reg1),
        .rg_rd_data2(Reg2)
    );
    ImmGen immgen (
        .InstCode(Instruction),
        .ImmOut(ExtImm)
    );
    Mux mux1 (
        .d0(Reg2),
        .d1(ExtImm),
        .S(ALUSrc),
        .y(SrcB)
    );
    ALU alu (
        .A(Reg1),
        .B(SrcB),
        .ALU_Operation(ALUCC),
        .Result(ALU_Result)
    );
    assign Datapath_Result = ALU_Result;
    data_mem datamem (
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .add(ALU_Result[DM_ADDRESS-1:0]),
        .write_data(Reg2),
        .read_data(DataMem_read)
    );
    Mux mux2 (
        .d0(ALU_Result),
        .d1(DataMem_read),
        .S(MemtoReg),
        .y(WriteBack_Data)
    );
endmodule