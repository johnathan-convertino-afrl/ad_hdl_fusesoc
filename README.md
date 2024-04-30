# AD IP
### Fusesoc cores for Analog Devices IP cores
---

   author: Jay Convertino
   
   details: Fusesoc core files for RTL AD HDL projects.
   
   license: MIT
   
---


### Version
#### Current
  - V1.0.0 - initial release

#### Previous
  - none

### Dependencies
  - git_pull, generator
  - hdl, github repo

### IP available
  - ad_addsub.core
  - ad_axis_inf_rx.core
  - ad_b2g.core
  - ad_data_clk.core
  - ad_datafmt.core
  - ad_data_in.core
  - ad_data_out.core
  - ad_dc_filter.core
  - ad_dds_1.core
  - ad_dds_2.core
  - ad_dds_cordic_pipe.core
  - ad_dds.core
  - ad_dds_sine_cordic.core
  - ad_dds_sine.core
  - ad_g2b.core
  - ad_hdl_repo.core
  - ad_ip_jesd204_tpl_adc.core
  - ad_ip_jesd204_tpl_dac.core
  - ad_iqcor.core
  - ad_jobuf.core
  - ad_mem_asym.core
  - ad_mem.core
  - ad_mul.core
  - ad_mux.core
  - ad_mux_core.core
  - ad_perfect_shuffle.core
  - ad_pnmon.core
  - ad_pps_receiver.core
  - ad_rst.core
  - ad_tdd_control.core
  - ad_xcvr_rx_if.core
  - axi_ad9361.core
  - axi_adxcvr.core
  - axi_dacfifo.core
  - axi_dmac.core
  - axi_jesd204_common.core
  - axi_jesd204_rx.core
  - axi_jesd204_tx.core
  - jesd204_common.core
  - jesd204_rx.core
  - jesd204_tx.core
  - sync_bits.core
  - sync_data.core
  - sync_event.core
  - sync_grey.core
  - up_adc_channel.core
  - up_adc_common.core
  - up_axi.core
  - up_clock_mon.core
  - up_dac_channel.core
  - up_dac_common.core
  - up_delay_cntrl.core
  - up_tdd_cntrl.core
  - up_tpl_common.core
  - up_xfer_cntrl.core
  - up_xfer_status.core
  - util_adxcvr.core
  - util_axis_fifo.core
  - util_clkdiv.core
  - util_cpack2_axis.core
  - util_cpack2.core
  - util_dacfifo.core
  - util_ext_sync.core
  - utility_pulse_gen.core
  - util_mii_to_rmii.core
  - util_pack_common.core
  - util_rfifo.core
  - util_tdd_sync.core
  - util_upack2.core
  - util_wfifo.core

### IP USAGE
#### Parameters that maybe found in Analog Devices Cores, and what they mean (IN PROGRESS).

  * ID
  * MODE_1R1T
  * FPGA_TECHNOLOGY
    - Xilinx
      - Unknown     0
      - 7series     1
      - ultrascale  2
      - ultrascale+ 3
    - Intel
       - Unknown      100
       - "Cyclone V"  101
       - "Cyclone 10" 102
       - "Arria 10"   103
       - "Stratix 10" 104
  * FPGA_FAMILY
    - Xilinx
      - Unknown 0
      - artix   1
      - kintex  2
      - virtex  3
      - zynq    4
    - Intel
      - Unknown   0
      - SX        1
      - GX        2
      - GT        3
      - GZ        4
      - "SE Base" 5
  * SPEED_GRADE
    - Xilinx
      - Unknown 0
      - -1      10
      - -1L     11
      - -1H     12
      - -1HV    13
      - -1LV    14
      - -2      20
      - -2L     21
      - -2LV    22
      - -3      30
    - Intel
      - Unknown   0
      - 1         1
      - 2         2
      - 3         3
      - 4         4
      - 5         5
      - 6         6
      - 7         7
      - 8         8
  * DEV_PACKAGE
    - Xilinx
      - Unknown 0
      - rf      1
      - fl      2
      - ff      3
      - fb      4
      - hc      5
      - fh      6
      - cs      7
      - cp      8
      - ft      9
      - fg      10
      - sb      11
      - rb      12
      - rs      13
      - cl      14
      - sf      15
      - ba      16
      - fa      17
      - fs      18
      - fi      19
    - Intel
      - Unknown   0
      - BGA       1
      - PGA       2
      - FBGA      3
      - HBGA      4
      - PDIP      5
      - EQFP      6
      - PLCC      7
      - PQFP      8
      - RQFP      9
      - TQFP     10
      - UBGA     11
      - UFBGA    12
      - MBGA     13
  * TDD_DISABLE
  * PPS_RECEIVER_ENABLE
  * CMOS_OR_LVDS_N
  * ADC_INIT_DELAY
  * ADC_DATAPATH_DISABLE
  * ADC_USERPORTS_DISABLE
  * ADC_DATAFORMAT_DISABLE
  * ADC_DCFILTER_DISABLE
  * ADC_IQCORRECTION_DISABLE
  * DAC_INIT_DELAY
  * DAC_CLK_EDGE_SEL
  * DAC_IODELAY_ENABLE
  * DAC_DATAPATH_DISABLE
  * DAC_DDS_DISABLE
  * DAC_DDS_TYPE
  * DAC_DDS_CORDIC_DW
  * DAC_DDS_CORDIC_PHASE_DW
  * DAC_USERPORTS_DISABLE
  * DAC_IQCORRECTION_DISABLE
  * IO_DELAY_GROUP = "dev_if_delay_group"
  * MIMO_ENABLE
  * USE_SSI_CLK
  * DELAY_REFCLK_FREQUENCY
  * RX_NODPA

### COMPONENTS
#### src
Contains code that adds features or fixes bugs for the Analog Devices HDL IP cores.

  - axi_ad9361_fix, fixes lvds code issues, adds Arria10 support properly.
    - axi_ad9361_lvds_if.v
  - intel, creates Quartus(Intel,Altera) cores that have feature parity with Xilinx equivilents.
    - ad_data_clk.v
    - ad_data_in.v
    - ad_data_out.v
    - ad_dcfilter.v
    - ad_mul.v
    - util_clkdiv.v
  - util_cpack2_axis, wrapper for cpack2 to convert the fifo interface to AXIS.
    - util_cpack2_axis.v

#### constr
Containts tcl based constraints converted from Xilinx xdc files so any instance can be found and constrained.

  - ad_rst_constr.tcl
  - axi_ad9361_constr.tcl
  - axi_dacfifo_constr.tcl
  - axi_dmac_constr.tcl
  - axi_jesd204_rx_constr.tcl
  - axi_jesd204_tx_constr.tcl
  - jesd204_rx_constr.tcl
  - jesd204_tx_constr.tcl
  - up_clock_mon_constr.tcl
  - up_xfer_cntrl_constr.tcl
  - up_xfer_status_constr.tcl
  - util_adxcvr_constr.tcl
  - util_cdc_sync_data_constr.tcl
  - util_cdc_sync_event_constr.tcl
  - util_clkdiv_constr.tcl
  - util_dacfifo_constr.tcl
  - util_rfifo_constr.tcl
  - util_tdd_sync_constr.tcl
  - util_wfifo_constr.tcl


### fusesoc

  * fusesoc_info.core created.

#### TARGETS

  * default (for IP integration builds)
