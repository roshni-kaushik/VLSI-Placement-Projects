module Forwarding_Unit(

    // Source Registers in EX Stage
    input [4:0] RS1_E,
    input [4:0] RS2_E,

    // Destination Registers
    input [4:0] RD_M,
    input [4:0] RD_W,

    // Register Write Enables
    input RegWriteM,
    input RegWriteW,

    // Forwarding Control Outputs
    output reg [1:0] ForwardAE,
    output reg [1:0] ForwardBE

);

//-------------------------------------
// Forwarding Logic
//-------------------------------------
always @(*) begin

    //-------------------------
    // Default
    //-------------------------
    ForwardAE = 2'b00;
    ForwardBE = 2'b00;

    //-------------------------
    // Source A
    //-------------------------
    if (RegWriteM && (RD_M != 5'd0) && (RD_M == RS1_E))
        ForwardAE = 2'b10;

    else if (RegWriteW && (RD_W != 5'd0) && (RD_W == RS1_E))
        ForwardAE = 2'b01;

    //-------------------------
    // Source B
    //-------------------------
    if (RegWriteM && (RD_M != 5'd0) && (RD_M == RS2_E))
        ForwardBE = 2'b10;

    else if (RegWriteW && (RD_W != 5'd0) && (RD_W == RS2_E))
        ForwardBE = 2'b01;

end

endmodule