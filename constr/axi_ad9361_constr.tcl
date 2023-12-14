# TCL script to create axi_ad9361 constraints for every instantiated core.

foreach instance [get_cells -hier -filter {ref_name==axi_ad9361 || orig_ref_name==axi_ad9361}] {
  puts "INFO: Constraining $instance"

  set_property KEEP_HIERARCHY TRUE [get_cells $instance]

  set_property ASYNC_REG TRUE [get_cells -hier -filter "parent=~$instance* && name =~ *enable_up_*"]
  set_property ASYNC_REG TRUE [get_cells -hier -filter "parent=~$instance* && name =~ *txnrx_up_*"]
  set_property -quiet ASYNC_REG TRUE [get_cells -quiet -hier -filter "parent=~$instance* && name =~ *tdd_sync_d*"]

  set_false_path -from [get_cells -hier -filter "parent=~$instance* && name =~ *up_enable_int_reg   && IS_SEQUENTIAL"] -to [get_cells -hier -filter "parent=~$instance* && name =~ *enable_up_m1_reg  && IS_SEQUENTIAL"]
  set_false_path -from [get_cells -hier -filter "parent=~$instance* && name =~ *up_txnrx_int_reg    && IS_SEQUENTIAL"] -to [get_cells -hier -filter "parent=~$instance* && name =~ *txnrx_up_m1_reg   && IS_SEQUENTIAL"]

  set_false_path -quiet -to [get_cells -quiet -hier -filter "parent=~$instance* && name =~ *tdd_sync_d1_reg && IS_SEQUENTIAL"]
}
