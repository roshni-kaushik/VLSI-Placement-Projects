module Single_Cycle_Top(
    input clk,
    input rst
);

//==============================
// Datapath Signals
//==============================
wire [31:0] PC;
wire [31:0] PCPlus4;
wire [31:0] PCTarget;
wire [31:0] PCNext;

wire [31:0] Instruction;

wire [31:0] RD1;
wire [31:0] RD2;
wire [31:0] WriteData;

wire [31:0] ImmExt;

wire [31:0] SrcB;
wire [31:0] ALUResult;

wire [31:0] ReadData;

//==============================
// Control Signals
//==============================
wire RegWrite;
wire ALUSrc;
wire MemWrite;
wire ResultSrc;
wire Branch;
wire Zero;
wire PCSrc;

wire [1:0] ImmSrc;
wire [2:0] ALUControl;

PC pc(
    .clk(clk),
    .rst(rst),
    .PC_Next(PCNext),
    .PC(PC)
);

PC_Adder pc_adder(
    .a(PC),
    .b(32'd4),
    .c(PCPlus4)
);

Instruction_Memory instruction_memory(
    .rst(rst),
    .A(PC),
    .RD(Instruction)
);

//==============================
// Control Unit
//==============================
Control_Unit_Top control_unit(
    .Op(Instruction[6:0]),
    .funct3(Instruction[14:12]),
    .funct7(Instruction[31:25]),

    .RegWrite(RegWrite),
    .ImmSrc(ImmSrc),
    .ALUSrc(ALUSrc),
    .MemWrite(MemWrite),
    .ResultSrc(ResultSrc),
    .Branch(Branch),
    .ALUControl(ALUControl)
);

//==============================
// Register File
//==============================
Register_File register_file(
    .clk(clk),
    .rst(rst),

    .WE3(RegWrite),

    .A1(Instruction[19:15]),
    .A2(Instruction[24:20]),
    .A3(Instruction[11:7]),

    .WD3(WriteData),

    .RD1(RD1),
    .RD2(RD2)
);

//==============================
// Sign Extend
//==============================
Sign_Extend sign_extend(
    .In(Instruction),
    .ImmSrc(ImmSrc),
    .Imm_Ext(ImmExt)
);

//==============================
// ALU Source MUX
//==============================
Mux alu_src_mux(
    .a(RD2),
    .b(ImmExt),
    .s(ALUSrc),
    .c(SrcB)
);

//==============================
// ALU
//==============================
ALU alu(
    .A(RD1),
    .B(SrcB),

    .ALUControl(ALUControl),

    .Result(ALUResult),

    .Zero(Zero),
    .Carry(),
    .OverFlow(),
    .Negative()
);

//==============================
// Branch Control
//==============================
Branch_Control branch_control(
    .Branch(Branch),
    .Zero(Zero),
    .PCSrc(PCSrc)
);

//==============================
// PC Target Adder
//==============================
PC_Target_Adder pc_target_adder(
    .PC(PC),
    .ImmExt(ImmExt),
    .PCTarget(PCTarget)
);

//==============================
// Data Memory
//==============================
Data_Memory data_memory(
    .clk(clk),
    .rst(rst),

    .WE(MemWrite),

    .A(ALUResult),

    .WD(RD2),

    .RD(ReadData)
);

//==============================
// Write Back MUX
//==============================
Mux writeback_mux(
    .a(ALUResult),
    .b(ReadData),
    .s(ResultSrc),
    .c(WriteData)
);

//==============================
// Next PC MUX
//==============================
Mux pc_mux(
    .a(PCPlus4),
    .b(PCTarget),
    .s(PCSrc),
    .c(PCNext)
);

endmodule

