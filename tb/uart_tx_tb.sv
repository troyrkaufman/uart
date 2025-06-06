// uart_tx_tb.v
// Troy Kaufman
// UART transmitter testbench

`timescale 1ns/1ns

module uart_tx_tb();
    logic fpga_clk;
    logic nrst;
    logic tx_en;
    logic [7:0] din;
    logic sout;
    logic busy_tx;

    uart_tx dut(fpga_clk, nrst, tx_en, din, sout, busy_tx);

    always begin
        fpga_clk = 1; #5;
        fpga_clk = 0; #5;
    end

    initial begin
        nrst = 0;
        tx_en = 0;
        din = 8'h00;

        #22;
        nrst = 1;
        #7; 
        tx_en = 1;
        din = 8'hee;
        #700; tx_en = 0;

        #100; tx_en = 1;
        din = 8'h95;
        #1400; tx_en = 0;
        #200; tx_en = 1;
        din = 8'hf0;
        
        
    end
endmodule
