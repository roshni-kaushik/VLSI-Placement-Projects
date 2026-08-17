`timescale 1ns/1ps

module fifomem
#(
    parameter DATASIZE = 8,
    parameter ADDRSIZE = 4
)
(
    input  wire                     wclk,
    input  wire                     wclken,
    input  wire                     wfull,

    input  wire [ADDRSIZE-1:0]      waddr,
    input  wire [ADDRSIZE-1:0]      raddr,

    input  wire [DATASIZE-1:0]      wdata,

    output wire [DATASIZE-1:0]      rdata
);

    //---------------------------------------------------
    // Memory Declaration
    //---------------------------------------------------

    reg [DATASIZE-1:0] mem [0:(1<<ADDRSIZE)-1];

    //---------------------------------------------------
    // Write Logic
    //---------------------------------------------------

    always @(posedge wclk)
    begin
        if(wclken && !wfull)
            mem[waddr] <= wdata;
    end

    //---------------------------------------------------
    // Read Logic
    //---------------------------------------------------

    assign rdata = mem[raddr];

endmodule