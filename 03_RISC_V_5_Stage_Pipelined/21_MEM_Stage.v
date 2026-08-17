module MEM_Stage(

    input clk,

    //-------------------------------------
    // Control Signals
    //-------------------------------------
    input MemWriteM,

    //-------------------------------------
    // Data Signals
    //-------------------------------------
    input [31:0] ALUResultM,
    input [31:0] WriteDataM,

    //-------------------------------------
    // Output
    //-------------------------------------
    output [31:0] ReadDataM

);

    //-------------------------------------
    // Data Memory
    //-------------------------------------
    Data_Memory DMEM(

        .clk(clk),
        .WE(MemWriteM),

        .Addr(ALUResultM),
        .WD(WriteDataM),

        .RD(ReadDataM)

    );

endmodule