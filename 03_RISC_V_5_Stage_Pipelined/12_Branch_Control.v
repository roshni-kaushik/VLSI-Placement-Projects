module Branch_Control(

    input Branch,
    input Zero,

    output PCSrc);

    //-------------------------------------
    // Branch Decision Logic
    //-------------------------------------
    // BEQ:
    // Branch is taken only when
    // Branch = 1 and Zero = 1.
    //-------------------------------------
    assign PCSrc = Branch & Zero;

endmodule