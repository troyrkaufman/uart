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

logic [PTR_WIDTH-1:0] b_wrptr_next;
logic [PTR_WIDTH-1:0] g_wrptr_next;

assign b_wrptr_next = b_wrptr + (wr_en & !full);
assign g_wrptr = (b_wrptr>>1)^b_wrptr_next;

// update binary and gray code pointers
always_ff@(posedge wr_clk)
    if (~nrst)
        begin
            b_wrptr <= 0;
            g_wrptr <= 0;
        end 
    else
        begin
            b_wrptr <= b_wrptr_next;
            g_wrptr <= g_wrptr_next;
        end

// full condition logic
assign full = 



endmodule