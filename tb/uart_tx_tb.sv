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

    uart_tx dut(fpga_clk, nrst, tx_en, din, sout);

    always begin
        fpga_clk = 1; #5;
        fpga_clk = 0; #5;
    end

    initial begin
        $dumpfile("uart_tx.vcd");
        $dumpvars(0, uart_tx_tb);
        nrst = 0;
        tx_en = 0;
        din = 8'h00;

        #22
        nrst = 1;
        #7 
        tx_en = 1;
        din = 8'haa;

        #2500
        tx_en = 0;
        #50
        tx_en = 1;
        din = 8'h46;
    end
endmodule
