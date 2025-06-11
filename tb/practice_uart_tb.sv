`timescale 1ns / 1ps

module uart_tx_tb_rev2;

    logic clk;
    logic rst_n;
    logic tx_en;
    logic [7:0] tx_data;
    logic baud_tick;
    logic tx;
    logic tx_busy;

    // Instantiate the DUT
    uart_tx_rev2 dut (
        .clk(clk),
        .rst_n(rst_n),
        .tx_en(tx_en),
        .tx_data(tx_data),
        .baud_tick(baud_tick),
        .tx(tx),
        .tx_busy(tx_busy)
    );

    // 10 MHz Clock Generation (period = 100 ns)
    always #50 clk = ~clk;

    // Baud tick generator for 115200 baud using 10 MHz clock
    // 10_000_000 / 115200 ≈ 87 clock cycles per baud tick
    int baud_cnt = 0;
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            baud_cnt <= 0;
            baud_tick <= 0;
        end else begin
            if (baud_cnt == 86) begin
                baud_tick <= 1;
                baud_cnt <= 0;
            end else begin
                baud_tick <= 0;
                baud_cnt <= baud_cnt + 1;
            end
        end
    end

    // Task to send a byte
    task send_uart_byte(input [7:0] bytes);
        begin
            wait (!tx_busy);  // wait for idle
            @(posedge clk);
            tx_data <= bytes;
            tx_en <= 1;
            @(posedge clk);
            tx_en <= 0;

            wait (tx_busy);   // wait for TX to begin
            wait (!tx_busy);  // wait for TX to finish
        end
    endtask

    // Stimulus
    initial begin
        $display("Starting UART TX Testbench");
        $dumpfile("uart_tx_tb_rev2.vcd");
        $dumpvars(0, uart_tx_tb_rev2);

        // Initialize
        clk = 0;
        rst_n = 0;
        tx_en = 0;
        tx_data = 8'h00;

        // Reset
        #200;
        rst_n = 1;

        #500;

        // Send a few bytes
        send_uart_byte(8'hA5);  // 10100101
        send_uart_byte(8'h3C);  // 00111100
        send_uart_byte(8'h7E);  // 01111110

        #200_000;  // Let the waveform run a little longer
        $display("Simulation complete");
        $finish;
    end

    // Debug monitor
    initial begin
        $monitor("Time %0t | state=%0d | tx=%b | tx_en=%b | tx_data=%h | baud_tick=%b | tx_busy=%b",
                  $time, dut.state, tx, tx_en, tx_data, baud_tick, tx_busy);
    end

endmodule
