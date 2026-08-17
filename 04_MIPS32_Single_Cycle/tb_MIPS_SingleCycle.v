`timescale 1ns/1ps

module tb_MIPS_SingleCycle;

    reg clk;
    reg reset;

    wire halt;

    // Instantiate DUT
    MIPS_SingleCycle DUT(
        .clk(clk),
        .reset(reset),
        .halt(halt)
    );

    //-------------------------------------------------------
    // Clock Generation (10 ns period)
    //-------------------------------------------------------
    initial
    begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    //-------------------------------------------------------
    // Reset
    //-------------------------------------------------------
    initial
    begin
        reset = 1;
        #20;
        reset = 0;
    end

    //-------------------------------------------------------
    // VCD Dump
    //-------------------------------------------------------
    initial
    begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_MIPS_SingleCycle);
    end

    //-------------------------------------------------------
    // Monitor
    //-------------------------------------------------------
    initial
    begin
        $display("---------------------------------------------------------------");
        $display(" Time\tPC\t\tInstruction\tALUResult\tHalt");
        $display("---------------------------------------------------------------");

        $monitor("%4t\t%h\t%h\t%h\t%b",
                 $time,
                 DUT.pc_current,
                 DUT.instruction,
                 DUT.ALUResult,
                 halt);
    end

    //-------------------------------------------------------
    // Finish Simulation
    //-------------------------------------------------------
    initial
    begin
        wait(halt == 1'b1);

        #20;

        $display("\n================ FINAL REGISTER VALUES ================\n");

        $display("R1  = %h", DUT.RF.Register[1]);
        $display("R2  = %d", DUT.RF.Register[2]);
        $display("R3  = %d", DUT.RF.Register[3]);
        $display("R4  = %d", DUT.RF.Register[4]);
        $display("R5  = %d", DUT.RF.Register[5]);
        $display("R6  = %d", DUT.RF.Register[6]);
        $display("R7  = %d", DUT.RF.Register[7]);
        $display("R8  = %h", DUT.RF.Register[8]);
        $display("R9  = %d", DUT.RF.Register[9]);
        $display("R10 = %d", DUT.RF.Register[10]);
        $display("R11 = %d", DUT.RF.Register[11]);
        $display("R12 = %d", DUT.RF.Register[12]);

        $display("\n================ DATA MEMORY ================\n");

        $display("MEM[0] = %d", DUT.DataMem.memory[0]);

        $display("\nSimulation Completed Successfully.");

        $finish;
    end

    //-------------------------------------------------------
    // Timeout Protection
    //-------------------------------------------------------
    initial
    begin
        #1000;

        $display("\nERROR : Simulation Timed Out!");

        $finish;
    end

endmodule