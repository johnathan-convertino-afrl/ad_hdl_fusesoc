# TCL script to create util_clkdiv constraints for every instantiated core.

foreach instance [get_cells -hier -filter {ref_name==util_clkdiv || orig_ref_name==util_clkdiv}] {
  puts "INFO: Constraining $instance"

  set_property KEEP_HIERARCHY TRUE [get_cells $instance]

  set_clock_groups -logically_exclusive -group [get_generated_clocks -of_objects [get_pins -of [get_cells -hier -filter parent==$instance] -filter name=~*clk_divide_sel_0/O]] -group [get_generated_clocks -of_objects [get_pins -of [get_cells -hier -filter parent==$instance] -filter name=~*clk_divide_sel_1/O]] -group [get_clocks -of_objects [get_nets -hier -filter "parent_cell==$instance && name=~*clk"]]

  set_false_path -quiet -to [get_pins -quiet -of [get_cells -quiet -hier -filter parent=~$instance*] -filter name=~*i_div_clk_gbuf/S*]
}
