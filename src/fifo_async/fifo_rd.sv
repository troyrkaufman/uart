// fifo_rd.sv
// Troy Kaufman
// troykaufman28@gmail.com
// 6/8/2025
// Asynchronous FIFO write module

module fifo_rd #(parameter PTR_WIDTH = 4)
                (input  logic                   r_clk,
                input   logic                   r_nrst,
                input   logic                   r_en,
                input   logic [PTR_WIDTH-1:0]   g_wrptr_sync,
                output  logic [PTR_WIDTH-1:0]   g_rptr,
                output  logic [PTR_WIDTH-1:0]   b_rptr,
                output  logic                   empty);

    


endmodule