# TCL script to create ad_rst constraints for every instantiated core.

# the "-quiet" option is added for the axi_spi_engine ip where the ad_rst.v
# module is not always inferred and this causes critical warnings

foreach instance [get_cells -hier -filter {ref_name==ad_rst || orig_ref_name==ad_rst}] {
  puts "INFO: Constraining $instance"

  set_property KEEP_HIERARCHY TRUE [get_cells $instance]

  set_property -quiet ASYNC_REG TRUE [get_cells -hierarchical -filter "parent=~$instance* && name =~ *rst_async_d*_reg"]
  set_property -quiet ASYNC_REG TRUE [get_cells -hierarchical -filter "parent=~$instance* && name =~ *rst_sync_reg"]

  set_false_path -to [get_pins -of [get_cells -hier -filter parent=~$instance*] -filter name=~*rst_sync_reg/PRE]
  set_false_path -to [get_pins -of [get_cells -hier -filter parent=~$instance*] -filter name=~*rst_async_d1_reg/PRE]
  set_false_path -to [get_pins -of [get_cells -hier -filter parent=~$instance*] -filter name=~*rst_async_d2_reg/PRE]
}
