derive_pll_clocks
rename_clock -name {sys_clk} -source [get_pins {sys_pll_inst/pll_inst.refclk}] -master_clock {sys_pll_inst/pll_inst.refclk} [get_pins {sys_pll_inst/pll_inst.clkc[0]}]
rename_clock -name {adc_clk} -source [get_pins {sys_pll_inst/pll_inst.refclk}] -master_clock {sys_pll_inst/pll_inst.refclk} [get_pins {sys_pll_inst/pll_inst.clkc[1]}]
rename_clock -name {dac_clk} -source [get_pins {sys_pll_inst/pll_inst.refclk}] -master_clock {sys_pll_inst/pll_inst.refclk} [get_pins {sys_pll_inst/pll_inst.clkc[2]}]
set_clock_groups -asynchronous -group [get_clocks {adc_clk dac_clk sys_clk}]