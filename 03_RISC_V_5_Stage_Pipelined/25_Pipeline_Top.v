module Pipeline_Top(

    input clk,
    input rst

);

/////////////////////////////////////////////////////////
// IF Stage Wires
/////////////////////////////////////////////////////////

wire PCWrite;
wire StallD;
wire FlushD;
wire FlushE;

wire PCSrcE;

wire [31:0] InstrF;
wire [31:0] PCF;
wire [31:0] PCPlus4F;
wire [31:0] PCTargetE;

/////////////////////////////////////////////////////////
// IF/ID Wires
/////////////////////////////////////////////////////////

wire [31:0] InstrD;
wire [31:0] PCD;
wire [31:0] PCPlus4D;

/////////////////////////////////////////////////////////
// Decode Stage
/////////////////////////////////////////////////////////

wire RegWriteD;
wire ALUSrcD;
wire MemWriteD;
wire [1:0] ResultSrcD;
wire BranchD;
wire JumpD;

wire [3:0] ALUControlD;

wire [31:0] RD1_D;
wire [31:0] RD2_D;
wire [31:0] ImmExtD;

wire [31:0] PCD_Out;
wire [31:0] PCPlus4D_Out;

wire [4:0] RS1_D;
wire [4:0] RS2_D;
wire [4:0] RD_D;

/////////////////////////////////////////////////////////
// ID/EX
/////////////////////////////////////////////////////////

wire RegWriteE;
wire ALUSrcE;
wire MemWriteE;
wire [1:0] ResultSrcE;
wire BranchE;
wire JumpE;

wire [3:0] ALUControlE;

wire [31:0] RD1_E;
wire [31:0] RD2_E;
wire [31:0] ImmExtE;
wire [31:0] PCE;
wire [31:0] PCPlus4E;
wire [31:0] InstrE;


wire [4:0] RS1_E;
wire [4:0] RS2_E;
wire [4:0] RD_E;

/////////////////////////////////////////////////////////
// Execute Stage
/////////////////////////////////////////////////////////

wire [31:0] ALUResultE;
wire [31:0] WriteDataE;

wire [1:0] ForwardAE;
wire [1:0] ForwardBE;

/////////////////////////////////////////////////////////
// EX/MEM
/////////////////////////////////////////////////////////

wire RegWriteM;
wire MemWriteM;
wire [1:0] ResultSrcM;

wire [31:0] ALUResultM;
wire [31:0] WriteDataM;
wire [31:0] PCPlus4M;
wire [31:0] InstrM;

wire [4:0] RD_M;

/////////////////////////////////////////////////////////
// Memory Stage
/////////////////////////////////////////////////////////

wire [31:0] ReadDataM;

/////////////////////////////////////////////////////////
// MEM/WB
/////////////////////////////////////////////////////////

wire RegWriteW;
wire [1:0] ResultSrcW;

wire [31:0] ReadDataW;
wire [31:0] ALUResultW;
wire [31:0] PCPlus4W;
wire [31:0] InstrW;

wire [4:0] RD_W;

/////////////////////////////////////////////////////////
// Writeback
/////////////////////////////////////////////////////////

wire [31:0] ResultW;

/////////////////////////////////////////////////////////
// IF Stage
/////////////////////////////////////////////////////////

IF_Stage IF_STAGE(

    .clk(clk),
    .rst(rst),

    .PCWrite(PCWrite),
    .PCSrcE(PCSrcE),

    .PCTargetE(PCTargetE),

    .InstrF(InstrF),
    .PCF(PCF),
    .PCPlus4F(PCPlus4F)

);

/////////////////////////////////////////////////////////
// IF/ID Register
/////////////////////////////////////////////////////////

IF_ID IF_ID_REG(

    .clk(clk),
    .rst(rst),

    .StallD(StallD),
    .FlushD(FlushD),

    .InstrF(InstrF),
    .PCF(PCF),
    .PCPlus4F(PCPlus4F),

    .InstrD(InstrD),
    .PCD(PCD),
    .PCPlus4D(PCPlus4D)

);

/////////////////////////////////////////////////////////
// ID Stage
/////////////////////////////////////////////////////////

ID_Stage ID_STAGE(

    .clk(clk),
    .rst(rst),

    .InstrD(InstrD),
    .PCD(PCD),
    .PCPlus4D(PCPlus4D),

    //-------------------------------------
    // Write Back Interface
    //-------------------------------------
    .RegWriteW(RegWriteW),
    .RDW(RD_W),
    .ResultW(ResultW),

    //-------------------------------------
    // Control Outputs
    //-------------------------------------
    .RegWriteD(RegWriteD),
    .ALUSrcD(ALUSrcD),
    .MemWriteD(MemWriteD),
    .ResultSrcD(ResultSrcD),
    .BranchD(BranchD),
    .JumpD(JumpD),

    .ALUControlD(ALUControlD),

    //-------------------------------------
    // Data Outputs
    //-------------------------------------
    .RD1_D(RD1_D),
    .RD2_D(RD2_D),
    .ImmExtD(ImmExtD),

    .PCD_Out(PCD_Out),
    .PCPlus4D_Out(PCPlus4D_Out),

    //-------------------------------------
    // Register Numbers
    //-------------------------------------
    .RS1_D(RS1_D),
    .RS2_D(RS2_D),
    .RD_D(RD_D)

);

/////////////////////////////////////////////////////////
// ID/EX Register
/////////////////////////////////////////////////////////

ID_EX ID_EX_REG(

    .clk(clk),
    .rst(rst),

    .FlushE(FlushE),

    //-------------------------------------
    // Control Signals
    //-------------------------------------
    .RegWriteD(RegWriteD),
    .ALUSrcD(ALUSrcD),
    .MemWriteD(MemWriteD),
    .ResultSrcD(ResultSrcD),
    .BranchD(BranchD),
    .JumpD(JumpD),

    .ALUControlD(ALUControlD),

    //-------------------------------------
    // Data Signals
    //-------------------------------------
    .RD1_D(RD1_D),
    .RD2_D(RD2_D),
    .ImmExtD(ImmExtD),

    .PCD(PCD_Out),
    .PCPlus4D(PCPlus4D_Out),
    .InstrD(InstrD),

    //-------------------------------------
    // Register Numbers
    //-------------------------------------
    .RS1_D(RS1_D),
    .RS2_D(RS2_D),
    .RD_D(RD_D),

    //-------------------------------------
    // Outputs
    //-------------------------------------
    .RegWriteE(RegWriteE),
    .ALUSrcE(ALUSrcE),
    .MemWriteE(MemWriteE),
    .ResultSrcE(ResultSrcE),
    .BranchE(BranchE),
    .JumpE(JumpE),

    .ALUControlE(ALUControlE),

    .RD1_E(RD1_E),
    .RD2_E(RD2_E),
    .ImmExtE(ImmExtE),

    .PCE(PCE),
    .PCPlus4E(PCPlus4E),
    .InstrE(InstrE),

    .RS1_E(RS1_E),
    .RS2_E(RS2_E),
    .RD_E(RD_E)

);

/////////////////////////////////////////////////////////
// Execute Stage
/////////////////////////////////////////////////////////

EX_Stage EX_STAGE(

    //-------------------------------------
    // Control Signals
    //-------------------------------------
    .BranchE(BranchE),
    .JumpE(JumpE),
    .ALUSrcE(ALUSrcE),
    .ALUControlE(ALUControlE),

    //-------------------------------------
    // Data Signals
    //-------------------------------------
    .RD1_E(RD1_E),
    .RD2_E(RD2_E),
    .ImmExtE(ImmExtE),
    .PCE(PCE),

    //-------------------------------------
    // Forwarding
    //-------------------------------------
    .ALUResultM(ALUResultM),
    .ResultW(ResultW),

    .ForwardAE(ForwardAE),
    .ForwardBE(ForwardBE),

    //-------------------------------------
    // Outputs
    //-------------------------------------
    .PCSrcE(PCSrcE),
    .PCTargetE(PCTargetE),

    .ALUResultE(ALUResultE),
    .WriteDataE(WriteDataE)

);

/////////////////////////////////////////////////////////
// EX/MEM Register
/////////////////////////////////////////////////////////

EX_MEM EX_MEM_REG(

    .clk(clk),
    .rst(rst),

    //-------------------------------------
    // Control Signals
    //-------------------------------------
    .RegWriteE(RegWriteE),
    .MemWriteE(MemWriteE),
    .ResultSrcE(ResultSrcE),

    //-------------------------------------
    // Data Signals
    //-------------------------------------
    .ALUResultE(ALUResultE),
    .WriteDataE(WriteDataE),
    .PCPlus4E(PCPlus4E),
    .InstrE(InstrE),

    //-------------------------------------
    // Destination Register
    //-------------------------------------
    .RD_E(RD_E),

    //-------------------------------------
    // Outputs
    //-------------------------------------
    .RegWriteM(RegWriteM),
    .MemWriteM(MemWriteM),
    .ResultSrcM(ResultSrcM),

    .ALUResultM(ALUResultM),
    .WriteDataM(WriteDataM),
    .PCPlus4M(PCPlus4M),
    .InstrM(InstrM),

    .RD_M(RD_M)

);

/////////////////////////////////////////////////////////
// Memory Stage
/////////////////////////////////////////////////////////

MEM_Stage MEM_STAGE(

    .clk(clk),

    .MemWriteM(MemWriteM),

    .ALUResultM(ALUResultM),
    .WriteDataM(WriteDataM),

    .ReadDataM(ReadDataM)

);

/////////////////////////////////////////////////////////
// MEM/WB Register
/////////////////////////////////////////////////////////

MEM_WB MEM_WB_REG(

    .clk(clk),
    .rst(rst),

    //-------------------------------------
    // Control Signals
    //-------------------------------------
    .RegWriteM(RegWriteM),
    .ResultSrcM(ResultSrcM),

    //-------------------------------------
    // Data Signals
    //-------------------------------------
    .ReadDataM(ReadDataM),
    .ALUResultM(ALUResultM),
    .PCPlus4M(PCPlus4M),
    .InstrM(InstrM),

    //-------------------------------------
    // Destination Register
    //-------------------------------------
    .RD_M(RD_M),

    //-------------------------------------
    // Outputs
    //-------------------------------------
    .RegWriteW(RegWriteW),
    .ResultSrcW(ResultSrcW),

    .ReadDataW(ReadDataW),
    .ALUResultW(ALUResultW),
    .PCPlus4W(PCPlus4W),
    .InstrW(InstrW),

    .RD_W(RD_W)

);

/////////////////////////////////////////////////////////
// Write Back Stage
/////////////////////////////////////////////////////////

WB_Stage WB_STAGE(

    .ResultSrcW(ResultSrcW),

    .ReadDataW(ReadDataW),
    .ALUResultW(ALUResultW),
    .PCPlus4W(PCPlus4W),

    .ResultW(ResultW)

);

/////////////////////////////////////////////////////////
// Forwarding Unit
/////////////////////////////////////////////////////////

Forwarding_Unit FU(

    .RS1_E(RS1_E),
    .RS2_E(RS2_E),

    .RD_M(RD_M),
    .RD_W(RD_W),

    .RegWriteM(RegWriteM),
    .RegWriteW(RegWriteW),

    .ForwardAE(ForwardAE),
    .ForwardBE(ForwardBE)

);

/////////////////////////////////////////////////////////
// Hazard Unit
/////////////////////////////////////////////////////////

Hazard_Unit HU(

    .RS1_D(RS1_D),
    .RS2_D(RS2_D),

    .RD_E(RD_E),
    .ResultSrcE(ResultSrcE),

    .PCSrcE(PCSrcE),

    .PCWrite(PCWrite),
    .StallD(StallD),
    .FlushE(FlushE)

);

/////////////////////////////////////////////////////////
// Flush IF/ID on Taken Branch or Jump
/////////////////////////////////////////////////////////

assign FlushD = PCSrcE;

endmodule
