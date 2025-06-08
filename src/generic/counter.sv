// counter.sv
// Troy Kaufman
// troykaufman28@gmail.com
// Parameterized counter

module counter #(WIDTH = 8)
                (input logic clk,
                input logic nrst,
                output logic [WIDTH - 1:0] q);

always_ff@(posedge clk)
    if (~nrst)
        q <=0;
    else 
        q <= q + 1;

endmodule