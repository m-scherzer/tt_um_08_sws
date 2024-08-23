# Set time unit to nanoseconds
set_units -time ns

# Define load for all outputs
set_load 1 [all_outputs]
set_load -pin_load -max 1 [get_ports o_*]

# Create clock for i_sys_clk with a 50 ns period (20MHz)
create_clock -name sys_clk -period 50 -waveform {0 25} [get_ports i_sys_clk]

# Set clock transition times for rise and fall
set_clock_transition -rise -max 1 [get_clocks sys_clk]
set_clock_transition -fall -max 1 [get_clocks sys_clk]

# Set clock latency for more accurate analysis
set_clock_latency 5 [get_clocks sys_clk]

set_clock_uncertainty -setup 5 [get_clocks sys_clk]
set_clock_uncertainty -hold 0.3 [get_clocks sys_clk]

# Define driving cells for inputs and outputs
#set_driving_cell -lib_cell sky130_fd_sc_hd__inv_8 -pin Y [get_ports o_*]
#set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin Y [get_ports i_*]

# Define input delays for all input ports
set_input_delay 5 -clock [get_clocks sys_clk] [all_inputs]

# Define output delays for all output ports
set_output_delay -clock [get_clocks sys_clk] -max 5 [get_ports o_*]
set_output_delay -clock [get_clocks sys_clk] -min -0.25 [get_ports o_*]

