# TCL script to create sync_data constraints for every instantiated core.

foreach instance [get_cells -hier -filter {ref_name==sync_data || orig_ref_name==sync_data}] {
  puts "INFO: Constraining $instance"

  set_property KEEP_HIERARCHY TRUE [get_cells $instance]

  set_false_path -quiet -from [get_cells -quiet -hier -filter "parent=~$instance && name =~ *in_toggle_d1_reg"]  -to [get_cells -quiet -hier -filter "parent=~$instance*i_sync_out && name =~ *cdc_sync_stage1_reg[0]"]
  set_false_path -quiet -from [get_cells -quiet -hier -filter "parent=~$instance && name =~ *out_toggle_d1_reg"] -to [get_cells -quiet -hier -filter "parent=~$instance*i_sync_in && name =~ *cdc_sync_stage1_reg[0]"]

  set_false_path -quiet -from [get_cells -quiet -hier -filter "parent=~$instance* && name =~ *cdc_hold[*]"] -to [get_cells -quiet -hier -filter "parent=~$instance* && name =~ *out_data[*]"]

}
