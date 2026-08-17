module ALU_Decoder(
    input  [1:0] ALUOp,
    input  [2:0] funct3,
    input  [6:0] funct7,
    input  [6:0] op,
    output [2:0] ALUControl
);

//==============================
// ALU Operations
//==============================
localparam ADD = 3'b000;
localparam SUB = 3'b001;
localparam AND = 3'b010;
localparam OR  = 3'b011;
localparam SLT = 3'b101;

//==============================
// Instruction Types
//==============================
localparam LOAD   = 2'b00;
localparam BRANCH = 2'b01;
localparam RTYPE  = 2'b10;

//==============================
// R-type ADD/SUB detection
//==============================
wire is_sub;

assign is_sub = ({op[5], funct7[5]} == 2'b11);

//==============================
// ALU Decoder
//==============================
assign ALUControl =
        (ALUOp == LOAD)                     ? ADD :
        (ALUOp == BRANCH)                   ? SUB :

        ((ALUOp == RTYPE) && (funct3 == 3'b000) && is_sub) ? SUB :
        ((ALUOp == RTYPE) && (funct3 == 3'b000))           ? ADD :
        ((ALUOp == RTYPE) && (funct3 == 3'b010))           ? SLT :
        ((ALUOp == RTYPE) && (funct3 == 3'b110))           ? OR  :
        ((ALUOp == RTYPE) && (funct3 == 3'b111))           ? AND :
                                                             ADD;

endmodule