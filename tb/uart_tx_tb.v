// uart_tx_tb.v
// Troy Kaufman
// UART transmitter testbench (Verilog version)

`timescale 1ns/1ns

module uart_tx_tb;

    reg fpga_clk;
    reg nrst;
    reg tx_en;
    reg [7:0] din;
    wire sout;
    wire busy_tx;

    uart_tx dut (
        .fpga_clk(fpga_clk),
        .nrst(nrst),
        .tx_en(tx_en),
        .din(din),
        .sout(sout),
        .busy_tx(busy_tx)
    );

    // Clock generation
    always begin
        fpga_clk = 1'b1; #5;
        fpga_clk = 1'b0; #5;
    end

    // Test sequence
    initial begin
        nrst = 1'b0;
        tx_en = 1'b0;
        din = 8'h00;

        #22;
        nrst = 1'b1;
        #7; 
        tx_en = 1'b1;
        din = 8'hee;
        #700; tx_en = 1'b0;

        #100; tx_en = 1'b1;
        din = 8'h95;
        #1400; tx_en = 1'b0;

        #200; tx_en = 1'b1;
        din = 8'hf0;
    end

endmodule
