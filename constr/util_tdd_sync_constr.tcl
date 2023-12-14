# TCL script to create util_tdd_sync constraints for every instantiated core.

# the "-quiet" option is added as module is not always inferred and this causes critical warnings

foreach instance [get_cells -quiet -hier -filter {ref_name==util_tdd_sync || orig_ref_name==util_tdd_sync}] {
  puts "INFO: Constraining $instance"

  set_property KEEP_HIERARCHY TRUE [get_cells $instance]

  set_property -quiet ASYNC_REG TRUE [get_cells -quiet -hier "parent==$instance && name =~ *sync_mode_d*"]

  set_false_path -quiet -to [get_cells -quiet -hier -filter "parent==$instance && name =~ *sync_mode_d1* && IS_SEQUENTIAL"]
}

