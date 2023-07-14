derive_pll_clocks
rename_clock -name {sys_clk} -source [get_pins {sys_pll_inst/pll_inst.refclk}] -master_clock {sys_pll_inst/pll_inst.refclk} [get_pins {sys_pll_inst/pll_inst.clkc[0]}]
rename_clock -name {adc_clk} -source [get_pins {sys_pll_inst/pll_inst.refclk}] -master_clock {sys_pll_inst/pll_inst.refclk} [get_pins {sys_pll_inst/pll_inst.clkc[1]}]
rename_clock -name {dac_clk} -source [get_pins {sys_pll_inst/pll_inst.refclk}] -master_clock {sys_pll_inst/pll_inst.refclk} [get_pins {sys_pll_inst/pll_inst.clkc[2]}]
set_clock_groups -asynchronous -group [get_clocks {adc_clk dac_clk sys_clk}]
set_clock_uncertainty 0.5 [get_clocks {sys_pll_inst/pll_inst.refclk}]

# set_output_delay -clock [get_clocks {dac_clk}] -min -5 -add_delay [get_ports {dac_data_1}]
# set_output_delay -clock [get_clocks {dac_clk}] -min -5 -add_delay [get_ports {dac_wrt_1}]
# set_output_delay -clock [get_clocks {dac_clk}] -max 2.5 -add_delay [get_ports {dac_data_1}]
# set_output_delay -clock [get_clocks {dac_clk}] -max 2.5 -add_delay [get_ports {dac_wrt_1}]

# set_output_delay -clock [get_clocks {dac_clk}] -min -5 -add_delay [get_ports {dac_data_2}]
# set_output_delay -clock [get_clocks {dac_clk}] -min -5 -add_delay [get_ports {dac_wrt_2}]
# set_output_delay -clock [get_clocks {dac_clk}] -max 2.5 -add_delay [get_ports {dac_data_2}]
# set_output_delay -clock [get_clocks {dac_clk}] -max 2.5 -add_delay [get_ports {dac_wrt_2}]