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
#### Build
  -

### IP USAGE
#### Parameters (IN PROGRESS)

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

  * axi_ad9361_cmos_if.v
  * axi_ad9361_rx.v
  * axi_ad9361_tx.v
  * axi_ad9361_lvds_if.v
  * axi_ad9361_tdd_if.v
  * axi_ad9361.v
  * axi_ad9361_rx_channel.v
  * axi_ad9361_tdd.v
  * axi_ad9361_rx_pnmon.v
  * axi_ad9361_tx_channel.v
  
#### constr

  * axi_ad9361_constr_q.sdc
  * axi_ad9361_constr.tcl
  
### fusesoc

  * fusesoc_info.core created.
  * Simulation uses icarus to run data through the core.

#### TARGETS

  * default (for IP integration builds)
