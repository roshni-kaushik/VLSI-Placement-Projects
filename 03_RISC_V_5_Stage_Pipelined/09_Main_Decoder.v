module Main_Decoder(

    input  [6:0] Op,

    output RegWrite,
    output [2:0] ImmSrc,
    output ALUSrc,
    output MemWrite,
    output [1:0] ResultSrc,
    output Branch,
    output Jump,
    output [1:0] ALUOp

);

    //-------------------------------------
    // Opcode Encoding
    //-------------------------------------
    localparam LOAD   = 7'b0000011;
    localparam STORE  = 7'b0100011;
    localparam RTYPE  = 7'b0110011;
    localparam BRANCH = 7'b1100011;
    localparam ITYPE  = 7'b0010011;
    localparam JAL    = 7'b1101111;

    //-------------------------------------
    // Register Write Enable
    //-------------------------------------
    assign RegWrite = (Op == LOAD  ||
                       Op == RTYPE ||
                       Op == ITYPE ||
                       Op == JAL);

    //-------------------------------------
    // Immediate Source
    //-------------------------------------
    // 000 -> I-Type
    // 001 -> S-Type
    // 010 -> B-Type
    // 100 -> J-Type
    //-------------------------------------
    assign ImmSrc = (Op == STORE)  ? 3'b001 :
                    (Op == BRANCH) ? 3'b010 :
                    (Op == JAL)    ? 3'b100 :
                                     3'b000;

    //-------------------------------------
    // ALU Source
    //-------------------------------------
    assign ALUSrc = (Op == LOAD  ||
                     Op == STORE ||
                     Op == ITYPE ||
                     Op == JAL);

    //-------------------------------------
    // Memory Write
    //-------------------------------------
    assign MemWrite = (Op == STORE);

    //-------------------------------------
    // Result Source
    //-------------------------------------
    // 00 -> ALU Result
    // 01 -> Data Memory
    // 10 -> PC + 4 (JAL)
    //-------------------------------------
    assign ResultSrc = (Op == LOAD) ? 2'b01 :
                       (Op == JAL ) ? 2'b10 :
                                      2'b00;

    //-------------------------------------
    // Branch Control
    //-------------------------------------
    assign Branch = (Op == BRANCH);

    //-------------------------------------
    // Jump Control
    //-------------------------------------
    assign Jump = (Op == JAL);

    //-------------------------------------
    // ALU Operation
    //-------------------------------------
    // 00 -> ADD
    // 01 -> SUB (BEQ)
    // 10 -> Decode funct3/funct7
    //-------------------------------------
    assign ALUOp = (Op == RTYPE || Op == ITYPE) ? 2'b10 :
                   (Op == BRANCH)               ? 2'b01 :
                                                  2'b00;

endmodule