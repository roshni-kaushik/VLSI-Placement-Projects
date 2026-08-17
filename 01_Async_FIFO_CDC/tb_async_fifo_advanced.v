`timescale 1ns/1ps

module tb_async_fifo_advanced;

parameter DATASIZE = 8;
parameter ADDRSIZE = 4;

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

//---------------------------------------------------------
// DUT
//---------------------------------------------------------

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

//---------------------------------------------------------
// Clock Generation
//---------------------------------------------------------

initial
begin
    wclk = 0;
    forever #5 wclk = ~wclk;      //100 MHz
end

initial
begin
    rclk = 0;
    forever #7 rclk = ~rclk;      //71 MHz
end

//---------------------------------------------------------
// Dump
//---------------------------------------------------------

initial
begin
    $dumpfile("fifo_advanced.vcd");
    $dumpvars(0,tb_async_fifo_advanced);
end

//---------------------------------------------------------
// Test
//---------------------------------------------------------

integer i;

initial
begin

    wrst_n = 0;
    rrst_n = 0;
    winc   = 0;
    rinc   = 0;
    wdata  = 0;

    #30;

    wrst_n = 1;
    rrst_n = 1;

    //-----------------------------------------------------
    // TEST-1 : Fill FIFO
    //-----------------------------------------------------

    $display("\nTEST1 : Filling FIFO\n");

    for(i=0;i<16;i=i+1)
    begin
        @(posedge wclk);

        if(!wfull)
        begin
            winc  = 1;
            wdata = i;

            $display("WRITE %0d",i);
        end
    end

    @(posedge wclk);
    winc = 0;

    //-----------------------------------------------------
    // Wait for synchronization
    //-----------------------------------------------------

    repeat(4) @(posedge rclk);

    //-----------------------------------------------------
    // TEST-2 : Write when FULL
    //-----------------------------------------------------

    $display("\nTEST2 : Extra Write\n");

    @(posedge wclk);

    winc = 1;
    wdata = 8'hAA;

    @(posedge wclk);

    winc = 0;

    if(wfull)
        $display("PASS : FULL asserted");
    else
        $display("FAIL : FULL not asserted");

    //-----------------------------------------------------
    // TEST-3 : Read Everything
    //-----------------------------------------------------

    $display("\nTEST3 : Reading FIFO\n");

    while(!rempty)
    begin

        @(posedge rclk);

        rinc = 1;

        #1;

        $display("READ %h",rdata);

    end

    rinc = 0;

    //-----------------------------------------------------
    // TEST-4 : Read when EMPTY
    //-----------------------------------------------------

    @(posedge rclk);

    rinc = 1;

    @(posedge rclk);

    rinc = 0;

    if(rempty)
        $display("PASS : EMPTY asserted");
    else
        $display("FAIL : EMPTY not asserted");

    //-----------------------------------------------------
    // TEST-5 : Simultaneous Read & Write
    //-----------------------------------------------------

    $display("\nTEST4 : Simultaneous Read/Write\n");

    fork

    begin
        for(i=0;i<10;i=i+1)
        begin
            @(posedge wclk);

            if(!wfull)
            begin
                winc = 1;
                wdata = i+50;
            end

            @(negedge wclk);

            winc = 0;
        end
    end

    begin
        repeat(3) @(posedge rclk);

        for(i=0;i<10;i=i+1)
        begin
            @(posedge rclk);

            if(!rempty)
                rinc = 1;

            @(negedge rclk);

            rinc = 0;
        end
    end

    join

    #100;

    $display("\nSimulation Finished\n");

    $finish;

end

endmodule