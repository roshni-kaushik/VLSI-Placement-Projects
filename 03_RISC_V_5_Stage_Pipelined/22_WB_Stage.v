module WB_Stage(

    //-------------------------------------
    // Control Signal
    //-------------------------------------
    input [1:0] ResultSrcW,

    //-------------------------------------
    // Data Signals
    //-------------------------------------
    input [31:0] ReadDataW,
    input [31:0] ALUResultW,
    input [31:0] PCPlus4W,

    //-------------------------------------
    // Output
    //-------------------------------------
    output [31:0] ResultW

);

    //-------------------------------------
    // Write-Back Result MUX
    //-------------------------------------
    Mux3 ResultMux(

        .a(ALUResultW),
        .b(ReadDataW),
        .c(PCPlus4W),

        .s(ResultSrcW),

        .d(ResultW)

    );

endmodule