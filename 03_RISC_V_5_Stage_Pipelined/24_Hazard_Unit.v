module Hazard_Unit(

    //-------------------------------------
    // Decode Stage
    //-------------------------------------
    input [4:0] RS1_D,
    input [4:0] RS2_D,

    //-------------------------------------
    // Execute Stage
    //-------------------------------------
    input [4:0] RD_E,
    input [1:0] ResultSrcE,

    //-------------------------------------
    // Branch / Jump Taken
    //-------------------------------------
    input PCSrcE,

    //-------------------------------------
    // Outputs
    //-------------------------------------
    output PCWrite,
    output StallD,
    output FlushE);

    //-------------------------------------
    // Load-Use Hazard Detection
    //-------------------------------------
    wire LoadUseHazard;

    assign LoadUseHazard =
            (ResultSrcE == 2'b01) &&
            (RD_E != 5'd0) &&
            ((RD_E == RS1_D) || (RD_E == RS2_D));

    //-------------------------------------
    // Control Signals
    //-------------------------------------
    assign PCWrite = ~LoadUseHazard;

    assign StallD = LoadUseHazard;

    assign FlushE = LoadUseHazard | PCSrcE;

endmodule