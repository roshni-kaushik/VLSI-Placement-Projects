module Control_Unit_Top(
    input  [6:0] Op,
    input  [2:0] funct3,
    input  [6:0] funct7,

    output RegWrite,
    output ALUSrc,
    output MemWrite,
    output ResultSrc,
    output Branch,
    output [1:0] ImmSrc,
    output [2:0] ALUControl
);

wire [1:0] ALUOp;

//---------------------------
// Main Decoder
//---------------------------
Main_Decoder main_decoder(
    .Op(Op),
    .RegWrite(RegWrite),
    .ImmSrc(ImmSrc),
    .ALUSrc(ALUSrc),
    .MemWrite(MemWrite),
    .ResultSrc(ResultSrc),
    .Branch(Branch),
    .ALUOp(ALUOp)
);

//---------------------------
// ALU Decoder
//---------------------------
ALU_Decoder alu_decoder(
    .ALUOp(ALUOp),
    .funct3(funct3),
    .funct7(funct7),
    .op(Op),
    .ALUControl(ALUControl)
);

endmodule