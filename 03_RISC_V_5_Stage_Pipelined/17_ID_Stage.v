module ID_Stage(

    input clk,
    input rst,

    //-------------------------------------
    // Inputs from IF/ID Register
    //-------------------------------------
    input [31:0] InstrD,
    input [31:0] PCD,
    input [31:0] PCPlus4D,

    //-------------------------------------
    // Write-Back Inputs
    //-------------------------------------
    input RegWriteW,
    input [4:0] RDW,
    input [31:0] ResultW,

    //-------------------------------------
    // Outputs to ID/EX Register
    //-------------------------------------

    // Control Signals
    output RegWriteD,
    output ALUSrcD,
    output MemWriteD,
    output [1:0] ResultSrcD,
    output BranchD,
    output JumpD,
    output [3:0] ALUControlD,

    // Data Signals
    output [31:0] RD1_D,
    output [31:0] RD2_D,
    output [31:0] ImmExtD,
    output [31:0] PCD_Out,
    output [31:0] PCPlus4D_Out,

    // Register Addresses
    output [4:0] RS1_D,
    output [4:0] RS2_D,
    output [4:0] RD_D

);

    //-------------------------------------
    // Internal Signals
    //-------------------------------------
    wire [2:0] ImmSrc;

    //-------------------------------------
    // Control Unit
    //-------------------------------------
    Control_Unit_Top Control(

        .Op(InstrD[6:0]),
        .funct3(InstrD[14:12]),
        .funct7(InstrD[31:25]),

        .RegWrite(RegWriteD),
        .ALUSrc(ALUSrcD),
        .MemWrite(MemWriteD),
        .ResultSrc(ResultSrcD),
        .Branch(BranchD),
        .Jump(JumpD),
        .ImmSrc(ImmSrc),
        .ALUControl(ALUControlD)

    );

    //-------------------------------------
    // Register File
    //-------------------------------------
    Register_File RF(

        .clk(clk),
        .rst(rst),

        .WE3(RegWriteW),
        .WD3(ResultW),

        .A1(InstrD[19:15]),
        .A2(InstrD[24:20]),
        .A3(RDW),

        .RD1(RD1_D),
        .RD2(RD2_D)

    );

    //-------------------------------------
    // Sign Extension
    //-------------------------------------
    Sign_Extend SignExt(

        .In(InstrD),
        .ImmSrc(ImmSrc),
        .Imm_Ext(ImmExtD)

    );

    //-------------------------------------
    // Pass Signals Forward
    //-------------------------------------
    assign RS1_D = InstrD[19:15];
    assign RS2_D = InstrD[24:20];
    assign RD_D  = InstrD[11:7];

    assign PCD_Out      = PCD;
    assign PCPlus4D_Out = PCPlus4D;

endmodule