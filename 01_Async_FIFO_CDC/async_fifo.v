`timescale 1ns/1ps

module async_fifo
#(
    parameter DATASIZE = 8,
    parameter ADDRSIZE = 4
)
(
    // Write Interface
    input  wire                  wclk,
    input  wire                  wrst_n,
    input  wire                  winc,
    input  wire [DATASIZE-1:0]   wdata,
    output wire                  wfull,

    // Read Interface
    input  wire                  rclk,
    input  wire                  rrst_n,
    input  wire                  rinc,
    output wire [DATASIZE-1:0]   rdata,
    output wire                  rempty
);

    //----------------------------------------
    // Internal Signals
    //----------------------------------------

    wire [ADDRSIZE:0] wptr;
    wire [ADDRSIZE:0] rptr;

    wire [ADDRSIZE:0] wbin;
    wire [ADDRSIZE:0] rbin;

    wire [ADDRSIZE-1:0] waddr;
    wire [ADDRSIZE-1:0] raddr;

    wire [ADDRSIZE:0] wq2_rptr;
    wire [ADDRSIZE:0] rq2_wptr;

        fifomem
    #(
        .DATASIZE(DATASIZE),
        .ADDRSIZE(ADDRSIZE)
    )
    u_mem
    (
        .wclk(wclk),
        .wclken(winc),
        .wfull(wfull),

        .waddr(waddr),
        .raddr(raddr),

        .wdata(wdata),
        .rdata(rdata)
    );

        sync_r2w
    #(
        .ADDRSIZE(ADDRSIZE)
    )
    u_sync_r2w
    (
        .wclk(wclk),
        .wrst_n(wrst_n),

        .rptr(rptr),

        .wq2_rptr(wq2_rptr)
    );

        sync_w2r
    #(
        .ADDRSIZE(ADDRSIZE)
    )
    u_sync_w2r
    (
        .rclk(rclk),
        .rrst_n(rrst_n),

        .wptr(wptr),

        .rq2_wptr(rq2_wptr)
    );

        wptr_full
    #(
        .ADDRSIZE(ADDRSIZE)
    )
    u_wptr
    (
        .wclk(wclk),
        .wrst_n(wrst_n),
        .winc(winc),

        .wq2_rptr(wq2_rptr),

        .wfull(wfull),

        .wptr(wptr),
        .wbin(wbin),

        .waddr(waddr)
    );

        rptr_empty
    #(
        .ADDRSIZE(ADDRSIZE)
    )
    u_rptr
    (
        .rclk(rclk),
        .rrst_n(rrst_n),
        .rinc(rinc),

        .rq2_wptr(rq2_wptr),

        .rempty(rempty),

        .rptr(rptr),
        .rbin(rbin),

        .raddr(raddr)
    );

endmodule