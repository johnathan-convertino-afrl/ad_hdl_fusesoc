# TCL script to create up_clock_mon constraints for every instantiated core.

foreach instance [get_cells -hier -filter {ref_name==up_clock_mon || orig_ref_name==up_clock_mon}] {
  puts "INFO: Constraining $instance"

  set_property KEEP_HIERARCHY TRUE [get_cells $instance]

  set_property ASYNC_REG true [get_cells -hierarchical -filter "parent==$instance && name =~ *up_count_running_m*"]
  set_property ASYNC_REG true [get_cells -hierarchical -filter "parent==$instance && name =~ *d_count_run_m*"]
  set_property ASYNC_REG true [get_cells -hierarchical -filter "parent==$instance && name =~ *up_d_count_reg*"]

  set_false_path -from [get_cells -hierarchical -filter "parent==$instance && name =~ *d_count_run_m3_reg*  && IS_SEQUENTIAL"] -to [get_cells -hierarchical -filter "parent==$instance && name =~ *up_count_running_m1_reg* && IS_SEQUENTIAL"]
  set_false_path -from [get_cells -hierarchical -filter "parent==$instance && name =~ *up_count_run_reg*    && IS_SEQUENTIAL"] -to [get_cells -hierarchical -filter "parent==$instance && name =~ *d_count_run_m1_reg* && IS_SEQUENTIAL"]
  set_false_path -from [get_cells -hierarchical -filter "parent==$instance && name =~ *d_count_reg*         && IS_SEQUENTIAL"] -to [get_cells -hierarchical -filter "parent==$instance && name =~ *up_d_count_reg* && IS_SEQUENTIAL"]
}
