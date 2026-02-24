### ============================================================================
### MUSIC VISUALIZER - INTEGRATED BASYS 3 CONSTRAINTS
### ============================================================================

### ===== CLOCK (100MHz) =====
#set_property PACKAGE_PIN W5 [get_ports clk_100MHz]
#set_property IOSTANDARD LVCMOS33 [get_ports clk_100MHz]
#create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add [get_ports clk_100MHz]

### ===== SWITCHES (SW0-SW4) - Song Selection =====
#set_property PACKAGE_PIN V17 [get_ports {switches[0]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {switches[0]}]
#set_property PACKAGE_PIN V16 [get_ports {switches[1]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {switches[1]}]
#set_property PACKAGE_PIN W16 [get_ports {switches[2]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {switches[2]}]
#set_property PACKAGE_PIN W17 [get_ports {switches[3]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {switches[3]}]
#set_property PACKAGE_PIN W15 [get_ports {switches[4]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {switches[4]}]

### ===== VGA OUTPUT =====
### Red Channel (4 bits)
#set_property PACKAGE_PIN G19 [get_ports {vga_r[0]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {vga_r[0]}]
#set_property PACKAGE_PIN H19 [get_ports {vga_r[1]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {vga_r[1]}]
#set_property PACKAGE_PIN J19 [get_ports {vga_r[2]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {vga_r[2]}]
#set_property PACKAGE_PIN N19 [get_ports {vga_r[3]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {vga_r[3]}]

### Green Channel (4 bits)
#set_property PACKAGE_PIN J17 [get_ports {vga_g[0]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {vga_g[0]}]
#set_property PACKAGE_PIN H17 [get_ports {vga_g[1]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {vga_g[1]}]
#set_property PACKAGE_PIN G17 [get_ports {vga_g[2]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {vga_g[2]}]
#set_property PACKAGE_PIN D17 [get_ports {vga_g[3]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {vga_g[3]}]

### Blue Channel (4 bits)
#set_property PACKAGE_PIN N18 [get_ports {vga_b[0]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {vga_b[0]}]
#set_property PACKAGE_PIN L18 [get_ports {vga_b[1]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {vga_b[1]}]
#set_property PACKAGE_PIN K18 [get_ports {vga_b[2]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {vga_b[2]}]
#set_property PACKAGE_PIN J18 [get_ports {vga_b[3]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {vga_b[3]}]

### Sync Signals
#set_property PACKAGE_PIN P19 [get_ports h_sync]
#set_property IOSTANDARD LVCMOS33 [get_ports h_sync]
#set_property PACKAGE_PIN R19 [get_ports v_sync]
#set_property IOSTANDARD LVCMOS33 [get_ports v_sync]

### ===== PWM OUTPUT TO ARDUINO (Pmod JC Pin 4) =====
#set_property PACKAGE_PIN P18 [get_ports pwm_out]
#set_property IOSTANDARD LVCMOS33 [get_ports pwm_out]

### ===== CONFIGURATION SETTINGS =====
#set_property CFGBVS VCCO [current_design]
#set_property CONFIG_VOLTAGE 3.3 [current_design]

## ============================================================================
## MUSIC VISUALIZER - INTEGRATED BASYS 3 CONSTRAINTS
## ============================================================================
## ===== CLOCK (100MHz) =====
set_property PACKAGE_PIN W5 [get_ports clk_100MHz]
set_property IOSTANDARD LVCMOS33 [get_ports clk_100MHz]
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add [get_ports clk_100MHz]
## ===== RESET (Center Button) =====
set_property PACKAGE_PIN U18 [get_ports reset]
set_property IOSTANDARD LVCMOS33 [get_ports reset]
## ===== SWITCHES (SW0-SW4) - Song Selection =====
set_property PACKAGE_PIN V17 [get_ports {switches[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {switches[0]}]
set_property PACKAGE_PIN V16 [get_ports {switches[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {switches[1]}]
set_property PACKAGE_PIN W16 [get_ports {switches[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {switches[2]}]
set_property PACKAGE_PIN W17 [get_ports {switches[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {switches[3]}]
set_property PACKAGE_PIN W15 [get_ports {switches[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {switches[4]}]
## ===== VGA OUTPUT =====
## Red Channel (4 bits)
set_property PACKAGE_PIN G19 [get_ports {vga_r[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_r[0]}]
set_property PACKAGE_PIN H19 [get_ports {vga_r[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_r[1]}]
set_property PACKAGE_PIN J19 [get_ports {vga_r[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_r[2]}]
set_property PACKAGE_PIN N19 [get_ports {vga_r[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_r[3]}]
## Green Channel (4 bits)
set_property PACKAGE_PIN J17 [get_ports {vga_g[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_g[0]}]
set_property PACKAGE_PIN H17 [get_ports {vga_g[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_g[1]}]
set_property PACKAGE_PIN G17 [get_ports {vga_g[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_g[2]}]
set_property PACKAGE_PIN D17 [get_ports {vga_g[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_g[3]}]
## Blue Channel (4 bits)
set_property PACKAGE_PIN N18 [get_ports {vga_b[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_b[0]}]
set_property PACKAGE_PIN L18 [get_ports {vga_b[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_b[1]}]
set_property PACKAGE_PIN K18 [get_ports {vga_b[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_b[2]}]
set_property PACKAGE_PIN J18 [get_ports {vga_b[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_b[3]}]
## Sync Signals
set_property PACKAGE_PIN P19 [get_ports h_sync]
set_property IOSTANDARD LVCMOS33 [get_ports h_sync]
set_property PACKAGE_PIN R19 [get_ports v_sync]
set_property IOSTANDARD LVCMOS33 [get_ports v_sync]
## ===== PWM OUTPUT TO ARDUINO (Pmod JC Pin 4) =====
set_property PACKAGE_PIN P18 [get_ports pwm_out]
set_property IOSTANDARD LVCMOS33 [get_ports pwm_out]
## ===== WS2812 DATA OUTPUT (Pmod JA Pin 1) =====
set_property PACKAGE_PIN J1 [get_ports ws2812_data]
set_property IOSTANDARD LVCMOS33 [get_ports ws2812_data]
set_property DRIVE 12 [get_ports ws2812_data]
set_property SLEW FAST [get_ports ws2812_data]
## ===== CONFIGURATION SETTINGS =====
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]