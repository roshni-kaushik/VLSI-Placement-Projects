module ID_EX(

    input clk,
    input rst,

    //-------------------------------------
    // Flush Control
    //-------------------------------------
    input FlushE,

    //-------------------------------------
    // Control Signals
    //-------------------------------------
    input RegWriteD,
    input ALUSrcD,
    input MemWriteD,
    input [1:0] ResultSrcD,
    input BranchD,
    input JumpD,
    input [3:0] ALUControlD,

    //-------------------------------------
    // Data Signals
    //-------------------------------------
    input [31:0] RD1_D,
    input [31:0] RD2_D,
    input [31:0] ImmExtD,
    input [31:0] PCD,
    input [31:0] PCPlus4D,

    //-------------------------------------
    // Debug Instruction
    //-------------------------------------
    input [31:0] InstrD,

    //-------------------------------------
    // Register Numbers
    //-------------------------------------
    input [4:0] RS1_D,
    input [4:0] RS2_D,
    input [4:0] RD_D,

    //-------------------------------------
    // Outputs to EX Stage
    //-------------------------------------
    output reg RegWriteE,
    output reg ALUSrcE,
    output reg MemWriteE,
    output reg [1:0] ResultSrcE,
    output reg BranchE,
    output reg JumpE,
    output reg [3:0] ALUControlE,

    output reg [31:0] RD1_E,
    output reg [31:0] RD2_E,
    output reg [31:0] ImmExtE,
    output reg [31:0] PCE,
    output reg [31:0] PCPlus4E,

    //-------------------------------------
    // Debug Instruction
    //-------------------------------------
    output reg [31:0] InstrE,

    //-------------------------------------
    // Register Numbers
    //-------------------------------------
    output reg [4:0] RS1_E,
    output reg [4:0] RS2_E,
    output reg [4:0] RD_E

);

    //-------------------------------------
    // ID/EX Pipeline Register
    //-------------------------------------
    always @(posedge clk or negedge rst)
    begin

        //---------------------------------
        // Reset / Flush
        //---------------------------------
        if (!rst || FlushE)
        begin
            // Control Signals
            RegWriteE   <= 1'b0;
            ALUSrcE     <= 1'b0;
            MemWriteE   <= 1'b0;
            ResultSrcE  <= 2'b00;
            BranchE     <= 1'b0;
            JumpE       <= 1'b0;
            ALUControlE <= 4'b0000;

            // Data Signals
            RD1_E      <= 32'd0;
            RD2_E      <= 32'd0;
            ImmExtE    <= 32'd0;
            PCE        <= 32'd0;
            PCPlus4E   <= 32'd0;
            InstrE     <= 32'd0;

            // Register Numbers
            RS1_E <= 5'd0;
            RS2_E <= 5'd0;
            RD_E  <= 5'd0;
        end

        //---------------------------------
        // Normal Operation
        //---------------------------------
        else
        begin
            // Control Signals
            RegWriteE   <= RegWriteD;
            ALUSrcE     <= ALUSrcD;
            MemWriteE   <= MemWriteD;
            ResultSrcE  <= ResultSrcD;
            BranchE     <= BranchD;
            JumpE       <= JumpD;
            ALUControlE <= ALUControlD;

            // Data Signals
            RD1_E      <= RD1_D;
            RD2_E      <= RD2_D;
            ImmExtE    <= ImmExtD;
            PCE        <= PCD;
            PCPlus4E   <= PCPlus4D;
            InstrE     <= InstrD;

            // Register Numbers
            RS1_E <= RS1_D;
            RS2_E <= RS2_D;
            RD_E  <= RD_D;
        end

    end

endmodule