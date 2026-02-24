## This file is a general .xdc for the Basys3 rev B board
## To use it in a project:
## - uncomment the lines corresponding to used pins
## - rename the used ports (in each line, after get_ports) according to the top level signal names in the project

### Clock signal
#set_property PACKAGE_PIN W5 [get_ports clk]
#set_property IOSTANDARD LVCMOS33 [get_ports clk]
#create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add [get_ports clk]

### Buttons (using center button for reset_n)
#set_property PACKAGE_PIN U18 [get_ports reset_n]
#set_property IOSTANDARD LVCMOS33 [get_ports reset_n]

###Pmod Header JA (using JA1 for data_out)
###Sch name = JA1
#set_property PACKAGE_PIN J1 [get_ports data_out]
#set_property IOSTANDARD LVCMOS33 [get_ports data_out]






### Clock signal (100MHz)
#set_property PACKAGE_PIN W5 [get_ports clk]
#set_property IOSTANDARD LVCMOS33 [get_ports clk]
#create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]

### PMOD JA1 for data output
#set_property PACKAGE_PIN L2 [get_ports data_out]
#set_property IOSTANDARD LVCMOS33 [get_ports data_out]




# Clock signal (100 MHz on Basys 3)
set_property -dict {PACKAGE_PIN W5 IOSTANDARD LVCMOS33} [get_ports clk]
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add [get_ports clk]

# Reset button (center button = BTNC)
set_property -dict {PACKAGE_PIN U18 IOSTANDARD LVCMOS33} [get_ports reset]

# WS2812 data output on PMOD JB pin 1
set_property -dict {PACKAGE_PIN P1 IOSTANDARD LVCMOS33} [get_ports data_out]

# Optional: make the pin drive a bit stronger and faster (helps with long strips)
set_property DRIVE 12 [get_ports data_out]
set_property SLEW FAST [get_ports data_out]

