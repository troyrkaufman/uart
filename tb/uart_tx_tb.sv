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
    logic baud_clk;

    uart_tx dut(fpga_clk, nrst, tx_en, din, sout, busy_tx, baud_clk);

    always begin
        fpga_clk = 1; #5;
        fpga_clk = 0; #5;
    end

    initial begin
        $display("Starting Testbench...");
        nrst = 0;
        tx_en = 0;
        din = 8'h00;
        #22;
        nrst = 1;
         
        if (nrst) begin
            repeat (5) begin
                @(posedge baud_clk);
                tx_en = 1;
                din = $urandom_range(0,255);
                repeat (10) @(posedge baud_clk);
            end     
        end
        tx_en = 0;
        $display("Testbench finished.");
    end
endmodule

