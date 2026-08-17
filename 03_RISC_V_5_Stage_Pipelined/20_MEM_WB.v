module MEM_WB(

    input clk,
    input rst,

    //-------------------------------------
    // Control Signals
    //-------------------------------------
    input RegWriteM,
    input [1:0] ResultSrcM,

    //-------------------------------------
    // Data Signals
    //-------------------------------------
    input [31:0] ReadDataM,
    input [31:0] ALUResultM,
    input [31:0] PCPlus4M,

    //-------------------------------------
    // Debug Instruction
    //-------------------------------------
    input [31:0] InstrM,

    //-------------------------------------
    // Destination Register
    //-------------------------------------
    input [4:0] RD_M,

    //-------------------------------------
    // Outputs to WB Stage
    //-------------------------------------
    output reg RegWriteW,
    output reg [1:0] ResultSrcW,

    output reg [31:0] ReadDataW,
    output reg [31:0] ALUResultW,
    output reg [31:0] PCPlus4W,

    //-------------------------------------
    // Debug Instruction
    //-------------------------------------
    output reg [31:0] InstrW,

    //-------------------------------------
    // Destination Register
    //-------------------------------------
    output reg [4:0] RD_W

);

    //-------------------------------------
    // MEM/WB Pipeline Register
    //-------------------------------------
    always @(posedge clk or negedge rst)
    begin

        //---------------------------------
        // Asynchronous Active-Low Reset
        //---------------------------------
        if (!rst)
        begin
            // Control Signals
            RegWriteW  <= 1'b0;
            ResultSrcW <= 2'b00;

            // Data Signals
            ReadDataW  <= 32'd0;
            ALUResultW <= 32'd0;
            PCPlus4W   <= 32'd0;
            InstrW     <= 32'd0;

            // Destination Register
            RD_W <= 5'd0;
        end

        //---------------------------------
        // Normal Operation
        //---------------------------------
        else
        begin
            // Control Signals
            RegWriteW  <= RegWriteM;
            ResultSrcW <= ResultSrcM;

            // Data Signals
            ReadDataW  <= ReadDataM;
            ALUResultW <= ALUResultM;
            PCPlus4W   <= PCPlus4M;
            InstrW     <= InstrM;

            // Destination Register
            RD_W <= RD_M;
        end

    end

endmodule