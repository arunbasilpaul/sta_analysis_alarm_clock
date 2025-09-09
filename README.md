# Static Timing Analysis for Alarm Clock project

<div>
  <img align="center" width="100%" src="https://github.com/user-attachments/assets/7ccbb784-0812-4596-bfdd-ba55eb2c6d28"/>

## Aim
The aim of this project is to conduct a Static Timing Analysis on an earlier project 'Alarm Clock'. Strict constraints will be used to push the system to its limits, with analysis and optimisations being conducted at various levels.

## What is STA?
Static Timing Analysis (STA) is a method to verify that your digital design meets its timing requirements without running functional simulations. It checks whether all signal paths can transfer data within the required clock period, considering:
- Setup time
- Hold time
- Clock uncertainties (skew, jitter, variation)
- Data path delays (logic and routing)

## Why STA?
In FPGAs, even if simulation works perfectly, you can fail on hardware if STA is ignored:
- Data corruption due to missed setup or hold
- Unstable operation under temperature/voltage variations
- Clock domain crossing failures

## How?
The STA that was performed has been explained with the commands used. The commands can also be found in the file titled 'commands':

# Procedure
## 1. Sanity-check constraints
### Define clocks correctly
Check the clock with various periods:
create_clock -name clock_name -period [get_ports entity top_module_clock_name];

### Generated clocks (not used in this project)
create_generated clock -name clock_name -source [get_pins mmcm_inst/CLKOUT 0]\ - divide_by 2 [get_pins bufg_div2/0]

### I/O Timing
set_input_delay 2.0 -clock entity_clock_name [get_ports entity_data_input_names];
set_output_delay 2.0 -clock entity_clock_name [get_ports entity_data_output_names];

### Check for unconstrained paths
report_timing_summary -report_unconstrained

## 2. See what exactly is slow
open_run impl_1
report_timing -delay_type max -nworst 5 -max_paths 1
report_high_fanout_nets -max_nets 10
report_clock_interaction

## 3. Shorten the logic path (Highest-level fix)
### A. Pipeline
Split long combinatorial logic across cycles

### B. Make sure arithmetic uses DSPs/BRAM (Inside your RTL module)
#### Please note that these commands can be still overwritten by Vivado during optimisation
attribute use_dsp : string;
attribute use_dsp of my_signal : signal is "yes";

### C. Reduce logic depth /fan-in
Decompose giant case/if- trees
Balance reductions (eg: trees of ladders instead of linear chain)

### D. Tame high-fanout control nets
set_max_fanout 32 [get_nets en*] 
#### The above command didn't work in Vivado 2022.2
phys_opt_design -directive AggressiceFanoutOpt

## 4. Let Vivado help more
### Synthesis options:
reset_runs synth_1
synth_design -top top_module_name -part part_name -retiming -flatten_hierarchy rebuilt

### Implementation options:
set_property STRATERGY Perfromance_Explore [get_runs impl_1]
launch_runs impl_1 -to_step route_design

### Placement/Routing directives
open_run impl_1
opt_design
place_design -directive ExtraNetDelay_high
phys_opt_design -directive AggressiveExplore
route_design -directive Explore
phys_opt_design -directive AggressiveExplore

## Conclusion
The timing report noted a significant change in the timings in the pblock stage; however, the constraints were too stringent and had to be relaxed for proper functioning of the application.
## 5. Floorplan only when needed (when routing dominates)
If the path delay is mostly routing, keep related logic close
create_pblock p_datapath
add_cells_to_pblock p_datapath [get_cells -hier {source_cell dest_cell}]
#### Please note that the source and dest cells can be found from the timing summary report
resize_pblock p_datapath -add {SLICE_X10Y20 : SLICE_X60Y90}
