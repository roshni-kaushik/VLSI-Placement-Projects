module Register_File(

    input clk,
    input rst,
    input WE3,

    input  [4:0] A1,
    input  [4:0] A2,
    input  [4:0] A3,

    input  [31:0] WD3,

    output [31:0] RD1,
    output [31:0] RD2

);

    //-------------------------------------
    // 32 x 32-bit Register File
    //-------------------------------------
    reg [31:0] Register [0:31];

    //-------------------------------------
    // Write Port
    //-------------------------------------
    always @(posedge clk or negedge rst)
    begin
        if (!rst)
        begin
            // No reset required for registers.
            // Reads are forced to zero during reset.
        end
        else if (WE3 && (A3 != 5'd0))
        begin
            Register[A3] <= WD3;
        end
    end

    //-------------------------------------
    // Read Port 1
    //-------------------------------------
    assign RD1 = (!rst) ? 32'd0 :
                 (A1 == 5'd0) ? 32'd0 :
                 Register[A1];

    //-------------------------------------
    // Read Port 2
    //-------------------------------------
    assign RD2 = (!rst) ? 32'd0 :
                 (A2 == 5'd0) ? 32'd0 :
                 Register[A2];

endmodule