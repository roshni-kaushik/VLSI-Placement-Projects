`timescale 1ns/1ps

module sync_r2w
#(
    parameter ADDRSIZE = 4
)
(
    input  wire                  wclk,
    input  wire                  wrst_n,

    input  wire [ADDRSIZE:0]     rptr,

    output reg  [ADDRSIZE:0]     wq2_rptr
);

    reg [ADDRSIZE:0] wq1_rptr;

    //------------------------------------------
    // Two Flip-Flop Synchronizer
    //------------------------------------------

    always @(posedge wclk or negedge wrst_n)
    begin
        if(!wrst_n)
        begin
            wq1_rptr <= 0;
            wq2_rptr <= 0;
        end
        else
        begin
            wq1_rptr <= rptr;
            wq2_rptr <= wq1_rptr;
        end
    end

endmodule