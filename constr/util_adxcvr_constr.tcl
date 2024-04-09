foreach instance [get_cells -hier -filter {ref_name==util_adxcvr || orig_ref_name==util_adxcvr}] {
  puts "INFO: Constraining $instance"

  set_property KEEP_HIERARCHY TRUE [get_cells $instance]

  set_property ASYNC_REG TRUE -quiet [get_cells -hier -filter "parent=~$instance* && name =~*up_rx_rst_done*"]
  set_property ASYNC_REG TRUE -quiet [get_cells -hier -filter "parent=~$instance* && name =~*up_tx_rst_done*"]
  set_property ASYNC_REG TRUE -quiet [get_cells -hier -filter "parent=~$instance* && name =~*rx_rate*"]
  set_property ASYNC_REG TRUE -quiet [get_cells -hier -filter "parent=~$instance* && name =~*tx_rate*"]

  set_false_path -to [get_cells -hier -filter "parent=~$instance* && name =~*up_rx_rst_done_m1_reg && IS_SEQUENTIAL"]
  set_false_path -to [get_cells -hier -filter "parent=~$instance* && name =~*up_tx_rst_done_m1_reg && IS_SEQUENTIAL"]
  set_false_path -to [get_cells -hier -filter "parent=~$instance* && name =~*rx_rate_m1_reg* && IS_SEQUENTIAL"]
  set_false_path -to [get_cells -hier -filter "parent=~$instance* && name =~*tx_rate_m1_reg* && IS_SEQUENTIAL"]

  # sync bits i_sync_bits_tx_prbs_in
  set_false_path \
    -to [get_cells -quiet -hier *cdc_sync_stage1_reg* -filter "parent=~$instance* && NAME =~ *cdc_sync_stage1_reg* && IS_SEQUENTIAL"]

  # sync bits i_sync_bits_rx_prbs_in
  set_false_path \
    -to [get_cells -quiet -hier *cdc_sync_stage1_reg* -filter "parent=~$instance* && NAME =~ *i_sync_bits_rx_prbs_in* && IS_SEQUENTIAL"]

  # sync bits i_sync_bits_rx_prbs_out
  set_false_path \
    -to [get_cells -quiet -hier *cdc_sync_stage1_reg* -filter "parent=~$instance* && NAME =~ *i_sync_bits_rx_prbs_out* && IS_SEQUENTIAL"]

  # sync bits i_sync_bits_rx_bufstatus_in
  set_false_path \
    -to [get_cells -quiet -hier *cdc_sync_stage1_reg* -filter "parent=~$instance* && NAME =~ *i_sync_bits_rx_bufstatus_in* && IS_SEQUENTIAL"]

  # sync bits i_sync_bits_bufstatus_out
  set_false_path \
    -to [get_cells -quiet -hier *cdc_sync_stage1_reg* -filter "parent=~$instance* && NAME =~ *i_sync_bits_bufstatus_out* && IS_SEQUENTIAL"]
}
