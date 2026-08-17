`include "14_Single_Cycle_Top.v"

module Single_Cycle_Top_Tb;

    reg clk = 0;
    reg rst = 0;

    Single_Cycle_Top dut (
        .clk(clk),
        .rst(rst)
    );

    // Waveform dump
    initial begin
        $dumpfile("Single Cycle.vcd");
        $dumpvars(0, Single_Cycle_Top_Tb);
    end

    // Clock generation (100 time unit period)
    always #50 clk = ~clk;

    // Reset generation
    initial begin
        rst = 0;
        #120;

        rst = 1;
        #650;

        $finish;
    end

    initial begin
    $monitor(
        "Time=%0t PC=%h Instruction=%h ALUResult=%h",
        $time,
        dut.PC,
        dut.Instruction,
        dut.ALUResult
    );
    end

endmodule