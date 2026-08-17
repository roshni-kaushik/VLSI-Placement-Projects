module PC_Adder(

    input  [31:0] a,
    input  [31:0] b,

    output [31:0] c

);

//---------------
// PC Increment 
//---------------
assign c = a + b;

endmodule