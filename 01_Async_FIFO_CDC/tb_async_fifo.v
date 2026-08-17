`timescale 1ns/1ps

module tb_async_fifo;

parameter DATASIZE = 8;
parameter ADDRSIZE = 4;

//--------------------------------------
// DUT Signals
//--------------------------------------

reg wclk;
reg rclk;

reg wrst_n;
reg rrst_n;

reg winc;
reg rinc;

reg [DATASIZE-1:0] wdata;

wire [DATASIZE-1:0] rdata;

wire wfull;
wire rempty;

//--------------------------------------
// DUT
//--------------------------------------

async_fifo
#(
    .DATASIZE(DATASIZE),
    .ADDRSIZE(ADDRSIZE)
)
dut
(
    .wclk(wclk),
    .wrst_n(wrst_n),
    .winc(winc),
    .wdata(wdata),
    .wfull(wfull),

    .rclk(rclk),
    .rrst_n(rrst_n),
    .rinc(rinc),
    .rdata(rdata),
    .rempty(rempty)
);

//--------------------------------------
// Write Clock (100 MHz)
//--------------------------------------

initial
begin
    wclk = 0;
    forever #5 wclk = ~wclk;
end

//--------------------------------------
// Read Clock (71.4 MHz)
//--------------------------------------

initial
begin
    rclk = 0;
    forever #7 rclk = ~rclk;
end

//--------------------------------------
// Dump Waves
//--------------------------------------

initial
begin
    $dumpfile("fifo.vcd");
    $dumpvars(0,tb_async_fifo);
end

//--------------------------------------
// Test Sequence
//--------------------------------------

integer i;

initial
begin

    wrst_n = 0;
    rrst_n = 0;

    winc = 0;
    rinc = 0;

    wdata = 0;

    #30;

    wrst_n = 1;
    rrst_n = 1;

    //----------------------------------
    // WRITE 8 VALUES
    //----------------------------------

    for(i=0;i<8;i=i+1)
    begin

        @(posedge wclk);

        if(!wfull)
        begin
            winc = 1;
            wdata = i + 8'h11;

            $display(
            "[WRITE] Time=%0t Data=%h",
            $time,
            wdata
            );
        end

    end

    @(posedge wclk);
    winc = 0;

//----------------------------------
// Wait for synchronization
//----------------------------------

repeat(3) @(posedge rclk);

//----------------------------------
// READ 8 VALUES
//----------------------------------

for(i=0;i<8;i=i+1)
begin

    @(posedge rclk);

    if(!rempty)
    begin
        rinc = 1;
    end

    @(posedge rclk);

    rinc = 0;

    #1;

    $display(
        "[READ ] Time=%0t Data=%h",
        $time,
        rdata
    );

end

    @(posedge rclk);
    rinc = 0;

    #100;

    $finish;

end

endmodule