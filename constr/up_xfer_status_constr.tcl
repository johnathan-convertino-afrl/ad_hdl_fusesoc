# TCL script to create up_xfer_status constraints for every instantiated core.

foreach instance [get_cells -hier -filter {ref_name==up_xfer_status || orig_ref_name==up_xfer_status}] {
  puts "INFO: Constraining $instance"

  set_property KEEP_HIERARCHY TRUE [get_cells $instance]

  set_property ASYNC_REG TRUE [get_cells -hier -filter "parent==$instance && name =~ *d_xfer_state*"]
  set_property ASYNC_REG TRUE [get_cells -hier -filter "parent==$instance && name =~ *up_xfer_toggle_m*"]

  set_false_path -from [get_cells -hier -filter "parent==$instance && name =~ *d_xfer_toggle_reg   && IS_SEQUENTIAL"] -to [get_cells -hier -filter "parent==$instance && name =~ *up_xfer_toggle_m1_reg  && IS_SEQUENTIAL"]
  set_false_path -from [get_cells -hier -filter "parent==$instance && name =~ *up_xfer_toggle_reg  && IS_SEQUENTIAL"] -to [get_cells -hier -filter "parent==$instance && name =~ *d_xfer_state_m1_reg    && IS_SEQUENTIAL"]
  set_false_path -from [get_cells -hier -filter "parent==$instance && name =~ *d_xfer_data*        && IS_SEQUENTIAL"] -to [get_cells -hier -filter "parent==$instance && name =~ *up_data_status*        && IS_SEQUENTIAL"]
}
