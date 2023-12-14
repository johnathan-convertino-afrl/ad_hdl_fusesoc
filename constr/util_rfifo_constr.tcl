# TCL script to create util_rfifo constraints for every instantiated core.

foreach instance [get_cells -hier -filter {ref_name==util_rfifo || orig_ref_name==util_rfifo}] {
  puts "INFO: Constraining $instance"

  set_property KEEP_HIERARCHY TRUE [get_cells $instance]

  set_property ASYNC_REG TRUE [get_cells -hier -filter "parent=~$instance* && name =~ *din_enable_m*"]
  set_property ASYNC_REG TRUE [get_cells -hier -filter "parent=~$instance* && name =~ *din_req_t_m*"]
  set_property ASYNC_REG TRUE [get_cells -hier -filter "parent=~$instance* && name =~ *dout_unf_m*"]

  set_false_path -from [get_cells -hier -filter "parent=~$instance* && name =~ *dout_enable* && IS_SEQUENTIAL"] -to [get_cells -hier -filter "parent=~$instance* && name =~ *din_enable_m1* && IS_SEQUENTIAL"]
  set_false_path -from [get_cells -hier -filter "parent=~$instance* && name =~ *dout_req_t*  && IS_SEQUENTIAL"] -to [get_cells -hier -filter "parent=~$instance* && name =~ *din_req_t_m1*  && IS_SEQUENTIAL"]
  set_false_path -from [get_cells -hier -filter "parent=~$instance* && name =~ *dout_init*   && IS_SEQUENTIAL"] -to [get_cells -hier -filter "parent=~$instance* && name =~ *din_init*      && IS_SEQUENTIAL"]
  set_false_path -from [get_cells -hier -filter "parent=~$instance* && name =~ *din_unf*     && IS_SEQUENTIAL"] -to [get_cells -hier -filter "parent=~$instance* && name =~ *dout_unf_m1*   && IS_SEQUENTIAL"]
}
