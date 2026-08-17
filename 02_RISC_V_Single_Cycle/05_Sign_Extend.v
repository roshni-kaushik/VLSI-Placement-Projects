module Sign_Extend (
    input  [31:0] In,
    input  [1:0]  ImmSrc,
    output [31:0] Imm_Ext
);

//==============================
// Immediate Type Encoding
//==============================
localparam ITYPE = 2'b00;
localparam STYPE = 2'b01;
localparam BTYPE = 2'b10;

//==============================
// Sign Extension
//==============================
assign Imm_Ext =
        (ImmSrc == ITYPE) ?
            {{20{In[31]}}, In[31:20]} :

        (ImmSrc == STYPE) ?
            {{20{In[31]}}, In[31:25], In[11:7]} :

        (ImmSrc == BTYPE) ?
            {{19{In[31]}},
              In[31],
              In[7],
              In[30:25],
              In[11:8],
              1'b0} :

        32'd0;

endmodule