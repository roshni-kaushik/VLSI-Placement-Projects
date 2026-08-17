module PC_Target_Adder(

    input  [31:0] PC,
    input  [31:0] ImmExt,

    output [31:0] PCTarget

);

    //-------------------------------------
    // Branch / Jump Target Address
    //-------------------------------------
    assign PCTarget = PC + ImmExt;

endmodule