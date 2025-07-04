set_property SRC_FILE_INFO {cfile:c:/Users/LAB-qpsa/Documents/GitHub/RedPitaya-FPGA/prj/v0.94/project/redpitaya.srcs/sources_1/bd/system/ip/system_processing_system7_0/system_processing_system7_0/system_processing_system7_0_in_context.xdc rfile:../../../redpitaya.srcs/sources_1/bd/system/ip/system_processing_system7_0/system_processing_system7_0/system_processing_system7_0_in_context.xdc id:1 order:EARLY scoped_inst:ps/system_i/processing_system7} [current_design]
set_property SRC_FILE_INFO {cfile:C:/Users/LAB-qpsa/Documents/GitHub/RedPitaya-FPGA/prj/v0.94/project/redpitaya.srcs/constrs_1/imports/RedPitaya-FPGA/sdc/red_pitaya.xdc rfile:../../../redpitaya.srcs/constrs_1/imports/RedPitaya-FPGA/sdc/red_pitaya.xdc id:2} [current_design]
set_property SRC_FILE_INFO {cfile:C:/Users/LAB-qpsa/Documents/GitHub/RedPitaya-FPGA/prj/v0.94/project/redpitaya.srcs/constrs_1/imports/RedPitaya-FPGA/prj/v0.94/sdc/red_pitaya.xdc rfile:../../../redpitaya.srcs/constrs_1/imports/RedPitaya-FPGA/prj/v0.94/sdc/red_pitaya.xdc id:3} [current_design]
current_instance ps/system_i/processing_system7
set_property src_info {type:SCOPED_XDC file:1 line:2 export:INPUT save:INPUT read:READ} [current_design]
create_clock -period 5.000 [get_ports {}]
set_property src_info {type:SCOPED_XDC file:1 line:4 export:INPUT save:INPUT read:READ} [current_design]
create_clock -period 20.000 [get_ports {}]
set_property src_info {type:SCOPED_XDC file:1 line:6 export:INPUT save:INPUT read:READ} [current_design]
create_clock -period 8.000 [get_ports {}]
set_property src_info {type:SCOPED_XDC file:1 line:8 export:INPUT save:INPUT read:READ} [current_design]
create_clock -period 4.000 [get_ports {}]
current_instance
set_property src_info {type:XDC file:2 line:19 export:INPUT save:INPUT read:READ} [current_design]
set_property IOB        TRUE     [get_ports {adc_dat_i[*][*]}]
set_property src_info {type:XDC file:2 line:22 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN V17     [get_ports {adc_dat_i[0][0]}]
set_property src_info {type:XDC file:2 line:23 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN U17     [get_ports {adc_dat_i[0][1]}]
set_property src_info {type:XDC file:2 line:24 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN Y17     [get_ports {adc_dat_i[0][2]}]
set_property src_info {type:XDC file:2 line:25 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN W16     [get_ports {adc_dat_i[0][3]}]
set_property src_info {type:XDC file:2 line:26 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN Y16     [get_ports {adc_dat_i[0][4]}]
set_property src_info {type:XDC file:2 line:27 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN W15     [get_ports {adc_dat_i[0][5]}]
set_property src_info {type:XDC file:2 line:28 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN W14     [get_ports {adc_dat_i[0][6]}]
set_property src_info {type:XDC file:2 line:29 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN Y14     [get_ports {adc_dat_i[0][7]}]
set_property src_info {type:XDC file:2 line:30 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN W13     [get_ports {adc_dat_i[0][8]}]
set_property src_info {type:XDC file:2 line:31 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN V12     [get_ports {adc_dat_i[0][9]}]
set_property src_info {type:XDC file:2 line:32 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN V13     [get_ports {adc_dat_i[0][10]}]
set_property src_info {type:XDC file:2 line:33 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN T14     [get_ports {adc_dat_i[0][11]}]
set_property src_info {type:XDC file:2 line:34 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN T15     [get_ports {adc_dat_i[0][12]}]
set_property src_info {type:XDC file:2 line:35 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN V15     [get_ports {adc_dat_i[0][13]}]
set_property src_info {type:XDC file:2 line:36 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN T16     [get_ports {adc_dat_i[0][14]}]
set_property src_info {type:XDC file:2 line:37 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN V16     [get_ports {adc_dat_i[0][15]}]
set_property src_info {type:XDC file:2 line:40 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN T17     [get_ports {adc_dat_i[1][0]}]
set_property src_info {type:XDC file:2 line:41 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN R16     [get_ports {adc_dat_i[1][1]}]
set_property src_info {type:XDC file:2 line:42 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN R18     [get_ports {adc_dat_i[1][2]}]
set_property src_info {type:XDC file:2 line:43 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN P16     [get_ports {adc_dat_i[1][3]}]
set_property src_info {type:XDC file:2 line:44 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN P18     [get_ports {adc_dat_i[1][4]}]
set_property src_info {type:XDC file:2 line:45 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN N17     [get_ports {adc_dat_i[1][5]}]
set_property src_info {type:XDC file:2 line:46 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN R19     [get_ports {adc_dat_i[1][6]}]
set_property src_info {type:XDC file:2 line:47 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN T20     [get_ports {adc_dat_i[1][7]}]
set_property src_info {type:XDC file:2 line:48 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN T19     [get_ports {adc_dat_i[1][8]}]
set_property src_info {type:XDC file:2 line:49 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN U20     [get_ports {adc_dat_i[1][9]}]
set_property src_info {type:XDC file:2 line:50 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN V20     [get_ports {adc_dat_i[1][10]}]
set_property src_info {type:XDC file:2 line:51 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN W20     [get_ports {adc_dat_i[1][11]}]
set_property src_info {type:XDC file:2 line:52 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN W19     [get_ports {adc_dat_i[1][12]}]
set_property src_info {type:XDC file:2 line:53 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN Y19     [get_ports {adc_dat_i[1][13]}]
set_property src_info {type:XDC file:2 line:54 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN W18     [get_ports {adc_dat_i[1][14]}]
set_property src_info {type:XDC file:2 line:55 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN Y18     [get_ports {adc_dat_i[1][15]}]
set_property src_info {type:XDC file:2 line:58 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN U18           [get_ports adc_clk_i[1]]
set_property src_info {type:XDC file:2 line:59 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN U19           [get_ports adc_clk_i[0]]
set_property src_info {type:XDC file:2 line:67 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN N20 [get_ports {adc_clk_o[0]}]
set_property src_info {type:XDC file:2 line:68 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN P20 [get_ports {adc_clk_o[1]}]
set_property src_info {type:XDC file:2 line:72 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN V18     [get_ports adc_cdcs_o]
set_property src_info {type:XDC file:2 line:84 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN M19 [get_ports {dac_dat_o[0]}]
set_property src_info {type:XDC file:2 line:85 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN M20 [get_ports {dac_dat_o[1]}]
set_property src_info {type:XDC file:2 line:86 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN L19 [get_ports {dac_dat_o[2]}]
set_property src_info {type:XDC file:2 line:87 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN L20 [get_ports {dac_dat_o[3]}]
set_property src_info {type:XDC file:2 line:88 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN K19 [get_ports {dac_dat_o[4]}]
set_property src_info {type:XDC file:2 line:89 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN J19 [get_ports {dac_dat_o[5]}]
set_property src_info {type:XDC file:2 line:90 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN J20 [get_ports {dac_dat_o[6]}]
set_property src_info {type:XDC file:2 line:91 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN H20 [get_ports {dac_dat_o[7]}]
set_property src_info {type:XDC file:2 line:92 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN G19 [get_ports {dac_dat_o[8]}]
set_property src_info {type:XDC file:2 line:93 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN G20 [get_ports {dac_dat_o[9]}]
set_property src_info {type:XDC file:2 line:94 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN F19 [get_ports {dac_dat_o[10]}]
set_property src_info {type:XDC file:2 line:95 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN F20 [get_ports {dac_dat_o[11]}]
set_property src_info {type:XDC file:2 line:96 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN D20 [get_ports {dac_dat_o[12]}]
set_property src_info {type:XDC file:2 line:97 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN D19 [get_ports {dac_dat_o[13]}]
set_property src_info {type:XDC file:2 line:105 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN M17 [get_ports dac_wrt_o]
set_property src_info {type:XDC file:2 line:106 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN N16 [get_ports dac_sel_o]
set_property src_info {type:XDC file:2 line:107 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN M18 [get_ports dac_clk_o]
set_property src_info {type:XDC file:2 line:108 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN N15 [get_ports dac_rst_o]
set_property src_info {type:XDC file:2 line:114 export:INPUT save:INPUT read:READ} [current_design]
set_property IOB        TRUE     [get_ports {dac_pwm_o[*]}]
set_property src_info {type:XDC file:2 line:116 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN T10 [get_ports {dac_pwm_o[0]}]
set_property src_info {type:XDC file:2 line:117 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN T11 [get_ports {dac_pwm_o[1]}]
set_property src_info {type:XDC file:2 line:118 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN P15 [get_ports {dac_pwm_o[2]}]
set_property src_info {type:XDC file:2 line:119 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN U13 [get_ports {dac_pwm_o[3]}]
set_property src_info {type:XDC file:2 line:125 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN C20 [get_ports {vinp_i[1]}]
set_property src_info {type:XDC file:2 line:126 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN B20 [get_ports {vinn_i[1]}]
set_property src_info {type:XDC file:2 line:128 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN E17 [get_ports {vinp_i[2]}]
set_property src_info {type:XDC file:2 line:129 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN D18 [get_ports {vinn_i[2]}]
set_property src_info {type:XDC file:2 line:131 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN B19 [get_ports {vinp_i[0]}]
set_property src_info {type:XDC file:2 line:132 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN A20 [get_ports {vinn_i[0]}]
set_property src_info {type:XDC file:2 line:134 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN E18 [get_ports {vinp_i[3]}]
set_property src_info {type:XDC file:2 line:135 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN E19 [get_ports {vinn_i[3]}]
set_property src_info {type:XDC file:2 line:137 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN K9  [get_ports {vinp_i[4]}]
set_property src_info {type:XDC file:2 line:138 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN L10 [get_ports {vinn_i[4]}]
set_property src_info {type:XDC file:2 line:148 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN G17 [get_ports {exp_p_io[0]}]
set_property src_info {type:XDC file:2 line:149 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN G18 [get_ports {exp_n_io[0]}]
set_property src_info {type:XDC file:2 line:150 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN H16 [get_ports {exp_p_io[1]}]
set_property src_info {type:XDC file:2 line:151 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN H17 [get_ports {exp_n_io[1]}]
set_property src_info {type:XDC file:2 line:152 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN J18 [get_ports {exp_p_io[2]}]
set_property src_info {type:XDC file:2 line:153 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN H18 [get_ports {exp_n_io[2]}]
set_property src_info {type:XDC file:2 line:154 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN K17 [get_ports {exp_p_io[3]}]
set_property src_info {type:XDC file:2 line:155 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN K18 [get_ports {exp_n_io[3]}]
set_property src_info {type:XDC file:2 line:156 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN L14 [get_ports {exp_p_io[4]}]
set_property src_info {type:XDC file:2 line:157 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN L15 [get_ports {exp_n_io[4]}]
set_property src_info {type:XDC file:2 line:158 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN L16 [get_ports {exp_p_io[5]}]
set_property src_info {type:XDC file:2 line:159 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN L17 [get_ports {exp_n_io[5]}]
set_property src_info {type:XDC file:2 line:160 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN K16 [get_ports {exp_p_io[6]}]
set_property src_info {type:XDC file:2 line:161 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN J16 [get_ports {exp_n_io[6]}]
set_property src_info {type:XDC file:2 line:162 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN M14 [get_ports {exp_p_io[7]}]
set_property src_info {type:XDC file:2 line:163 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN M15 [get_ports {exp_n_io[7]}]
set_property src_info {type:XDC file:2 line:164 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN Y9  [get_ports {exp_p_io[8]}]
set_property src_info {type:XDC file:2 line:165 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN Y8  [get_ports {exp_n_io[8]}]
set_property src_info {type:XDC file:2 line:166 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN Y12 [get_ports {exp_p_io[9]}]
set_property src_info {type:XDC file:2 line:167 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN Y13 [get_ports {exp_n_io[9]}]
set_property src_info {type:XDC file:2 line:168 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN Y7  [get_ports {exp_p_io[10]}]
set_property src_info {type:XDC file:2 line:169 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN Y6  [get_ports {exp_n_io[10]}]
set_property src_info {type:XDC file:2 line:176 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN T12 [get_ports {daisy_p_o[0]}]
set_property src_info {type:XDC file:2 line:177 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN U12 [get_ports {daisy_n_o[0]}]
set_property src_info {type:XDC file:2 line:178 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN U14 [get_ports {daisy_p_o[1]}]
set_property src_info {type:XDC file:2 line:179 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN U15 [get_ports {daisy_n_o[1]}]
set_property src_info {type:XDC file:2 line:180 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN P14 [get_ports {daisy_p_i[0]}]
set_property src_info {type:XDC file:2 line:181 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN R14 [get_ports {daisy_n_i[0]}]
set_property src_info {type:XDC file:2 line:182 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN N18 [get_ports {daisy_p_i[1]}]
set_property src_info {type:XDC file:2 line:183 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN P19 [get_ports {daisy_n_i[1]}]
set_property src_info {type:XDC file:2 line:190 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN F16     [get_ports {led_o[0]}]
set_property src_info {type:XDC file:2 line:191 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN F17     [get_ports {led_o[1]}]
set_property src_info {type:XDC file:2 line:192 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN G15     [get_ports {led_o[2]}]
set_property src_info {type:XDC file:2 line:193 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN H15     [get_ports {led_o[3]}]
set_property src_info {type:XDC file:2 line:194 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN K14     [get_ports {led_o[4]}]
set_property src_info {type:XDC file:2 line:195 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN G14     [get_ports {led_o[5]}]
set_property src_info {type:XDC file:2 line:196 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN J15     [get_ports {led_o[6]}]
set_property src_info {type:XDC file:2 line:197 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN J14     [get_ports {led_o[7]}]
set_property src_info {type:XDC file:2 line:212 export:INPUT save:INPUT read:READ} [current_design]
set_false_path -from [get_clocks adc_clk]     -to [get_clocks dac_clk_o]
set_property src_info {type:XDC file:2 line:213 export:INPUT save:INPUT read:READ} [current_design]
set_false_path -from [get_clocks adc_clk]     -to [get_clocks dac_clk_2x]
set_property src_info {type:XDC file:2 line:214 export:INPUT save:INPUT read:READ} [current_design]
set_false_path -from [get_clocks adc_clk]     -to [get_clocks dac_clk_2p]
set_property src_info {type:XDC file:2 line:215 export:INPUT save:INPUT read:READ} [current_design]
set_false_path -from [get_clocks clk_fpga_0]  -to [get_clocks adc_clk]
set_property src_info {type:XDC file:2 line:216 export:INPUT save:INPUT read:READ} [current_design]
set_false_path -from [get_clocks clk_fpga_0]  -to [get_clocks pll_adc_clk]
set_property src_info {type:XDC file:2 line:219 export:INPUT save:INPUT read:READ} [current_design]
set_false_path -from [get_clocks clk_fpga_0]  -to [get_clocks dac_clk_1x]
set_property src_info {type:XDC file:2 line:220 export:INPUT save:INPUT read:READ} [current_design]
set_false_path -from [get_clocks clk_fpga_0]  -to [get_clocks dac_clk_2x]
set_property src_info {type:XDC file:2 line:221 export:INPUT save:INPUT read:READ} [current_design]
set_false_path -from [get_clocks clk_fpga_0]  -to [get_clocks dac_clk_2p]
set_property src_info {type:XDC file:2 line:222 export:INPUT save:INPUT read:READ} [current_design]
set_false_path -from [get_clocks clk_fpga_0]  -to [get_clocks ser_clk]
set_property src_info {type:XDC file:2 line:223 export:INPUT save:INPUT read:READ} [current_design]
set_false_path -from [get_clocks clk_fpga_0]  -to [get_clocks pdm_clk]
set_property src_info {type:XDC file:2 line:224 export:INPUT save:INPUT read:READ} [current_design]
set_false_path -from [get_clocks dac_clk_o] -to [get_clocks dac_clk_2x]
set_property src_info {type:XDC file:2 line:225 export:INPUT save:INPUT read:READ} [current_design]
set_false_path -from [get_clocks dac_clk_o] -to [get_clocks dac_clk_2p]
set_property src_info {type:XDC file:3 line:1 export:INPUT save:INPUT read:READ} [current_design]
set_property LOC XADC_X0Y0 [get_cells i_ams/XADC_inst]
set_property src_info {type:XDC file:3 line:7 export:INPUT save:INPUT read:READ} [current_design]
set_false_path -from [get_clocks adc_clk]     -to [get_clocks dac_clk_out]
set_property src_info {type:XDC file:3 line:8 export:INPUT save:INPUT read:READ} [current_design]
set_false_path -from [get_clocks clk_fpga_0]  -to [get_clocks ser_clk_out]
set_property src_info {type:XDC file:3 line:9 export:INPUT save:INPUT read:READ} [current_design]
set_false_path -from [get_clocks clk_fpga_0]  -to [get_clocks dac_2clk_out]
set_property src_info {type:XDC file:3 line:10 export:INPUT save:INPUT read:READ} [current_design]
set_false_path -from [get_clocks clk_fpga_0]  -to [get_clocks adc_clk]
set_property src_info {type:XDC file:3 line:11 export:INPUT save:INPUT read:READ} [current_design]
set_false_path -from [get_clocks clk_fpga_0]  -to [get_clocks par_clk]
set_property src_info {type:XDC file:3 line:12 export:INPUT save:INPUT read:READ} [current_design]
set_false_path -from [get_clocks dac_clk_out] -to [get_clocks dac_2clk_out]
set_property src_info {type:XDC file:3 line:13 export:INPUT save:INPUT read:READ} [current_design]
set_false_path -from [get_clocks dac_clk_out] -to [get_clocks dac_2ph_out]
