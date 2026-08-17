module ALU_Decoder(

    input  [1:0] ALUOp,
    input  [2:0] funct3,
    input  [6:0] funct7,
    input  [6:0] op,

    output reg [3:0] ALUControl

);

    //-------------------------------------
    // ALU Operations
    //-------------------------------------
    localparam ADD = 4'b0000;
    localparam SUB = 4'b0001;
    localparam AND = 4'b0010;
    localparam OR  = 4'b0011;
    localparam XOR = 4'b0100;
    localparam SLT = 4'b0101;
    localparam SLL = 4'b0110;
    localparam SRL = 4'b0111;
    localparam SRA = 4'b1000;

    //-------------------------------------
    // ALUOp Encoding
    //-------------------------------------
    localparam LOAD_STORE = 2'b00;
    localparam BRANCH     = 2'b01;
    localparam ALU_INST   = 2'b10;

    //-------------------------------------
    // Instruction Opcode
    //-------------------------------------
    localparam RTYPE = 7'b0110011;

    //-------------------------------------
    // ALU Decoder
    //-------------------------------------
    always @(*)
    begin
        case (ALUOp)

            // Load / Store
            LOAD_STORE:
                ALUControl = ADD;

            // BEQ
            BRANCH:
                ALUControl = SUB;

            // R-Type / I-Type
            ALU_INST:
            begin
                case (funct3)

                    // ADD / ADDI / SUB
                    3'b000:
                    begin
                        if ((op == RTYPE) && funct7[5])
                            ALUControl = SUB;
                        else
                            ALUControl = ADD;
                    end

                    // SLL / SLLI
                    3'b001:
                        ALUControl = SLL;

                    // SLT / SLTI
                    3'b010:
                        ALUControl = SLT;

                    // XOR / XORI
                    3'b100:
                        ALUControl = XOR;

                    // SRL / SRLI / SRA / SRAI
                    3'b101:
                    begin
                        if (funct7[5])
                            ALUControl = SRA;
                        else
                            ALUControl = SRL;
                    end

                    // OR / ORI
                    3'b110:
                        ALUControl = OR;

                    // AND / ANDI
                    3'b111:
                        ALUControl = AND;

                    default:
                        ALUControl = ADD;

                endcase
            end

            default:
                ALUControl = ADD;

        endcase
    end

endmodule