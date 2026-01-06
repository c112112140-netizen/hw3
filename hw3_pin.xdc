set_property IOSTANDARD LVCMOS25 [get_ports clk]
set_property PACKAGE_PIN Y9 [get_ports clk]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]

set_property -dict {PACKAGE_PIN P16 IOSTANDARD LVCMOS25} [get_ports rst]

set_property -dict {PACKAGE_PIN R16 IOSTANDARD LVCMOS25} [get_ports sw_r]
set_property -dict {PACKAGE_PIN T18 IOSTANDARD LVCMOS25} [get_ports sw_l]


set_property -dict {PACKAGE_PIN T22 IOSTANDARD LVCMOS25} [get_ports {led_r[0]}]
set_property -dict {PACKAGE_PIN T21 IOSTANDARD LVCMOS25} [get_ports {led_r[1]}]
set_property -dict {PACKAGE_PIN U22 IOSTANDARD LVCMOS25} [get_ports {led_r[2]}]
set_property -dict {PACKAGE_PIN U21 IOSTANDARD LVCMOS25} [get_ports {led_r[3]}]
set_property -dict {PACKAGE_PIN V22 IOSTANDARD LVCMOS25} [get_ports {led_r[4]}]
set_property -dict {PACKAGE_PIN W22 IOSTANDARD LVCMOS25} [get_ports {led_r[5]}]
set_property -dict {PACKAGE_PIN U19 IOSTANDARD LVCMOS25} [get_ports {led_r[6]}]
set_property -dict {PACKAGE_PIN U14 IOSTANDARD LVCMOS25} [get_ports {led_r[7]}]

