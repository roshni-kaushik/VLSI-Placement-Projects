module IF_ID(

    input clk,
    input rst,

    //-------------------------------------
    // Control Signals
    //-------------------------------------
    input StallD,
    input FlushD,

    //-------------------------------------
    // Inputs from IF Stage
    //-------------------------------------
    input  [31:0] InstrF,
    input  [31:0] PCF,
    input  [31:0] PCPlus4F,

    //-------------------------------------
    // Outputs to ID Stage
    //-------------------------------------
    output reg [31:0] InstrD,
    output reg [31:0] PCD,
    output reg [31:0] PCPlus4D

);

    //-------------------------------------
    // IF/ID Pipeline Register
    //-------------------------------------
    always @(posedge clk or negedge rst)
    begin

        //---------------------------------
        // Asynchronous Active-Low Reset
        //---------------------------------
        if (!rst)
        begin
            InstrD   <= 32'd0;
            PCD      <= 32'd0;
            PCPlus4D <= 32'd0;
        end

        //---------------------------------
        // Flush Pipeline Register
        //---------------------------------
        else if (FlushD)
        begin
            InstrD   <= 32'd0;
            PCD      <= 32'd0;
            PCPlus4D <= 32'd0;
        end

        //---------------------------------
        // Update Pipeline Register
        //---------------------------------
        else if (!StallD)
        begin
            InstrD   <= InstrF;
            PCD      <= PCF;
            PCPlus4D <= PCPlus4F;
        end

        //---------------------------------
        // Stall
        // Hold previous values
        //---------------------------------

    end

endmodule