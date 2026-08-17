module Control_Unit_Top(

    input  [6:0] Op,
    input  [2:0] funct3,
    input  [6:0] funct7,

    output RegWrite,
    output ALUSrc,
    output MemWrite,
    output [1:0] ResultSrc,
    output Branch,
    output Jump,
    output [2:0] ImmSrc,
    output [3:0] ALUControl

);

    //-------------------------------------
    // Internal Signals
    //-------------------------------------
    wire [1:0] ALUOp;

    //-------------------------------------
    // Main Decoder
    //-------------------------------------
    Main_Decoder MainDecoder(

        .Op(Op),

        .RegWrite(RegWrite),
        .ImmSrc(ImmSrc),
        .ALUSrc(ALUSrc),
        .MemWrite(MemWrite),
        .ResultSrc(ResultSrc),
        .Branch(Branch),
        .Jump(Jump),

        .ALUOp(ALUOp)

    );

    //-------------------------------------
    // ALU Decoder
    //-------------------------------------
    ALU_Decoder ALUDecoder(

        .ALUOp(ALUOp),
        .funct3(funct3),
        .funct7(funct7),
        .op(Op),

        .ALUControl(ALUControl)

    );

endmodule