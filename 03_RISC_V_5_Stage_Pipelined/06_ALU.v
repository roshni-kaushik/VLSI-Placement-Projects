module ALU(

    input  [31:0] A,
    input  [31:0] B,
    input  [3:0]  ALUControl,

    output reg [31:0] Result,
    output Zero

);

    //-------------------------------------
    // ALU Operation Encoding
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
    // Shared Adder (ADD / SUB)
    //-------------------------------------
    wire [31:0] Sum;

    assign Sum = (ALUControl == SUB) ?
                 (A + (~B + 32'd1)) :
                 (A + B);

    //-------------------------------------
    // ALU Operations
    //-------------------------------------
    always @(*)
    begin
        case (ALUControl)

            ADD : Result = Sum;

            SUB : Result = Sum;

            AND : Result = A & B;

            OR  : Result = A | B;

            XOR : Result = A ^ B;

            // Signed Less Than
            SLT : Result = ($signed(A) < $signed(B)) ? 32'd1 : 32'd0;

            // Shift Left Logical
            SLL : Result = A << B[4:0];

            // Shift Right Logical
            SRL : Result = A >> B[4:0];

            // Shift Right Arithmetic
            SRA : Result = $signed(A) >>> B[4:0];

            default : Result = 32'd0;

        endcase
    end

    //-------------------------------------
    // Zero Flag
    //-------------------------------------
    assign Zero = (Result == 32'd0);

endmodule