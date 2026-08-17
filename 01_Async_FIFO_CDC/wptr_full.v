`timescale 1ns/1ps

module wptr_full
#(
    parameter ADDRSIZE = 4
)
(
    input  wire                  wclk,
    input  wire                  wrst_n,
    input  wire                  winc,

    input  wire [ADDRSIZE:0]     wq2_rptr,

    output reg                   wfull,

    output reg  [ADDRSIZE:0]     wptr,
    output reg  [ADDRSIZE:0]     wbin,

    output wire [ADDRSIZE-1:0]   waddr
);

    //------------------------------------------
    // Next Pointer Values
    //------------------------------------------

    wire [ADDRSIZE:0] wbinnext;
    wire [ADDRSIZE:0] wgraynext;

    wire              wfull_val;

    //------------------------------------------
    // Memory Address
    //------------------------------------------

    assign waddr = wbin[ADDRSIZE-1:0];

    //------------------------------------------
    // Binary Pointer Increment
    //------------------------------------------

    assign wbinnext = wbin + (winc & ~wfull);

    //------------------------------------------
    // Binary → Gray
    //------------------------------------------

    assign wgraynext = (wbinnext >> 1) ^ wbinnext;

        //------------------------------------------
    // Full Detection
    //------------------------------------------

    assign wfull_val =
        (wgraynext ==
        {
            ~wq2_rptr[ADDRSIZE:ADDRSIZE-1],
             wq2_rptr[ADDRSIZE-2:0]
        });

    //------------------------------------------
    // Pointer Registers
    //------------------------------------------

    always @(posedge wclk or negedge wrst_n)
    begin
        if(!wrst_n)
        begin
            wbin  <= 0;
            wptr  <= 0;
            wfull <= 1'b0;
        end
        else
        begin
            wbin  <= wbinnext;
            wptr  <= wgraynext;
            wfull <= wfull_val;
        end
    end

endmodule