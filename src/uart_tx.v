// uart_tx.v
// Troy Kaufman
// UART transmission module (Verilog version)

module uart_tx (
    input wire fpga_clk,       // fpga clk
    input wire nrst,           // inverted reset
    input wire tx_en,          // enable transmission
    input wire [7:0] din,      // one byte data input
    output wire sout,          // one bit data output
    output reg busy_tx
);

// FSM states
parameter IDLE = 2'b00;
parameter TX   = 2'b01;

reg [1:0] cs, ns;

parameter BAUDRATE = 115200;
reg [15:0] tick_total;       // number of FPGA clocks per bit
reg [15:0] tick_cnt;         // baud tick counter
reg [8:0] dout;              // shift register: start(0) + 8 data bits + stop(1)
reg tx_complete;
reg baud_clk;
reg baud_edge, baud_edge_d1, baud_edge_d2;
reg load;
reg [4:0] baud_cnt;
reg tx_en_d1, tx_en_d2, tx_en_posedge;

wire sout_data;

assign tick_total = 16'd5; // You may want to adjust based on fpga_clk

// tx_en edge detection logic
always @(posedge fpga_clk) begin
    if (~nrst) begin
        tx_en_d1 <= 1'b0;
        tx_en_d2 <= 1'b0;
        tx_en_posedge <= 1'b0;
    end else begin
        tx_en_d1 <= tx_en;
        tx_en_d2 <= tx_en_d1;
        if (tx_en_d1 && ~tx_en_d2)
            tx_en_posedge <= 1'b1;
        else
            tx_en_posedge <= 1'b0;
    end
end

// load signal logic
always @(posedge fpga_clk) begin
    if (~nrst)
        load <= 1'b0;
    else if (tx_en_posedge)
        load <= 1'b1;
    else
        load <= 1'b0;
end

// tick counter and baud edge generation
always @(posedge fpga_clk) begin
    if (~nrst || tx_en_posedge) begin
        tick_cnt <= 16'd0;
        baud_edge <= 1'b0;
    end else if (tick_cnt == tick_total) begin
        tick_cnt <= 16'd0;
        baud_edge <= 1'b1;
    end else begin
        tick_cnt <= tick_cnt + 1'b1;
        baud_edge <= 1'b0;
    end
end

// baud edge detection and baud clock pulse
always @(posedge fpga_clk) begin
    if (~nrst || tx_en_posedge) begin
        baud_edge_d1 <= 1'b0;
        baud_edge_d2 <= 1'b0;
        baud_clk <= 1'b0;
        baud_cnt <= 5'd0;
    end else begin
        baud_edge_d1 <= baud_edge;
        baud_edge_d2 <= baud_edge_d1;

        if (baud_edge_d1 && ~baud_edge_d2) begin
            baud_clk <= 1'b1;
            baud_cnt <= baud_cnt + 1'b1;
        end else if (baud_cnt > 5'd9) begin
            baud_clk <= baud_clk;
            baud_cnt <= 5'd0;
        end else begin
            baud_clk <= 1'b0;
            baud_cnt <= baud_cnt;
        end
    end
end

// PISO Shift Register and FSM update
always @(posedge fpga_clk) begin
    if (~nrst) begin
        dout <= 9'b111111111;
        cs <= IDLE;
    end else if (load) begin
        dout <= {1'b1, din}; // start bit is implicit with dout[0] = 0
        dout[8] <= 1'b0;     // start bit
        cs <= TX;
    end else if (baud_clk) begin
        dout <= {dout[7:0], 1'b1}; // shift in stop bits (high)
        cs <= TX;
    end
end

// FSM next state logic
always @(*) begin
    case (cs)
        IDLE: begin
            if (tx_en)
                ns = TX;
            else
                ns = IDLE;
        end
        TX: begin
            if (baud_cnt > 5'd9)
                ns = TX;
            else if (~tx_en)
                ns = IDLE;
            else
                ns = TX;
        end
        default: ns = IDLE;
    endcase
end

// Output assignments
assign sout_data = dout[8];
assign sout = sout_data;

endmodule
