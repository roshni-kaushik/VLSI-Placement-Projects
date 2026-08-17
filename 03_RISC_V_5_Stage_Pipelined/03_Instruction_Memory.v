module Instruction_Memory(

    input rst,
    input [31:0] A,

    output [31:0] RD

);

    //-------------------------------------
    // Instruction Memory (1024 x 32-bit)
    //-------------------------------------
    reg [31:0] mem [0:1023];

    //-------------------------------------
    // Read Instruction
    //-------------------------------------
    assign RD = (!rst) ? 32'd0 : mem[A[31:2]];

    //-------------------------------------
    // Load Program from HEX File
    //-------------------------------------
    initial
    begin
         $readmemh("C:/Users/roshn/Documents/Project_placement/RISC_V_5_Stage_Pipelined/memfile.hex",mem);
    end

endmodule