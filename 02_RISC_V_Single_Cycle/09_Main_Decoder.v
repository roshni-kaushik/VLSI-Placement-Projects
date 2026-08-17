module Main_Decoder(Op,RegWrite,ImmSrc,ALUSrc,MemWrite,ResultSrc,Branch,ALUOp);
    input [6:0]Op;
    output RegWrite,ALUSrc,MemWrite,ResultSrc,Branch;
    output [1:0]ImmSrc,ALUOp;

localparam LOAD   = 7'b0000011;
localparam STORE  = 7'b0100011;
localparam RTYPE  = 7'b0110011;
localparam BRANCH = 7'b1100011;
localparam ITYPE  = 7'b0010011;   // addi

assign RegWrite = (Op == LOAD || Op == RTYPE || Op == ITYPE);

assign ImmSrc = (Op == STORE)  ? 2'b01 :
                (Op == BRANCH) ? 2'b10 : 2'b00;

assign ALUSrc = (Op == LOAD || Op == STORE || Op == ITYPE);

assign MemWrite = (Op == STORE);

assign ResultSrc = (Op == LOAD);

assign Branch = (Op == BRANCH);

assign ALUOp = (Op == RTYPE)  ? 2'b10 :
               (Op == BRANCH) ? 2'b01 : 2'b00;

endmodule
