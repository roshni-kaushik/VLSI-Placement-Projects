`timescale 1ns/1ps

module sync_w2r
#(
    parameter ADDRSIZE = 4
)
(
    input  wire                  rclk,
    input  wire                  rrst_n,

    input  wire [ADDRSIZE:0]     wptr,

    output reg  [ADDRSIZE:0]     rq2_wptr
);

    reg [ADDRSIZE:0] rq1_wptr;

    //------------------------------------------
    // Two Flip-Flop Synchronizer
    //------------------------------------------

    always @(posedge rclk or negedge rrst_n)
    begin
        if(!rrst_n)
        begin
            rq1_wptr <= 0;
            rq2_wptr <= 0;
        end
        else
        begin
            rq1_wptr <= wptr;
            rq2_wptr <= rq1_wptr;
        end
    end

endmodule