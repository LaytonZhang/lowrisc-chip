## Bluetooth
## PMOD Header JB
set_property -dict { PACKAGE_PIN V29   IOSTANDARD LVCMOS33 } [get_ports { bt_rts }]; #IO_L17P_T2_A14_D30_14 Sch=jb_p[1]
set_property -dict { PACKAGE_PIN V30   IOSTANDARD LVCMOS33 } [get_ports { bt_rx }]; #IO_L17N_T2_A13_D29_14 Sch=jb_n[1]
set_property -dict { PACKAGE_PIN V25   IOSTANDARD LVCMOS33 } [get_ports { bt_tx }]; #IO_L18P_T2_A12_D28_14 Sch=jb_p[2]
set_property -dict { PACKAGE_PIN W26   IOSTANDARD LVCMOS33 } [get_ports { bt_cts }]; #IO_L18N_T2_A11_D27_14 Sch=jb_n[2]
## GND(5), VCC3V3(6)
set_property -dict { PACKAGE_PIN T25   IOSTANDARD LVCMOS33 } [get_ports { bt_sts }]; #IO_L14P_T2_SRCC_14 Sch=jb_p[3]
set_property -dict { PACKAGE_PIN U25   IOSTANDARD LVCMOS33 } [get_ports { bt_rstn }]; #IO_L14N_T2_SRCC_14 Sch=jb_n[3]
#set_property -dict { PACKAGE_PIN U22   IOSTANDARD LVCMOS33 } [get_ports { bt_nc_9 }]; #IO_L21P_T3_DQS_14 Sch=jb_p[4]
#set_property -dict { PACKAGE_PIN U23   IOSTANDARD LVCMOS33 } [get_ports { bt_nc_10 }]; #IO_L21N_T3_DQS_A06_D22_14 Sch=jb_n[4]
## GND(11), VCC3V3(12)

## Buttons
set_property -dict {PACKAGE_PIN R19 IOSTANDARD LVCMOS33} [get_ports cpu_resetn]

## To use FTDI FT2232 JTAG
set_property -dict { PACKAGE_PIN Y29   IOSTANDARD LVCMOS33 } [get_ports { trst_n }];
set_property -dict { PACKAGE_PIN AD27  IOSTANDARD LVCMOS33 } [get_ports { tck    }];
set_property -dict { PACKAGE_PIN W27   IOSTANDARD LVCMOS33 } [get_ports { tdi    }];
set_property -dict { PACKAGE_PIN W28   IOSTANDARD LVCMOS33 } [get_ports { tdo    }];
set_property -dict { PACKAGE_PIN W29   IOSTANDARD LVCMOS33 } [get_ports { tms    }];

## UART
set_property -dict {PACKAGE_PIN Y23 IOSTANDARD LVCMOS33} [get_ports tx]
set_property -dict {PACKAGE_PIN Y20 IOSTANDARD LVCMOS33} [get_ports rx]


## LEDs
set_property -dict {PACKAGE_PIN T28 IOSTANDARD LVCMOS33} [get_ports {led[0]}]
set_property -dict {PACKAGE_PIN V19 IOSTANDARD LVCMOS33} [get_ports {led[1]}]
set_property -dict {PACKAGE_PIN U30 IOSTANDARD LVCMOS33} [get_ports {led[2]}]
set_property -dict {PACKAGE_PIN U29 IOSTANDARD LVCMOS33} [get_ports {led[3]}]
set_property -dict {PACKAGE_PIN V20 IOSTANDARD LVCMOS33} [get_ports {led[4]}]
set_property -dict {PACKAGE_PIN V26 IOSTANDARD LVCMOS33} [get_ports {led[5]}]
set_property -dict {PACKAGE_PIN W24 IOSTANDARD LVCMOS33} [get_ports {led[6]}]
set_property -dict {PACKAGE_PIN W23 IOSTANDARD LVCMOS33} [get_ports {led[7]}]

## Switches
set_property -dict {PACKAGE_PIN G19 IOSTANDARD LVCMOS12} [get_ports {sw[0]}]
set_property -dict {PACKAGE_PIN G25 IOSTANDARD LVCMOS12} [get_ports {sw[1]}]
set_property -dict {PACKAGE_PIN H24 IOSTANDARD LVCMOS12} [get_ports {sw[2]}]
set_property -dict {PACKAGE_PIN K19 IOSTANDARD LVCMOS12} [get_ports {sw[3]}]
set_property -dict {PACKAGE_PIN N19 IOSTANDARD LVCMOS12} [get_ports {sw[4]}]
set_property -dict {PACKAGE_PIN P19 IOSTANDARD LVCMOS12} [get_ports {sw[5]}]
set_property -dict {PACKAGE_PIN P26 IOSTANDARD LVCMOS33} [get_ports {sw[6]}]
set_property -dict {PACKAGE_PIN P27 IOSTANDARD LVCMOS33} [get_ports {sw[7]}]

## Fan Control
set_property -dict {PACKAGE_PIN W19 IOSTANDARD LVCMOS33} [get_ports fan_pwm]
#set_property -dict { PACKAGE_PIN V21   IOSTANDARD LVCMOS33 } [get_ports { FAN_TACH }]; #IO_L22P_T3_A05_D21_14 Sch=fan_tac

## Ethernet
set_property -dict {PACKAGE_PIN AH24 IOSTANDARD LVCMOS33} [get_ports { eth_rst_n }]; #IO_L14N_T2_SRCC_12 Sch=eth_phyrst_n
set_property -dict {PACKAGE_PIN AE10 IOSTANDARD LVCMOS15} [get_ports { eth_txck }]; #IO_L14P_T2_SRCC_33 Sch=eth_tx_clk
set_property -dict {PACKAGE_PIN AK14 IOSTANDARD LVCMOS15} [get_ports { eth_txctl }]; #IO_L20P_T3_33 Sch=eth_tx_en
set_property -dict {PACKAGE_PIN AJ12 IOSTANDARD LVCMOS15} [get_ports { eth_txd[0] }]; #IO_L22N_T3_33 Sch=eth_tx_d[0]
set_property -dict {PACKAGE_PIN AK11 IOSTANDARD LVCMOS15} [get_ports { eth_txd[1] }]; #IO_L17P_T2_33 Sch=eth_tx_d[1]
set_property -dict {PACKAGE_PIN AJ11 IOSTANDARD LVCMOS15} [get_ports { eth_txd[2] }]; #IO_L18N_T2_33 Sch=eth_tx_d[2]
set_property -dict {PACKAGE_PIN AK10 IOSTANDARD LVCMOS15} [get_ports { eth_txd[3] }]; #IO_L17N_T2_33 Sch=eth_tx_d[3]
set_property -dict {PACKAGE_PIN AJ14 IOSTANDARD LVCMOS15} [get_ports { eth_rxd[0] }]; #IO_L21N_T3_DQS_33 Sch=eth_rx_d[0]
set_property -dict {PACKAGE_PIN AG10 IOSTANDARD LVCMOS15} [get_ports { eth_rxck }]; #IO_L13P_T2_MRCC_33 Sch=eth_rx_clk
set_property -dict {PACKAGE_PIN AH11 IOSTANDARD LVCMOS15} [get_ports { eth_rxctl }]; #IO_L18P_T2_33 Sch=eth_rx_ctl
set_property -dict {PACKAGE_PIN AH14 IOSTANDARD LVCMOS15} [get_ports { eth_rxd[1] }]; #IO_L21P_T3_DQS_33 Sch=eth_rx_d[1]
set_property -dict {PACKAGE_PIN AK13 IOSTANDARD LVCMOS15} [get_ports { eth_rxd[2] }]; #IO_L20N_T3_33 Sch=eth_rx_d[2]
set_property -dict {PACKAGE_PIN AJ13 IOSTANDARD LVCMOS15} [get_ports { eth_rxd[3] }]; #IO_L22P_T3_33 Sch=eth_rx_d[3]
set_property -dict {PACKAGE_PIN AF12 IOSTANDARD LVCMOS15} [get_ports { eth_mdc }]; #IO_L23P_T3_33 Sch=eth_mdc
set_property -dict {PACKAGE_PIN AG12 IOSTANDARD LVCMOS15} [get_ports { eth_mdio }]; #IO_L23N_T3_33 Sch=eth_mdio

# set_property -dict {PACKAGE_PIN AK15  IOSTANDARD LVCMOS18} [get_ports { eth_pme_b }]; #IO_L1N_T0_32 Sch=eth_pmeb
# set_property -dict {PACKAGE_PIN AK16  IOSTANDARD LVCMOS18} [get_ports { eth_int_b }]; #IO_L1P_T0_32 Sch=eth_intb

#############################################
# Ethernet Constraints for 1Gb/s
#############################################
# Modified for 125MHz receive clock
create_clock -period 8.000 -name eth_rxck [get_ports eth_rxck]

set_clock_groups -asynchronous -group [get_clocks eth_rxck -include_generated_clocks]
set_clock_groups -asynchronous -group [get_clocks clk_out2_xlnx_clk_gen]

#############################################
## SD Card
set_property -dict { PACKAGE_PIN P28   IOSTANDARD LVCMOS33 } [get_ports { sd_detect }]; #IO_L8N_T1_D12_14 Sch=sd_cd
set_property -dict { PACKAGE_PIN R29   IOSTANDARD LVCMOS33 } [get_ports { sd_cmd }]; #IO_L7N_T1_D10_14 Sch=sd_cmd
set_property -dict { PACKAGE_PIN R26   IOSTANDARD LVCMOS33 } [get_ports { sd_dat[0] }]; #IO_L10N_T1_D15_14 Sch=sd_dat[0]
set_property -dict { PACKAGE_PIN R30   IOSTANDARD LVCMOS33 } [get_ports { sd_dat[1] }]; #IO_L9P_T1_DQS_14 Sch=sd_dat[1]
set_property -dict { PACKAGE_PIN P29   IOSTANDARD LVCMOS33 } [get_ports { sd_dat[2] }]; #IO_L7P_T1_D09_14 Sch=sd_dat[2]
set_property -dict { PACKAGE_PIN T30   IOSTANDARD LVCMOS33 } [get_ports { sd_dat[3] }]; #IO_L9N_T1_DQS_D13_14 Sch=sd_dat[3]
set_property -dict { PACKAGE_PIN AE24  IOSTANDARD LVCMOS33 } [get_ports { sd_reset }]; #IO_L12N_T1_MRCC_12 Sch=sd_reset
set_property -dict { PACKAGE_PIN R28   IOSTANDARD LVCMOS33 } [get_ports { sd_sclk }]; #IO_L11P_T1_SRCC_14 Sch=sd_sclk

# create_generated_clock -name sd_fast_clk -source [get_pins clk_mmcm/sd_sys_clk] -divide_by 2 [get_pins chipset_impl/piton_sd_top/sdc_controller/clock_divider0/fast_clk_reg/Q]
# create_generated_clock -name sd_slow_clk -source [get_pins clk_mmcm/sd_sys_clk] -divide_by 200 [get_pins chipset_impl/piton_sd_top/sdc_controller/clock_divider0/slow_clk_reg/Q]
# create_generated_clock -name sd_clk_out -source [get_pins sd_clk_oddr/C] -divide_by 1 -add -master_clock sd_fast_clk [get_ports sd_clk_out]
# create_generated_clock -name sd_clk_out_1 -source [get_pins sd_clk_oddr/C] -divide_by 1 -add -master_clock sd_slow_clk [get_ports sd_clk_out]

# create_clock -period 40.000 -name VIRTUAL_sd_fast_clk -waveform {0.000 20.000}
# create_clock -period 4000.000 -name VIRTUAL_sd_slow_clk -waveform {0.000 2000.000}

# set_output_delay -clock [get_clocks sd_clk_out] -min -add_delay 5.000 [get_ports {sd_dat[*]}]
# set_output_delay -clock [get_clocks sd_clk_out] -max -add_delay 15.000 [get_ports {sd_dat[*]}]
# set_output_delay -clock [get_clocks sd_clk_out_1] -min -add_delay 5.000 [get_ports {sd_dat[*]}]
# set_output_delay -clock [get_clocks sd_clk_out_1] -max -add_delay 1500.000 [get_ports {sd_dat[*]}]
# set_output_delay -clock [get_clocks sd_clk_out] -min -add_delay 5.000 [get_ports sd_cmd]
# set_output_delay -clock [get_clocks sd_clk_out] -max -add_delay 15.000 [get_ports sd_cmd]
# set_output_delay -clock [get_clocks sd_clk_out_1] -min -add_delay 5.000 [get_ports sd_cmd]
# set_output_delay -clock [get_clocks sd_clk_out_1] -max -add_delay 1500.000 [get_ports sd_cmd]
# set_input_delay -clock [get_clocks VIRTUAL_sd_fast_clk] -min -add_delay 20.000 [get_ports {sd_dat[*]}]
# set_input_delay -clock [get_clocks VIRTUAL_sd_fast_clk] -max -add_delay 35.000 [get_ports {sd_dat[*]}]
# set_input_delay -clock [get_clocks VIRTUAL_sd_slow_clk] -min -add_delay 2000.000 [get_ports {sd_dat[*]}]
# set_input_delay -clock [get_clocks VIRTUAL_sd_slow_clk] -max -add_delay 3500.000 [get_ports {sd_dat[*]}]
# set_input_delay -clock [get_clocks VIRTUAL_sd_fast_clk] -min -add_delay 20.000 [get_ports sd_cmd]
# set_input_delay -clock [get_clocks VIRTUAL_sd_fast_clk] -max -add_delay 35.000 [get_ports sd_cmd]
# set_input_delay -clock [get_clocks VIRTUAL_sd_slow_clk] -min -add_delay 2000.000 [get_ports sd_cmd]
# set_input_delay -clock [get_clocks VIRTUAL_sd_slow_clk] -max -add_delay 3500.000 [get_ports sd_cmd]
# set_clock_groups -physically_exclusive -group [get_clocks -include_generated_clocks sd_clk_out] -group [get_clocks -include_generated_clocks sd_clk_out_1]
# set_clock_groups -logically_exclusive -group [get_clocks -include_generated_clocks {VIRTUAL_sd_fast_clk sd_fast_clk}] -group [get_clocks -include_generated_clocks {sd_slow_clk VIRTUAL_sd_slow_clk}]
# set_clock_groups -asynchronous -group [get_clocks [list [get_clocks -of_objects [get_pins clk_mmcm/chipset_clk]]]] -group [get_clocks -filter { NAME =~  "*sd*" }]


# Genesys 2 has a quad SPI flash
set_property -dict { PACKAGE_PIN U19 IOSTANDARD LVCMOS33 } [get_ports { QSPI_CSN }]; #IO_L6P_T0_FCS_B_14 Sch=qspi_csn
set_property -dict { PACKAGE_PIN P24 IOSTANDARD LVCMOS33 } [get_ports { QSPI_D[0] }]; #IO_L1P_T0_D00_MOSI_14 Sch=qspi_d[0]
set_property -dict { PACKAGE_PIN R25 IOSTANDARD LVCMOS33 } [get_ports { QSPI_D[1] }]; #IO_L1N_T0_D01_DIN_14 Sch=qspi_d[1]
set_property -dict { PACKAGE_PIN R20 IOSTANDARD LVCMOS33 } [get_ports { QSPI_D[2] }]; #IO_L2P_T0_D02_14 Sch=qspi_d[2]
set_property -dict { PACKAGE_PIN R21 IOSTANDARD LVCMOS33 } [get_ports { QSPI_D[3] }]; #IO_L2N_T0_D03_14 Sch=qspi_d[3]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]

## VGA Connector
set_property -dict { PACKAGE_PIN AH20  IOSTANDARD LVCMOS33 } [get_ports { VGA_BLUE_O[0] }]; #IO_L22N_T3_12 Sch=vga_b[3]
set_property -dict { PACKAGE_PIN AG20  IOSTANDARD LVCMOS33 } [get_ports { VGA_BLUE_O[1] }]; #IO_L22P_T3_12 Sch=vga_b[4]
set_property -dict { PACKAGE_PIN AF21  IOSTANDARD LVCMOS33 } [get_ports { VGA_BLUE_O[2] }]; #IO_L19N_T3_VREF_12 Sch=vga_b[5]
set_property -dict { PACKAGE_PIN AK20  IOSTANDARD LVCMOS33 } [get_ports { VGA_BLUE_O[3] }]; #IO_L24P_T3_12 Sch=vga_b[6]
set_property -dict { PACKAGE_PIN AG22  IOSTANDARD LVCMOS33 } [get_ports { VGA_BLUE_O[4] }]; #IO_L20P_T3_12 Sch=vga_b[7]

set_property -dict { PACKAGE_PIN AJ23  IOSTANDARD LVCMOS33 } [get_ports { VGA_GREEN_O[0] }]; #IO_L21N_T3_DQS_12 Sch=vga_g[2]
set_property -dict { PACKAGE_PIN AJ22  IOSTANDARD LVCMOS33 } [get_ports { VGA_GREEN_O[1] }]; #IO_L21P_T3_DQS_12 Sch=vga_g[3]
set_property -dict { PACKAGE_PIN AH22  IOSTANDARD LVCMOS33 } [get_ports { VGA_GREEN_O[2] }]; #IO_L20N_T3_12 Sch=vga_g[4]
set_property -dict { PACKAGE_PIN AK21  IOSTANDARD LVCMOS33 } [get_ports { VGA_GREEN_O[3] }]; #IO_L24N_T3_12 Sch=vga_g[5]
set_property -dict { PACKAGE_PIN AJ21  IOSTANDARD LVCMOS33 } [get_ports { VGA_GREEN_O[4] }]; #IO_L23N_T3_12 Sch=vga_g[6]
set_property -dict { PACKAGE_PIN AK23  IOSTANDARD LVCMOS33 } [get_ports { VGA_GREEN_O[5] }]; #IO_L17P_T2_12 Sch=vga_g[7]

set_property -dict { PACKAGE_PIN AK25  IOSTANDARD LVCMOS33 } [get_ports { VGA_RED_O[0] }]; #IO_L15N_T2_DQS_12 Sch=vga_r[3]
set_property -dict { PACKAGE_PIN AG25  IOSTANDARD LVCMOS33 } [get_ports { VGA_RED_O[1] }]; #IO_L18P_T2_12 Sch=vga_r[4]
set_property -dict { PACKAGE_PIN AH25  IOSTANDARD LVCMOS33 } [get_ports { VGA_RED_O[2] }]; #IO_L18N_T2_12 Sch=vga_r[5]
set_property -dict { PACKAGE_PIN AK24  IOSTANDARD LVCMOS33 } [get_ports { VGA_RED_O[3] }]; #IO_L17N_T2_12 Sch=vga_r[6]
set_property -dict { PACKAGE_PIN AJ24  IOSTANDARD LVCMOS33 } [get_ports { VGA_RED_O[4] }]; #IO_L15P_T2_DQS_12 Sch=vga_r[7]

set_property -dict { PACKAGE_PIN AF20  IOSTANDARD LVCMOS33 } [get_ports { VGA_HS_O }]; #IO_L19P_T3_12 Sch=vga_hs
set_property -dict { PACKAGE_PIN AG23  IOSTANDARD LVCMOS33 } [get_ports { VGA_VS_O }]; #IO_L13N_T2_MRCC_12 Sch=vga_vs

## USB HIDs For Both Mouse and Keyboard
set_property -dict { PACKAGE_PIN AD23  IOSTANDARD LVCMOS33  PULLUP true } [get_ports { PS2_CLK }]; #IO_L12P_T1_MRCC_12 Sch=ps2_clk[0]
set_property -dict { PACKAGE_PIN AE20  IOSTANDARD LVCMOS33  PULLUP true } [get_ports { PS2_DATA }]; #IO_25_12 Sch=ps2_data[0]

## JTAG
# minimize routing delay

set_max_delay -to   [get_ports { tdo } ] 20
set_max_delay -from [get_ports { tms } ] 20
set_max_delay -from [get_ports { tdi } ] 20
set_max_delay -from [get_ports { trst_n } ] 20

# reset signal
set_false_path -from [get_ports { trst_n } ]
set_false_path -from [get_pins i_ddr/u_xlnx_mig_7_ddr3_mig/u_ddr3_infrastructure/rstdiv0_sync_r1_reg_rep/C]

# For random-number generator
set_property ALLOW_COMBINATORIAL_LOOPS true [get_nets {i_ariane_peripherals/gen_gpio.rng/x0[1]}]
set_disable_timing -from I -to O \i_ariane_peripherals/gen_gpio.rng/gio[0].bufx0_inst
