onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /uart_tx_tb/dut/fpga_clk
add wave -noupdate /uart_tx_tb/dut/nrst
add wave -noupdate /uart_tx_tb/dut/tx_en
add wave -noupdate /uart_tx_tb/dut/din
add wave -noupdate -expand -group tc&bd /uart_tx_tb/dut/tick_total
add wave -noupdate -expand -group tc&bd /uart_tx_tb/dut/tick_cnt
add wave -noupdate -expand -group tc&bd /uart_tx_tb/dut/baud_edge
add wave -noupdate -expand -group edge_detect_baud /uart_tx_tb/dut/baud_edge_d1
add wave -noupdate -expand -group edge_detect_baud /uart_tx_tb/dut/baud_edge_d2
add wave -noupdate -expand -group edge_detect_baud /uart_tx_tb/dut/baud_cnt
add wave -noupdate -expand -group edge_detect_baud /uart_tx_tb/dut/baud_clk
add wave -noupdate -expand -group shift_register /uart_tx_tb/dut/dout
add wave -noupdate -expand -group shift_register /uart_tx_tb/dut/load
add wave -noupdate -expand -group nextstate_logic /uart_tx_tb/dut/cs
add wave -noupdate -expand -group nextstate_logic /uart_tx_tb/dut/ns
add wave -noupdate -expand -group nextstate_logic /uart_tx_tb/dut/baud_cnt
add wave -noupdate -expand -group nextstate_logic /uart_tx_tb/dut/tx_en
add wave -noupdate -radix binary /uart_tx_tb/dut/sout_data
add wave -noupdate /uart_tx_tb/dut/sout
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 0
configure wave -namecolwidth 220
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1000
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {936 ns}
