// edge_detect.sv
// Troy Kaufman
// troykaufman28@gmail.com
// The edge detection module detects an input signal's rising edge

module edge_detect( input logic     clk,        // system clock
                    input logic     nrst,       // active low reset
                    input logic     sig,        // one bit input signal
                    output logic    r_edge);    // rising edge == 1

logic sig_d1;   // one clock cycle delayed signal
logic sig_d2;   // two clock cycle delayed signal

always_ff@(posedge clk)
    if (~nrst)  
        begin
           sig_d1 <= 0;
           sig_d2 <= 0; 
        end
    else 
        begin
            sig_d1 <= sig;
            sig_d2 <= sig_d1;
        end

assign rising_edge = (sig_d1 == 1 & sig_d2 == 0);
endmodule