// dff.sv
// Troy Kaufman
// troykaufman28@gmail.com
// Double Flip Flop Syncrhonizer

module dff #(WIDTH = 4)
            (input logic clk,               // system clock
            input logic nrst,               // active low reset
            input logic [WIDTH - 1:0] d,    // input data
            output logic [WIDTH - 1:0 q]);  // stable output data

logic [WIDTH - 1:0] mts_d;  // metastable data

always_ff@(posedge clk)
    if (~nrst)
        begin 
            mts_d <= 0;
            q <= 0;
        end
    else 
        begin
            mts_d <= d;
            q <= mts_d;
        end
endmodule