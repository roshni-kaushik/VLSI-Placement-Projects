module Data_Memory(

    input clk,
    input WE,

    input  [31:0] Addr,
    input  [31:0] WD,

    output [31:0] RD

);

    //-------------------------------------
    // 1024 x 32-bit Data Memory
    //-------------------------------------
    reg [31:0] mem [0:1023];

    //-------------------------------------
    // Synchronous Write
    //-------------------------------------
    always @(posedge clk)
    begin
        if (WE)
            mem[Addr[31:2]] <= WD;
    end

    //-------------------------------------
    // Asynchronous Read
    //-------------------------------------
    assign RD = mem[Addr[31:2]];

endmodule