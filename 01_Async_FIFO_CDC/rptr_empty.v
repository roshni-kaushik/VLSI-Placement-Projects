`timescale 1ns/1ps

module rptr_empty
#(
    parameter ADDRSIZE = 4
)
(
    input  wire                  rclk,
    input  wire                  rrst_n,
    input  wire                  rinc,

    input  wire [ADDRSIZE:0]     rq2_wptr,

    output reg                   rempty,

    output reg  [ADDRSIZE:0]     rptr,
    output reg  [ADDRSIZE:0]     rbin,

    output wire [ADDRSIZE-1:0]   raddr
);

    //------------------------------------------
    // Next Pointer Values
    //------------------------------------------

    wire [ADDRSIZE:0] rbinnext;
    wire [ADDRSIZE:0] rgraynext;

    wire              rempty_val;

    //------------------------------------------
    // Memory Address
    //------------------------------------------

    assign raddr = rbin[ADDRSIZE-1:0];

    //------------------------------------------
    // Binary Pointer Increment
    //------------------------------------------

    assign rbinnext = rbin + (rinc & ~rempty);

    //------------------------------------------
    // Binary → Gray Conversion
    //------------------------------------------

    assign rgraynext = (rbinnext >> 1) ^ rbinnext;

    //------------------------------------------
    // Empty Detection
    //------------------------------------------

    assign rempty_val = (rgraynext == rq2_wptr);

    //------------------------------------------
    // Pointer Registers
    //------------------------------------------

    always @(posedge rclk or negedge rrst_n)
    begin
        if(!rrst_n)
        begin
            rbin   <= 0;
            rptr   <= 0;
            rempty <= 1'b1;
        end
        else
        begin
            rbin   <= rbinnext;
            rptr   <= rgraynext;
            rempty <= rempty_val;
        end
    end

endmodule