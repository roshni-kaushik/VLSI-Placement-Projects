module Branch_Control(
    input  Branch,
    input  Zero,
    output PCSrc
);

// Branch is taken only when
// instruction is a branch AND
// ALU comparison result is zero

assign PCSrc = Branch && Zero;

endmodule