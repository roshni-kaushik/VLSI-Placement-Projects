`timescale 1ns/1ps

module tb;

    //-------------------------------------
    // Testbench Signals
    //-------------------------------------
    reg clk = 0;
    reg rst;

    //-------------------------------------
    // Clock Generation (100 ns Period)
    //-------------------------------------
    always #50 clk = ~clk;

    //-------------------------------------
    // Reset Sequence
    //-------------------------------------
    initial begin

        rst = 1'b0;

        #200;
        rst = 1'b1;

        #2000;

        $finish;

    end

    //-------------------------------------
    // Dump Waveforms
    //-------------------------------------
    initial begin

        $dumpfile("dump.vcd");
        $dumpvars(0, tb);

    end

    //-------------------------------------
    // DUT
    //-------------------------------------
    Pipeline_Top dut(

        .clk(clk),
        .rst(rst)

    );

endmodule