// b2g.sv
// Troy Kaufman
// troykaufman28@gmail.com
// 6/8/2025
// Binary To Gray Code Conversion 

module b2g #(parameter WIDTH = 4)
            (input logic [WIDTH-1:0] b_in,
            output logic [WIDTH-1:0] g_out);

assign g_out = bin ^ (bin >> 1);

endmodule