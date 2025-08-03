// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2017 (c) Analog Devices, Inc. All rights reserved.
//
// In this HDL repository, there are many different and unique modules, consisting
// of various HDL (Verilog or VHDL) components. The individual modules are
// developed independently, and may be accompanied by separate and unique license
// terms.
//
// The user should read each of these license terms, and understand the
// freedoms and responsibilities that he or she has by using this source/core.
//
// This core is distributed in the hope that it will be useful, but WITHOUT ANY
// WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
// A PARTICULAR PURPOSE.
//
// Redistribution and use of source or resulting binaries, with or without modification
// of this file, are permitted under one of the following two license terms:
//
//   1. The GNU General Public License version 2 as published by the
//      Free Software Foundation, which can be found in the top level directory
//      of this repository (LICENSE_GPL2), and also online at:
//      <https://www.gnu.org/licenses/old-licenses/gpl-2.0.html>
//
// OR
//
//   2. An ADI specific BSD license, which can be found in the top level directory
//      of this repository (LICENSE_ADIBSD), and also on-line at:
//      https://github.com/analogdevicesinc/hdl/blob/master/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module ad_data_in #(

  // parameters

  parameter   SINGLE_ENDED = 0,
  parameter   FPGA_TECHNOLOGY = 0,
  parameter   IODELAY_ENABLE = 0,
  parameter   IODELAY_CTRL = 0,
  parameter   IODELAY_GROUP = "dev_if_delay_group",
  parameter   REFCLK_FREQUENCY = 200) (

  // data interface

  input               rx_clk,
  input               rx_data_in_p,
  input               rx_data_in_n,
  output              rx_data_p,
  output              rx_data_n,

  // delay-data interface

  input               up_clk,
  input               up_dld,
  input       [ 4:0]  up_dwdata,
  output      [ 4:0]  up_drdata,

  // delay-cntrl interface

  input               delay_clk,
  input               delay_rst,
  output              delay_locked);

  // local parameters

  localparam CYCLONE5 = 101;
  localparam ARRIA10  = 103;
  
  wire s_ibuf_o;

  wire s_rx_data_p;
  wire s_rx_data_n;
  
  reg rp_rx_data_p;
  reg rp_rx_data_n;
  
  reg rn_rx_data_p;
  reg rn_rx_data_n;
  
  reg [4:0] r_up_dwdata = 'd0;
  
  // instantiations
  
  assign delay_locked = 1'b1;
  
  assign up_drdata = r_up_dwdata;
  
  assign rx_data_p = rp_rx_data_p;
  assign rx_data_n = rp_rx_data_n;
  
  always @(negedge rx_clk) begin
    rn_rx_data_p <= s_rx_data_p;
    rn_rx_data_n <= s_rx_data_n;
  end
  
  always @(posedge rx_clk) begin
    rp_rx_data_p <= rn_rx_data_p;
    rp_rx_data_n <= rn_rx_data_n;
  end
  
  always @(posedge up_clk) begin
    if(up_dld == 1'b1) begin
      r_up_dwdata <= up_dwdata;
    end
  end
  
  generate
  if (FPGA_TECHNOLOGY == CYCLONE5) begin
    if (SINGLE_ENDED == 1) begin
      alt_inbuf #(
        .enable_buf_hold("off")
      ) obuf (
        .i(rx_data_in_p),
        .o(s_ibuf_o)
      );
    end else begin
      alt_inbuf_diff #(
        .enable_bus_hold("off")
      ) obuf (
        .i(rx_data_in_p),
        .ibar(rx_data_in_n),
        .obar(s_ibuf_o)
      );
    end
  
    altddio_in #(
      .extend_oe_disable ("OFF"),
      .intended_device_family ("Cyclone V"),
      .invert_output ("OFF"),
      .lpm_hint ("UNUSED"),
      .lpm_type ("altddio_in"),
      .oe_reg ("UNREGISTERED"),
      .power_up_high ("OFF"),
      .width (1))
    iddr (
      .datain(s_ibuf_o),
      .inclock(rx_clk),
      .dataout_h(s_rx_data_p),
      .dataout_l(s_rx_data_n),
      .aclr(1'b0),
      .aset(1'b0),
      .inclocken(1'b1),
      .sclr(1'b0),
      .sset(1'b0));
  end
  endgenerate
  
  generate
  if (FPGA_TECHNOLOGY == ARRIA10) begin
    if (SINGLE_ENDED == 1) begin
      twentynm_io_ibuf #(
        .differential_mode("false"),
        .bus_hold("false")) 
      ibuf (
        .i(rx_data_in_p),
        .o(s_ibuf_o));  
    end else begin
      twentynm_io_ibuf #(
        .differential_mode("true"),
        .bus_hold("false")) 
      ibuf (
        .i(rx_data_in_p),
        .ibar(rx_data_in_n),
        .o(s_ibuf_o));  
    end

    twentynm_ddio_in #(
      .async_mode("none"),
      .sync_mode("none")) 
    iddr (
      .ena(1'b1),
      .areset(1'b0),
      .sreset(1'b0),
      .datain(s_ibuf_o),
      .clk (rx_clk),
      .regouthi(s_rx_data_p),
      .regoutlo(s_rx_data_n));
  end
  endgenerate
endmodule

// ***************************************************************************
// ***************************************************************************
