#
# The ADI JESD204 Core is released under the following license, which is
# different than all other HDL cores in this repository.
#
# Please read this, and understand the freedoms and responsibilities you have
# by using this source code/core.
#
# The JESD204 HDL, is copyright © 2016-2017 Analog Devices Inc.
#
# This core is free software, you can use run, copy, study, change, ask
# questions about and improve this core. Distribution of source, or resulting
# binaries (including those inside an FPGA or ASIC) require you to release the
# source of the entire project (excluding the system libraries provide by the
# tools/compiler/FPGA vendor). These are the terms of the GNU General Public
# License version 2 as published by the Free Software Foundation.
#
# This core  is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE. See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License version 2
# along with this source code, and binary.  If not, see
# <http://www.gnu.org/licenses/>.
#
# Commercial licenses (with commercial support) of this JESD204 core are also
# available under terms different than the General Public License. (e.g. they
# do not require you to accompany any image (FPGA or ASIC) using the JESD204
# core with any corresponding source code.) For these alternate terms you must
# purchase a license from Analog Devices Technology Licensing Office. Users
# interested in such a license should contact jesd204-licensing@analog.com for
# more information. This commercial license is sub-licensable (if you purchase
# chips from Analog Devices, incorporate them into your PCB level product, and
# purchase a JESD204 license, end users of your product will also have a
# license to use this core in a commercial setting without releasing their
# source code).
#
# In addition, we kindly ask you to acknowledge ADI in any program, application
# or publication in which you use this JESD204 HDL core. (You are not required
# to do so; it is up to your common sense to decide whether you want to comply
# with this request or not.) For general publications, we suggest referencing :
# “The design and implementation of the JESD204 HDL Core used in this project
# is copyright © 2016-2017, Analog Devices, Inc.”
#
foreach instance [get_cells -hier -filter {ref_name==jesd204_tx || orig_ref_name==jesd204_tx}] {
  puts "INFO: Constraining $instance"

  set_property KEEP_HIERARCHY TRUE [get_cells $instance]

  set async_clk [get_property ASYNC_CLK [get_cells -hier -filter "name=~$instance"]]

  set_property ASYNC_REG TRUE \
     [get_cells -quiet -hier -filter "parent=~$instance* && name =~ *i_lmfc/sysref_d1_reg"] \
     [get_cells -quiet -hier -filter "parent=~$instance* && name =~ *i_lmfc/sysref_d2_reg"]

  # Make sure that the device clock to sysref skew is at least somewhat
  # predictable
  # set_property IOB <=: $sysref_iob :> \
  #   [get_cells {i_lmfc/sysref_r_reg}]

  if {$async_clk} {

    set device_clk [get_clocks -of_objects [get_nets -hier -filter "parent_cell=~$instance*" *clk]]
    set device_clk [get_clocks -of_objects [get_nets -hier -filter "parent_cell=~$instance*" *device_clk]]

    # sync event i_sync_lmfc
    set_false_path -quiet \
      -from $device_clk \
      -to [get_cells -quiet -hier *cdc_sync_stage1_reg* -filter "parent=~$instance* && NAME =~ *i_sync_lmfc/i_sync_out* && IS_SEQUENTIAL"]

    set_false_path -quiet \
      -from $link_clk \
      -to [get_cells -quiet -hier *cdc_sync_stage1_reg* -filter "parent=~$instance* && NAME =~ *i_sync_lmfc/i_sync_out* && IS_SEQUENTIAL"]

    # sync bits i_next_mf_ready_cdc
    set_false_path \
      -from $link_clk \
      -to [get_cells -quiet -hier *cdc_sync_stage1_reg* -filter "parent=~$instance* && NAME =~ *i_next_mf_ready_cdc* && IS_SEQUENTIAL"]

    # sync bits i_link_reset_done_cdc
    set_false_path \
      -from $link_clk \
      -to [get_cells -quiet -hier *cdc_sync_stage1_reg* -filter "parent=~$instance* && NAME =~ *i_link_reset_done_cdc* && IS_SEQUENTIAL"]

    # sync bits gearbox/i_sync_ready
    set_false_path \
      -from $link_clk \
      -to [get_cells -quiet -hier *cdc_sync_stage1_reg* -filter "parent=~$instance* && NAME =~ *i_sync_ready* && IS_SEQUENTIAL"]

    # gearbox distributed RAM
    set_false_path -quiet \
      -from $device_clk \
      -to [get_cells -quiet -hier *mem_rd_data_reg* -filter "parent=~$instance* && NAME =~ *i_tx_gearbox* && IS_SEQUENTIAL"]
  }
}
