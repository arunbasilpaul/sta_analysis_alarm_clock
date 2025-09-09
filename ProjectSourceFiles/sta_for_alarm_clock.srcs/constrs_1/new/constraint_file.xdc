# Primary clock
create_clock -name aclk -period 20.0 [get_ports aclk]

#Input delay
set_input_delay -clock aclk 2 [get_ports A]

#Output delay
set_output_delay -clock aclk 2 [get_ports output]