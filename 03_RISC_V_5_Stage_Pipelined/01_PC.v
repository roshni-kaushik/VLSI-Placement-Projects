module PC(

    input clk,
    input rst,
    input PCWrite,
    input [31:0] PC_Next,

    output reg [31:0] PC

);

//-------------------------------------
// Program Counter Register
//-------------------------------------

always @(posedge clk or negedge rst)
begin
    if (!rst)
        PC <= 32'd0;

    else if (PCWrite)
        PC <= PC_Next;

    // Hold PC during stall
end

endmodule