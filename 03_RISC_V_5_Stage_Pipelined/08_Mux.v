module Mux2(

    input  [31:0] a,
    input  [31:0] b,
    input         s,

    output [31:0] c

);

    //-------------------------------------
    // 2 : 1 Multiplexer
    //-------------------------------------
    assign c = (s) ? b : a;

endmodule



module Mux3(

    input  [31:0] a,
    input  [31:0] b,
    input  [31:0] c,
    input  [1:0]  s,

    output reg [31:0] d

);

    //-------------------------------------
    // 3 : 1 Multiplexer
    //-------------------------------------
    always @(*)
    begin
        case (s)

            2'b00: d = a;

            2'b01: d = b;

            2'b10: d = c;

            default: d = 32'd0;

        endcase
    end

endmodule