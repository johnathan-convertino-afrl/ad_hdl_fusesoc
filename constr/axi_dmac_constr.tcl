# TCL script to create axi_dmac constraints for every instantiated core.

foreach instance [get_cells -hier -filter {ref_name==axi_dmac || orig_ref_name==axi_dmac}] {
  puts "INFO: Constraining $instance"

  set_property KEEP_HIERARCHY TRUE [get_cells $instance]

  set req_clk [get_clocks -of_objects [get_nets -hier -filter "parent_cell=~$instance*" *s_axi_aclk]]
  set src_clk [get_clocks -quiet -of_objects [get_nets -quiet -hier -filter "parent_cell=~$instance*" {*fifo_wr_clk *s_axis_aclk *m_src_axi_aclk}]]
  set dest_clk [get_clocks -quiet -of_objects [get_nets -quiet -hier -filter "parent_cell=~$instance*" {*fifo_rd_clk *m_axis_aclk *m_dest_axi_aclk}]]

  set async_req_src           [get_property ASYNC_CLK_REQ_SRC       [get_cells -hier -filter "name=~$instance"]]
  set async_dest_req          [get_property ASYNC_CLK_DEST_REQ      [get_cells -hier -filter "name=~$instance"]]
  set async_src_dest          [get_property ASYNC_CLK_SRC_DEST      [get_cells -hier -filter "name=~$instance"]]
  set disable_debug_registers [get_property DISABLE_DEBUG_REGISTERS [get_cells -hier -filter "name=~$instance"]]

  if {$req_clk eq ""} {
    puts "ERROR: No clocks found for s_axi_aclk."
    exit 2
  }

  if {($src_clk eq "") && ($dest_clk eq "")} {
    puts "ERROR: No clocks found for src or destination, check IP configuration and setup."
    exit 2
  }

#   if {$src_clk ne ""} {
#     set_clock_groups -logically_exclusive -group "$req_clk" -group "$src_clk"
#   }
#
#   if {$dest_clk ne ""} {
#     set_clock_groups -logically_exclusive -group "$req_clk" -group "$dest_clk"
#   }

  if {$async_dest_req || $async_req_src || $async_src_dest} {
    set_property ASYNC_REG TRUE [get_cells -quiet -hier -filter "parent=~$instance* && name =~ *cdc_sync_stage1_reg*"]

    set_property ASYNC_REG TRUE [get_cells -quiet -hier -filter "parent=~$instance* && name =~ *cdc_sync_stage2_reg*"]
  }

  # Reset signals
  set_false_path -quiet -from [get_cells -quiet -hier *do_reset_reg* -filter "parent=~$instance* && NAME =~ *i_reset_manager* && IS_SEQUENTIAL"] -to [get_pins -quiet -hier *reset_async_reg*/PRE -filter "parent_cell=~$instance*"]

  set_false_path -quiet -from [get_cells -quiet -hier *reset_async_reg[0] -filter "parent=~$instance* && NAME =~ *i_reset_manager* && IS_SEQUENTIAL"] -to [get_cells -quiet -hier *reset_async_reg[3]* -filter "parent=~$instance* && NAME =~ *i_reset_manager* && IS_SEQUENTIAL"]

  set_false_path -quiet -from [get_cells -quiet -hier *reset_async_reg[0] -filter "parent=~$instance* && NAME =~ *i_reset_manager* && IS_SEQUENTIAL"] -to [get_pins -quiet -hier *reset_sync_in_reg*/PRE -filter "parent_cell=~$instance* && NAME =~ *i_reset_manager*"]

  set_false_path -quiet -from [get_cells -quiet -hier *reset_sync_reg[0] -filter "parent=~$instance* && NAME =~ *i_reset_manager* && IS_SEQUENTIAL"] -to [get_pins -quiet -hier *reset_sync_in_reg*/PRE -filter "parent_cell=~$instance* && NAME =~ *i_reset_manager*"]

  set_property -dict { SHREG_EXTRACT NO ASYNC_REG TRUE } [get_cells -quiet -hier *reset_async_reg* -filter "parent=~$instance*"]

  set_property -dict { SHREG_EXTRACT NO ASYNC_REG TRUE } [get_cells -quiet -hier *reset_sync_reg* -filter "parent=~$instance*"]

  if {$disable_debug_registers != 1} {
    # Ignore timing for debug signals to register map
    set_false_path -quiet -from [get_cells -quiet -hier *cdc_sync_stage2_reg* -filter "parent=~$instance* && name =~ *i_sync_src_request_id* && IS_SEQUENTIAL"] -to [get_cells -quiet -hier *up_rdata_reg* -filter "parent=~$instance* && IS_SEQUENTIAL"]

    set_false_path -quiet -from [get_cells -quiet -hier *cdc_sync_stage2_reg* -filter "parent=~$instance* && name =~ *i_dest_sync_id* && IS_SEQUENTIAL"] -to [get_cells -quiet -hier *up_rdata_reg* -filter "parent=~$instance* && IS_SEQUENTIAL"]

    set_false_path -quiet -from [get_cells -quiet -hier *id_reg* -filter "parent=~$instance* && name =~ *i_request_arb* && IS_SEQUENTIAL"] -to [get_cells -quiet -hier *up_rdata_reg* -filter "parent=~$instance* && IS_SEQUENTIAL"]

    set_false_path -quiet -from [get_cells -quiet -hier *address_reg* -filter "parent=~$instance* && name =~ *i_addr_gen* && IS_SEQUENTIAL"] -to [get_cells -quiet -hier *up_rdata_reg* -filter "parent=~$instance* && IS_SEQUENTIAL"]

    set_false_path -quiet -from [get_cells -quiet -hier *reset_sync_reg* -filter "parent=~$instance* && name =~ *i_reset_manager* && IS_SEQUENTIAL"] -to [get_cells -quiet -hier *up_rdata_reg* -filter "parent=~$instance* && IS_SEQUENTIAL"]
  }

  if {$async_req_src} {
    foreach i_req_clk $req_clk {

      puts "INFO: $i_req_clk for async_req_src constraints."

      set_max_delay -quiet -datapath_only -from $i_req_clk -to [get_cells -quiet -hier *cdc_sync_stage1_reg* -filter "parent=~$instance* && NAME =~ *i_sync_src_request_id* && IS_SEQUENTIAL"] [get_property -min PERIOD $i_req_clk]

      set_false_path -quiet -from $i_req_clk -to [get_cells -quiet -hier *cdc_sync_stage1_reg* -filter "parent=~$instance* && NAME =~ *i_sync_control_src* && IS_SEQUENTIAL"]

      set_max_delay -quiet -datapath_only -from $i_req_clk -to [get_cells -quiet -hier *cdc_sync_stage1_reg* -filter "parent=~$instance* && NAME =~ *i_src_req_fifo/zerodeep.i_waddr_sync* && IS_SEQUENTIAL"] [get_property -min PERIOD $i_req_clk]

      set_max_delay -quiet -datapath_only -from $i_req_clk -to [get_cells -quiet -hier *cdc_sync_stage1_reg* -filter "parent=~$instance* && NAME =~ *i_rewind_req_fifo/zerodeep.i_raddr_sync* && IS_SEQUENTIAL"] [get_property -min PERIOD $i_req_clk]

      set_max_delay -quiet -datapath_only -from [get_cells -quiet -hier *cdc_sync_fifo_ram_reg* -filter "parent=~$instance* && NAME =~ *i_rewind_req_fifo* && IS_SEQUENTIAL"] -to $i_req_clk [get_property -min PERIOD $i_req_clk]

      set_false_path -quiet -from $i_req_clk -to [get_cells -quiet -hier *cdc_sync_stage1_reg* -filter "parent=~$instance* && NAME =~ *sync_rewind/i_sync_out* && IS_SEQUENTIAL"]
    }

    foreach i_src_clk $src_clk {

      puts "INFO: $i_src_clk for async_req_src constraints."

      set_false_path -quiet -from $i_src_clk -to [get_cells -quiet -hier *cdc_sync_stage1_reg* -filter "parent=~$instance* && NAME =~ *i_sync_status_src* && IS_SEQUENTIAL"]

      set_max_delay -quiet -datapath_only -from $i_src_clk -to [get_cells -quiet -hier *cdc_sync_stage1_reg* -filter "parent=~$instance* && NAME =~ *i_src_req_fifo/zerodeep.i_raddr_sync* && IS_SEQUENTIAL"] [get_property -min PERIOD $i_src_clk]

      set_max_delay -quiet -datapath_only -from [get_cells -quiet -hier *cdc_sync_fifo_ram_reg* -filter "parent=~$instance* && NAME =~ *i_src_req_fifo* && IS_SEQUENTIAL"] -to $i_src_clk [get_property -min PERIOD $i_src_clk]

      foreach i_req_clk $req_clk {
        puts "INFO: $i_src_clk and $i_req_clk for async_req_src constraints."

        set_max_delay -quiet -datapath_only -from $i_req_clk -through [get_cells -quiet -hier -filter "parent=~$instance* && NAME =~ *i_request_arb/eot_mem_src_reg*"] -to $i_src_clk [get_property -min PERIOD $i_src_clk]
      }

      set_max_delay -quiet -datapath_only -from $i_src_clk -to [get_cells -quiet -hier *cdc_sync_stage1_reg* -filter "parent=~$instance* && NAME =~ *i_rewind_req_fifo/zerodeep.i_waddr_sync* && IS_SEQUENTIAL"] [get_property -min PERIOD $i_src_clk]

      set_false_path -quiet -from $i_src_clk -to [get_cells -quiet -hier *cdc_sync_stage1_reg* -filter "parent=~$instance* && NAME =~ *sync_rewind/i_sync_in* && IS_SEQUENTIAL"]
    }
  }

  if {$async_dest_req} {
    foreach i_req_clk $req_clk {

      puts "INFO: $i_req_clk for async_dest_req constraints."

      set_max_delay -quiet -datapath_only -from $i_req_clk -to [get_cells -quiet -hier *cdc_sync_stage1_reg* -filter "parent=~$instance* && NAME =~ *i_dest_response_fifo/zerodeep.i_raddr_sync* && IS_SEQUENTIAL"] [get_property -min PERIOD $i_req_clk]

      set_max_delay -quiet -datapath_only -from [get_cells -quiet -hier *cdc_sync_fifo_ram_reg* -filter "parent=~$instance* && NAME =~ *i_dest_response_fifo* && IS_SEQUENTIAL"] -to $i_req_clk [get_property -min PERIOD $i_req_clk]

      set_false_path -quiet -from $i_req_clk -to [get_cells -quiet -hier *cdc_sync_stage1_reg* -filter "parent=~$instance* && NAME =~ *i_sync_control_dest* && IS_SEQUENTIAL"]
    }

    foreach i_dest_clk $dest_clk {

      puts "INFO: $i_dest_clk for async_dest_req constraints."

      set_max_delay -quiet -datapath_only -from $i_dest_clk -to [get_cells -hier *cdc_sync_stage1_reg* -filter "parent=~$instance* && NAME =~ *i_sync_req_response_id* && IS_SEQUENTIAL"] [get_property -min PERIOD $i_dest_clk]

      set_false_path -quiet -from $i_dest_clk -to [get_cells -quiet -hier *cdc_sync_stage1_reg* -filter "parent=~$instance* && NAME =~ *i_sync_status_dest* && IS_SEQUENTIAL"]

      set_max_delay -quiet -datapath_only -from $i_dest_clk -to [get_cells -quiet -hier *cdc_sync_stage1_reg* -filter "parent=~$instance* && NAME =~ *i_dest_response_fifo/zerodeep.i_waddr_sync* && IS_SEQUENTIAL"] [get_property -min PERIOD $i_dest_clk]
    }
  }

  if {$async_src_dest} {
    foreach i_src_clk $src_clk {

      puts "INFO: $i_src_clk for async_src_dest constraints."

      set_max_delay -quiet -datapath_only -from $i_src_clk -to [get_cells -quiet -hier *cdc_sync_stage1_reg* -filter "parent=~$instance* && NAME =~ *i_sync_dest_request_id* && IS_SEQUENTIAL"] [get_property -min PERIOD $i_src_clk]

      set_max_delay -quiet -datapath_only -from $i_src_clk -to [get_cells -quiet -hier *cdc_sync_stage1_reg* -filter "parent=~$instance* && NAME =~ *i_store_and_forward/i_dest_sync_id* && IS_SEQUENTIAL"] [get_property -min PERIOD $i_src_clk]

      set_max_delay -quiet -datapath_only -from $i_src_clk -to [get_cells -quiet -hier *cdc_sync_stage1_reg* -filter "parent=~$instance* && NAME =~ *i_dest_req_fifo/zerodeep.i_waddr_sync* && IS_SEQUENTIAL"] [get_property -min PERIOD $i_src_clk]

      set_max_delay -quiet -datapath_only -from $i_src_clk -to [get_cells -quiet -hier *cdc_sync_stage1_reg* -filter "parent=~$instance* && NAME =~ *i_src_dest_bl_fifo/zerodeep.i_waddr_sync* && IS_SEQUENTIAL"] [get_property -min PERIOD $i_src_clk]
    }


    foreach i_dest_clk $dest_clk {

      puts "INFO: $i_dest_clk for async_src_dest constraints."

      set_max_delay -quiet -datapath_only -from $i_dest_clk -to [get_cells -quiet -hier *cdc_sync_stage1_reg* -filter "parent=~$instance* && NAME =~ *i_store_and_forward/i_src_sync_id* && IS_SEQUENTIAL"] [get_property -min PERIOD $i_dest_clk]

      set_max_delay -quiet -datapath_only -from $i_dest_clk -to [get_cells -quiet -hier *cdc_sync_stage1_reg* -filter "parent=~$instance* && NAME =~ *i_dest_req_fifo/zerodeep.i_raddr_sync* && IS_SEQUENTIAL"] [get_property -min PERIOD $i_dest_clk]

      set_max_delay -quiet -datapath_only -from $i_dest_clk -to [get_cells -quiet -hier *cdc_sync_stage1_reg* -filter "parent=~$instance* && NAME =~ *i_src_dest_bl_fifo/zerodeep.i_raddr_sync* && IS_SEQUENTIAL"] [get_property -min PERIOD $i_dest_clk]

      set_max_delay -quiet -datapath_only -from [get_cells -quiet -hier *cdc_sync_fifo_ram_reg* -filter "parent=~$instance* && NAME =~ *i_src_dest_bl_fifo* && IS_SEQUENTIAL"] -to $i_dest_clk [get_property -min PERIOD $i_dest_clk]

      set_max_delay -quiet -datapath_only -from [get_cells -quiet -hier *cdc_sync_fifo_ram_reg* -filter "parent=~$instance* && NAME =~ *i_dest_req_fifo* && IS_SEQUENTIAL"] -to $i_dest_clk [get_property -min PERIOD $i_dest_clk]
    }

    foreach i_src_clk $src_clk {
      foreach i_dest_clk $dest_clk {

        puts "INFO: $i_dest_clk and $i_src_clk for async_src_dest constraints."

        set_max_delay -quiet -datapath_only -from $i_src_clk -through [get_cells -quiet -hier -filter "parent=~$instance* && IS_SEQUENTIAL && NAME =~ *i_store_and_forward/burst_len_mem_reg*"] -to $i_dest_clk [get_property -min PERIOD $i_dest_clk]

        set_max_delay -quiet -datapath_only -from $i_src_clk -through [get_cells -quiet -hier DP -filter "parent=~$instance* && name =~ *i_request_arb/eot_mem_dest_reg*"] -to $i_dest_clk [get_property -min PERIOD $i_dest_clk]
      }
    }
  }
}


