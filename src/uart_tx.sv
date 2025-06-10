// uart_tx.sv
// Troy Kaufman
// UART transmission module

module uart_tx(
    input logic fpga_clk,     // fpga clk
    input logic nrst,         // inverted reset
    input logic tx_en,        // enable transmission
    input logic [7:0] din,    // one byte data input
    output logic sout,         // one bit data output
    output logic busy_tx,
    output logic baud_clk
);

typedef enum logic [1:0] {IDLE, START, TX, STOP} statetype; // I don't think the STOP state is necessary
statetype cs, ns;

localparam BAUDRATE = 'd115200; // adjust baudrate according to PC setting
logic [15:0] tick_total;       // the total amount of fpga clk cycles that must pass before a bit can be transmitted
logic [15:0] tick_cnt;         // tick counter that updates how many fpga clk cycles must pass
logic [8:0] dout;             // serial data output on every flip flop in PISO shift reg
//logic [2:0] bit_cnt;          // counts the number of data bits that have been transmitted
logic tx_complete;            // flag that asserts whether all interesting data bits have been transmitted
//logic baud_clk;               // signal clocked based on the baudrate
logic baud_edge;              // represents a LOW or HIGH logic value depending on the tick_cnt
logic baud_edge_d1;           // signal assisting in finding the rising edge in baud_clk
logic baud_edge_d2;           // signal assisting in finding the rising edge in baud_clk
logic load;                   // control flag that loads the input data values in parallel into the shift register
logic [4:0] baud_cnt;         // keeps track 
logic tx_en_d1;
logic tx_en_d2;
logic tx_en_posedge;

assign tick_total = 'd5; //(fpga_clk / BAUDRATE) - 1; // calculate the total # of ticks that each bit is transmitted out on

// tx_en edge detection logic
always_ff@(posedge fpga_clk)
    if (~nrst) begin
        tx_en_d1 <= 0;
        tx_en_d2 <= 0;
        tx_en_posedge <= 0;
    end
    else begin
        tx_en_d1 <= tx_en;
        tx_en_d2 <= tx_en_d1;
        if (tx_en_d1 == 1 & tx_en_d2 == 0)
            tx_en_posedge = 1;
        else tx_en_posedge = 0;
    end

// load signal logic
always_comb
    if (~nrst) load = 0;
    else if (cs == START)
        load = 1;
    else 
        load = 0;

// tick counter and detect baud edge
always_ff @(posedge fpga_clk) begin
    if (~nrst | tx_en_posedge) begin
        tick_cnt <= 0;
        baud_edge = 0;
    end else if (tick_cnt == tick_total) begin
        tick_cnt <= 0;
        baud_edge = 1;
    end else begin
        tick_cnt <= tick_cnt + 1;
        baud_edge = 0;
    end
end

// baud rate edge detection logic
always_ff @(posedge fpga_clk) begin
    if (~nrst | tx_en_posedge) begin
        baud_edge_d1 <= 0;
        baud_edge_d2 <= 0;
        baud_clk <= 0;
	    baud_cnt <= 0;
    end else begin
        baud_edge_d1 <= baud_edge;
        baud_edge_d2 <= baud_edge_d1;

        if (baud_edge_d1 == 1 & baud_edge_d2 == 0)
            begin baud_clk <= 1; baud_cnt <= baud_cnt + 1; end
        else if (baud_cnt == 4'd10) 
            begin baud_clk <= baud_clk; baud_cnt <= 0; end
        else
            begin baud_clk <= 0; baud_cnt <= baud_cnt; end
    end
end

// PISO Shift Register
always_ff @(posedge fpga_clk) 
    if (~nrst) begin
        dout <= 9'b111111111;
        cs <= IDLE; end
    else if (load) begin
        dout <= {1'b0, din};
	    cs <= ns; end
    else if (baud_clk) begin
        dout <= {dout[7:0], 1'b1};
		cs <= ns; end 

// nextstate logic
always_comb
    case(cs)
        IDLE:   if (tx_en)  ns = START;
                else        ns = IDLE;
        START:  if (~tx_en) ns = IDLE;
                else        ns = TX; 
        TX:     if (baud_cnt == 4'd10) ns = START;
                else    ns = TX;
        default:        ns = IDLE;
    endcase

// output logic 
assign sout = dout[8];
assign busy_tx = (cs != IDLE);

endmodule