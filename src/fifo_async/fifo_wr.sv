// fifo_wr.sv
// Troy Kaufman
// troykaufman28@gmail.com
// 6/8/2025
// Asynchronous FIFO write module

module fifo_wr #(parameter PTR_WIDTH = 4)
                (input  logic                   wr_clk,
                input   logic                   wr_nrst,
                input   logic                   wr_en,
                input   logic [PTR_WIDTH-1:0]   g_rptr_sync,
                output  logic [PTR_WIDTH-1:0]   g_wrptr,
                output  logic [PTR_WIDTH-1:0]   b_wrptr,
                output  logic                   full);

    


endmodule