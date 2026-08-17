module EX_Stage(

    //-------------------------------------
    // Control Signals
    //-------------------------------------
    input BranchE,
    input JumpE,
    input ALUSrcE,
    input [3:0] ALUControlE,

    //-------------------------------------
    // Data Signals
    //-------------------------------------
    input [31:0] RD1_E,
    input [31:0] RD2_E,
    input [31:0] ImmExtE,
    input [31:0] PCE,

    //-------------------------------------
    // Forwarding Inputs
    //-------------------------------------
    input [31:0] ALUResultM,
    input [31:0] ResultW,
    input [1:0] ForwardAE,
    input [1:0] ForwardBE,

    //-------------------------------------
    // Outputs
    //-------------------------------------
    output PCSrcE,
    output [31:0] PCTargetE,
    output [31:0] ALUResultE,
    output [31:0] WriteDataE

);

    wire [31:0] SrcA;
    wire [31:0] SrcBForward;
    wire [31:0] SrcB;

    wire Zero;
    wire BranchTaken;

    //-------------------------------------
    // Forward MUX A
    //-------------------------------------
    Mux3 ForwardA_Mux(

        .a(RD1_E),
        .b(ResultW),
        .c(ALUResultM),

        .s(ForwardAE),

        .d(SrcA)

    );

    //-------------------------------------
    // Forward MUX B
    //-------------------------------------
    Mux3 ForwardB_Mux(

        .a(RD2_E),
        .b(ResultW),
        .c(ALUResultM),

        .s(ForwardBE),

        .d(SrcBForward)

    );

    //-------------------------------------
    // ALU Source MUX
    //-------------------------------------
    Mux2 ALUSrc_Mux(

        .a(SrcBForward),
        .b(ImmExtE),

        .s(ALUSrcE),

        .c(SrcB)

    );

    //-------------------------------------
    // ALU
    //-------------------------------------
    ALU alu(

        .A(SrcA),
        .B(SrcB),

        .ALUControl(ALUControlE),

        .Result(ALUResultE),
        .Zero(Zero)

    );

    //-------------------------------------
    // Branch / Jump Target Adder
    //-------------------------------------
    PC_Target_Adder TargetAdder(

        .PC(PCE),
        .ImmExt(ImmExtE),

        .PCTarget(PCTargetE)

    );

    //-------------------------------------
    // Branch Decision
    //-------------------------------------
    Branch_Control BC(

        .Branch(BranchE),
        .Zero(Zero),

        .PCSrc(BranchTaken)

    );

    //-------------------------------------
    // Final PC Selection
    //-------------------------------------
    assign PCSrcE = JumpE | BranchTaken;

    //-------------------------------------
    // Store Data (after forwarding)
    //-------------------------------------
    assign WriteDataE = SrcBForward;

endmodule