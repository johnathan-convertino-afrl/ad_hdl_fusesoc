# TCL script to create util_wfifo constraints for every instantiated core.

foreach instance [get_cells -hier -filter {ref_name==util_wfifo || orig_ref_name==util_wfifo}] {
  puts "INFO: Constraining $instance"

  set_property KEEP_HIERARCHY TRUE [get_cells $instance]

  set_property ASYNC_REG TRUE [get_cells -hier -filter "parent=~$instance* && name =~ *dout_enable_m*"]
  set_property ASYNC_REG TRUE [get_cells -hier -filter "parent=~$instance* && name =~ *dout_req_t_m*"]
  set_property ASYNC_REG TRUE [get_cells -hier -filter "parent=~$instance* && name =~ *din_ovf_m*"]

  set_false_path -from [get_cells -hier -filter "parent=~$instance* && name =~ *din_enable* && IS_SEQUENTIAL"] -to [get_cells -hier -filter "parent=~$instance* && name =~ *dout_enable_m1* && IS_SEQUENTIAL"]
  set_false_path -from [get_cells -hier -filter "parent=~$instance* && name =~ *din_req_t*  && IS_SEQUENTIAL"] -to [get_cells -hier -filter "parent=~$instance* && name =~ *dout_req_t_m1*  && IS_SEQUENTIAL"]
  set_false_path -from [get_cells -hier -filter "parent=~$instance* && name =~ *din_rinit*  && IS_SEQUENTIAL"] -to [get_cells -hier -filter "parent=~$instance* && name =~ *dout_rinit*     && IS_SEQUENTIAL "]
  set_false_path -from [get_cells -hier -filter "parent=~$instance* && name =~ *dout_ovf*   && IS_SEQUENTIAL"] -to [get_cells -hier -filter "parent=~$instance* && name =~ *din_ovf_m1*     && IS_SEQUENTIAL"]
}
