// g2b.sv
// Troy Kaufman
// troykaufman28@gmail.com
// 6/8/2025
// Gray Code to Binary Conversion

module g2b #(parameter WIDTH = 4)
            (input logic g_in,
            output logic b_out);

integer i;

for (i = 0; i < WIDTH-1; i++) begin
    assign b_out[i] = ^(g_in>>i);
end

endmodule