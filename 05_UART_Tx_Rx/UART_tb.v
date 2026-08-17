`timescale 1ns/1ps

module UART_tb;

    // Inputs
    reg clk;
    reg rst;
    reg tx_st;
    reg [7:0] tx_data;

    // Outputs
    wire tx_busy;
    wire tx_serial;
    wire done;
    wire [7:0] rx_data;

    //-------------------------------------------------
    // Clock Generation (50 MHz)
    //-------------------------------------------------
    initial begin
        clk = 0;
        forever #10 clk = ~clk;      // 20 ns period
    end

    //-------------------------------------------------
    // UART Transmitter
    //-------------------------------------------------
    UART_Tx uut_tx (
        .clk(clk),
        .rst(rst),
        .tx_st(tx_st),
        .tx_data(tx_data),
        .tx_busy(tx_busy),
        .tx_serial(tx_serial)
    );

    //-------------------------------------------------
    // UART Receiver
    //-------------------------------------------------
    UART_Rx uut_rx (
        .clk(clk),
        .rst(rst),
        .rx_serial(tx_serial),
        .done(done),
        .rx_data(rx_data)
    );

    //-------------------------------------------------
    // Dump Waveform
    //-------------------------------------------------
    initial begin
        $dumpfile("uart.vcd");
        $dumpvars(0, UART_tb);
    end

    //-------------------------------------------------
    // Test Stimulus
    //-------------------------------------------------
    initial begin

        // Initialize
        rst     = 1;
        tx_st   = 0;
        tx_data = 8'h00;

        // Reset
        #100;
        rst = 0;

        //-------------------------------------------------
        // First Transmission : A5
        //-------------------------------------------------
        #100;

        tx_data = 8'hA5;
        tx_st   = 1;

        #20;
        tx_st   = 0;

        // Wait enough time for one UART frame
        #120000;

        $display("--------------------------------");
        $display("Time = %0t", $time);
        $display("Transmitted = %h", 8'hA5);
        $display("Received    = %h", rx_data);

        //-------------------------------------------------
        // Second Transmission : 3C
        //-------------------------------------------------
        tx_data = 8'h3C;
        tx_st   = 1;

        #20;
        tx_st   = 0;

        // Wait enough time for second frame
        #120000;

        $display("--------------------------------");
        $display("Time = %0t", $time);
        $display("Transmitted = %h", 8'h3C);
        $display("Received    = %h", rx_data);

        //-------------------------------------------------
        // Finish
        //-------------------------------------------------
        #1000;

        $display("--------------------------------");
        $display("UART Simulation Completed");
        $display("--------------------------------");

        $finish;

    end

endmodule