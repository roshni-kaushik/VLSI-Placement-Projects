module PC_Target_Adder(
    input  [31:0] PC,
    input  [31:0] ImmExt,
    output [31:0] PCTarget
);

// Calculate branch target address
assign PCTarget = PC + ImmExt;

endmodule