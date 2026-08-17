module Sign_Extend(

    input  [31:0] In,
    input  [2:0]  ImmSrc,

    output reg [31:0] Imm_Ext

);

    //-------------------------------------
    // Immediate Type Encoding
    //-------------------------------------
    localparam ITYPE = 3'b000;
    localparam STYPE = 3'b001;
    localparam BTYPE = 3'b010;
    localparam JTYPE = 3'b100;

    //-------------------------------------
    // Immediate Generator
    //-------------------------------------
    always @(*)
    begin
        case (ImmSrc)

            // I-Type (addi, lw)
            ITYPE:
                Imm_Ext = {{20{In[31]}}, In[31:20]};

            // S-Type (sw)
            STYPE:
                Imm_Ext = {{20{In[31]}}, In[31:25], In[11:7]};

            // B-Type (beq)
            BTYPE:
                Imm_Ext = {{19{In[31]}},
                           In[31],
                           In[7],
                           In[30:25],
                           In[11:8],
                           1'b0};

            // J-Type (jal)
            JTYPE:
                Imm_Ext = {{11{In[31]}},
                           In[31],
                           In[19:12],
                           In[20],
                           In[30:21],
                           1'b0};

            // Default
            default:
                Imm_Ext = 32'd0;

        endcase
    end

endmodule