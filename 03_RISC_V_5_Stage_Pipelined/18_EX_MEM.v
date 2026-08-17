module EX_MEM(

    input clk,
    input rst,

    //-------------------------------------
    // Control Signals
    //-------------------------------------
    input RegWriteE,
    input MemWriteE,
    input [1:0] ResultSrcE,

    //-------------------------------------
    // Data Signals
    //-------------------------------------
    input [31:0] ALUResultE,
    input [31:0] WriteDataE,
    input [31:0] PCPlus4E,

    //-------------------------------------
    // Debug Instruction
    //-------------------------------------
    input [31:0] InstrE,

    //-------------------------------------
    // Destination Register
    //-------------------------------------
    input [4:0] RD_E,

    //-------------------------------------
    // Outputs to MEM Stage
    //-------------------------------------
    output reg RegWriteM,
    output reg MemWriteM,
    output reg [1:0] ResultSrcM,

    output reg [31:0] ALUResultM,
    output reg [31:0] WriteDataM,
    output reg [31:0] PCPlus4M,

    //-------------------------------------
    // Debug Instruction
    //-------------------------------------
    output reg [31:0] InstrM,

    //-------------------------------------
    // Destination Register
    //-------------------------------------
    output reg [4:0] RD_M

);

    //-------------------------------------
    // EX/MEM Pipeline Register
    //-------------------------------------
    always @(posedge clk or negedge rst)
    begin

        //---------------------------------
        // Asynchronous Active-Low Reset
        //---------------------------------
        if (!rst)
        begin
            // Control Signals
            RegWriteM  <= 1'b0;
            MemWriteM  <= 1'b0;
            ResultSrcM <= 2'b00;

            // Data Signals
            ALUResultM <= 32'd0;
            WriteDataM <= 32'd0;
            PCPlus4M   <= 32'd0;
            InstrM     <= 32'd0;

            // Destination Register
            RD_M <= 5'd0;
        end

        //---------------------------------
        // Normal Operation
        //---------------------------------
        else
        begin
            // Control Signals
            RegWriteM  <= RegWriteE;
            MemWriteM  <= MemWriteE;
            ResultSrcM <= ResultSrcE;

            // Data Signals
            ALUResultM <= ALUResultE;
            WriteDataM <= WriteDataE;
            PCPlus4M   <= PCPlus4E;
            InstrM     <= InstrE;

            // Destination Register
            RD_M <= RD_E;
        end

    end

endmodule