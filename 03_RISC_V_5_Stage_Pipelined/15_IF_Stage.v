module IF_Stage(

    input clk,
    input rst,

    //-------------------------------------
    // Control Signals
    //-------------------------------------
    input PCWrite,
    input PCSrcE,

    //-------------------------------------
    // Branch / Jump Target
    //-------------------------------------
    input [31:0] PCTargetE,

    //-------------------------------------
    // Outputs to IF/ID Register
    //-------------------------------------
    output [31:0] InstrF,
    output [31:0] PCF,
    output [31:0] PCPlus4F

);

    wire [31:0] PCNext;

    //-------------------------------------
    // Next PC Selection
    //-------------------------------------
    Mux2 PCMux(

        .a(PCPlus4F),
        .b(PCTargetE),
        .s(PCSrcE),

        .c(PCNext)

    );

    //-------------------------------------
    // Program Counter
    //-------------------------------------
    PC ProgramCounter(

        .clk(clk),
        .rst(rst),

        .PCWrite(PCWrite),
        .PC_Next(PCNext),

        .PC(PCF)

    );

    //-------------------------------------
    // Instruction Memory
    //-------------------------------------
    Instruction_Memory IMEM(

        .rst(rst),

        .A(PCF),
        .RD(InstrF)

    );

    //-------------------------------------
    // PC + 4 Adder
    //-------------------------------------
    PC_Adder PCPlus4Adder(

        .a(PCF),
        .b(32'd4),

        .c(PCPlus4F)

    );

endmodule