////////////////////////////////////////////////////////////////////////////////
// Red Pitaya TOP module. It connects external pins and PS part with
// other application modules.
// Authors: Matej Oblak, Iztok Jeras
// (c) Red Pitaya  http://www.redpitaya.com
////////////////////////////////////////////////////////////////////////////////

/**
 * GENERAL DESCRIPTION:
 *
 * Top module connects PS part with rest of Red Pitaya applications.  
 *
 *                   /-------\      
 *   PS DDR <------> |  PS   |      AXI <-> custom bus
 *   PS MIO <------> |   /   | <------------+
 *   PS CLK -------> |  ARM  |              |
 *                   \-------/              |
 *                                          |
 *                            /-------\     |
 *                         -> | SCOPE | <---+
 *                         |  \-------/     |
 *                         |                |
 *            /--------\   |   /-----\      |
 *   ADC ---> |        | --+-> |     |      |
 *            | ANALOG |       | PID | <----+
 *   DAC <--- |        | <---- |     |      |
 *            \--------/   ^   \-----/      |
 *                         |                |
 *                         |  /-------\     |
 *                         -- |  ASG  | <---+ 
 *                            \-------/     |
 *                                          |
 *             /--------\                   |
 *    RX ----> |        |                   |
 *   SATA      | DAISY  | <-----------------+
 *    TX <---- |        | 
 *             \--------/ 
 *               |    |
 *               |    |
 *               (FREE)
 *
 * Inside analog module, ADC data is translated from unsigned neg-slope into
 * two's complement. Similar is done on DAC data.
 *
 * Scope module stores data from ADC into RAM, arbitrary signal generator (ASG)
 * sends data from RAM to DAC. MIMO PID uses ADC ADC as input and DAC as its output.
 *
 * Daisy chain connects with other boards with fast serial link. Data which is
 * send and received is at the moment undefined. This is left for the user.
 */

module red_pitaya_top #(
  // identification
  bit [0:5*32-1] GITH = '0,
  // module numbers
  parameter MNA = 2,  // number of acquisition modules
  parameter MNG = 2,  // number of generator   modules
  parameter DWE_Z10 = 8,
  parameter DWE_Z20 = 11,
`ifdef Z20_14
  parameter DWE=DWE_Z20
`else
  parameter DWE=DWE_Z10
`endif


)(
  // PS connections
  inout  logic [54-1:0] FIXED_IO_mio     ,
  inout  logic          FIXED_IO_ps_clk  ,
  inout  logic          FIXED_IO_ps_porb ,
  inout  logic          FIXED_IO_ps_srstb,
  inout  logic          FIXED_IO_ddr_vrn ,
  inout  logic          FIXED_IO_ddr_vrp ,
  // DDR
  inout  logic [15-1:0] DDR_addr   ,
  inout  logic [ 3-1:0] DDR_ba     ,
  inout  logic          DDR_cas_n  ,
  inout  logic          DDR_ck_n   ,
  inout  logic          DDR_ck_p   ,
  inout  logic          DDR_cke    ,
  inout  logic          DDR_cs_n   ,
  inout  logic [ 4-1:0] DDR_dm     ,
  inout  logic [32-1:0] DDR_dq     ,
  inout  logic [ 4-1:0] DDR_dqs_n  ,
  inout  logic [ 4-1:0] DDR_dqs_p  ,
  inout  logic          DDR_odt    ,
  inout  logic          DDR_ras_n  ,
  inout  logic          DDR_reset_n,
  inout  logic          DDR_we_n   ,

  // Red Pitaya periphery

  // ADC
  input  logic [MNA-1:0] [16-1:0] adc_dat_i,  // ADC data
  input  logic           [ 2-1:0] adc_clk_i,  // ADC clock {p,n}
  output logic           [ 2-1:0] adc_clk_o,  // optional ADC clock source (unused) [0] = p; [1] = n
  output logic                    adc_cdcs_o, // ADC clock duty cycle stabilizer
  // DAC
  output logic [14-1:0] dac_dat_o  ,  // DAC combined data
  output logic          dac_wrt_o  ,  // DAC write
  output logic          dac_sel_o  ,  // DAC channel select
  output logic          dac_clk_o  ,  // DAC clock
  output logic          dac_rst_o  ,  // DAC reset
  // PWM DAC
  output logic [ 4-1:0] dac_pwm_o  ,  // 1-bit PWM DAC
  // XADC
  input  logic [ 5-1:0] vinp_i     ,  // voltages p
  input  logic [ 5-1:0] vinn_i     ,  // voltages n
  // Expansion connector
  inout  logic [DWE-1:0] exp_p_io  ,
  inout  logic [DWE-1:0] exp_n_io  ,
  // SATA connector
  output logic [ 2-1:0] daisy_p_o  ,  // line 1 is clock capable
  output logic [ 2-1:0] daisy_n_o  ,
  input  logic [ 2-1:0] daisy_p_i  ,  // line 1 is clock capable
  input  logic [ 2-1:0] daisy_n_i  ,
  // LED
  output  logic [ 8-1:0] led_o
);

////////////////////////////////////////////////////////////////////////////////
// local signals
////////////////////////////////////////////////////////////////////////////////

// GPIO input data width


localparam int unsigned GDW = DWE;

logic [4-1:0] fclk ; //[0]-125MHz, [1]-250MHz, [2]-50MHz, [3]-200MHz
logic [4-1:0] frstn;

logic [16-1:0] par_dat;

logic          daisy_trig;
logic [ 3-1:0] daisy_mode;
logic          trig_ext;
logic          trig_output_sel;
logic          trig_asg_out;
logic [ 4-1:0] trig_ext_asg01;

// AXI masters
logic            axi1_clk    , axi0_clk    ;
logic            axi1_rstn   , axi0_rstn   ;
logic [ 32-1: 0] axi1_waddr  , axi0_waddr  ;
logic [ 64-1: 0] axi1_wdata  , axi0_wdata  ;
logic [  8-1: 0] axi1_wsel   , axi0_wsel   ;
logic            axi1_wvalid , axi0_wvalid ;
logic [  4-1: 0] axi1_wlen   , axi0_wlen   ;
logic            axi1_wfixed , axi0_wfixed ;
logic            axi1_werr   , axi0_werr   ;
logic            axi1_wrdy   , axi0_wrdy   ;

// PLL signals
logic                 adc_clk_in;
logic                 pll_adc_clk;
logic                 pll_dac_clk_1x;
logic                 pll_dac_clk_2x;
logic                 pll_dac_clk_2p;
logic                 pll_ser_clk;
logic                 pll_pwm_clk;
logic                 pll_locked;
// fast serial signals
logic                 ser_clk ;
// PWM clock and reset
logic                 pwm_clk ;
logic                 pwm_rstn;

// ADC clock/reset
logic                 adc_clk;
logic                 adc_rstn;
logic                 adc_clk_daisy;
logic                 scope_trigo;

//CAN
logic                 CAN0_rx, CAN0_tx;
logic                 CAN1_rx, CAN1_tx;
logic                 can_on;


// stream bus type
localparam type SBA_T = logic signed [14-1:0];  // acquire
localparam type SBG_T = logic signed [14-1:0];  // generate

SBA_T [MNA-1:0]          adc_dat;

// DAC signals
logic                    dac_clk_1x;
logic                    dac_clk_2x;
logic                    dac_clk_2p;
logic                    dac_rst;

logic        [14-1:0] dac_dat_a, dac_dat_b;
logic        [14-1:0] dac_a    , dac_b    ;
logic signed [15-1:0] dac_a_sum, dac_b_sum;

// ASG
SBG_T [2-1:0]            asg_dat;

// PID
SBA_T [2-1:0]            pid_dat;

// configuration
logic                    digital_loop;

// system bus
sys_bus_if   ps_sys      (.clk (adc_clk), .rstn (adc_rstn));
sys_bus_if   sys [8-1:0] (.clk (adc_clk), .rstn (adc_rstn));

// GPIO interface
gpio_if #(.DW (3*GDW)) gpio ();

////////////////////////////////////////////////////////////////////////////////
// PLL (clock and reset)
////////////////////////////////////////////////////////////////////////////////

// diferential clock input
IBUFDS i_clk (.I (adc_clk_i[1]), .IB (adc_clk_i[0]), .O (adc_clk_in));  // differential clock input

red_pitaya_pll pll (
  // inputs
  .clk         (adc_clk_in),  // clock
  .rstn        (frstn[0]  ),  // reset - active low
  // output clocks
  .clk_adc     (pll_adc_clk   ),  // ADC clock
  .clk_dac_1x  (pll_dac_clk_1x),  // DAC clock 125MHz
  .clk_dac_2x  (pll_dac_clk_2x),  // DAC clock 250MHz
  .clk_dac_2p  (pll_dac_clk_2p),  // DAC clock 250MHz -45DGR
  .clk_ser     (pll_ser_clk   ),  // fast serial clock
  .clk_pdm     (pll_pwm_clk   ),  // PWM clock
  // status outputs
  .pll_locked  (pll_locked)
);

BUFG bufg_adc_clk    (.O (adc_clk   ), .I (pll_adc_clk   ));
BUFG bufg_dac_clk_1x (.O (dac_clk_1x), .I (pll_dac_clk_1x));
BUFG bufg_dac_clk_2x (.O (dac_clk_2x), .I (pll_dac_clk_2x));
BUFG bufg_dac_clk_2p (.O (dac_clk_2p), .I (pll_dac_clk_2p));
BUFG bufg_ser_clk    (.O (ser_clk   ), .I (pll_ser_clk   ));
BUFG bufg_pwm_clk    (.O (pwm_clk   ), .I (pll_pwm_clk   ));

logic [32-1:0] locked_pll_cnt, locked_pll_cnt_r, locked_pll_cnt_r2 ;
always @(posedge fclk[0]) begin
  if (~frstn[0])
    locked_pll_cnt <= 'h0;
  else if (~pll_locked)
    locked_pll_cnt <= locked_pll_cnt + 'h1;
end

always @(posedge adc_clk) begin
  locked_pll_cnt_r  <= locked_pll_cnt;
  locked_pll_cnt_r2 <= locked_pll_cnt_r;
end

// ADC reset (active low)
always @(posedge adc_clk)
adc_rstn <=  frstn[0] &  pll_locked;

// DAC reset (active high)
always @(posedge dac_clk_1x)
dac_rst  <= ~frstn[0] | ~pll_locked;

// PWM reset (active low)
always @(posedge pwm_clk)
pwm_rstn <=  frstn[0] &  pll_locked;


assign daisy_trig = |par_dat;
assign trig_ext   = gpio.i[GDW] & ~(daisy_mode[0] & daisy_trig);
////////////////////////////////////////////////////////////////////////////////
//  Connections to PS
////////////////////////////////////////////////////////////////////////////////

red_pitaya_ps ps (
  .FIXED_IO_mio       (  FIXED_IO_mio                ),
  .FIXED_IO_ps_clk    (  FIXED_IO_ps_clk             ),
  .FIXED_IO_ps_porb   (  FIXED_IO_ps_porb            ),
  .FIXED_IO_ps_srstb  (  FIXED_IO_ps_srstb           ),
  .FIXED_IO_ddr_vrn   (  FIXED_IO_ddr_vrn            ),
  .FIXED_IO_ddr_vrp   (  FIXED_IO_ddr_vrp            ),
  // DDR
  .DDR_addr      (DDR_addr    ),
  .DDR_ba        (DDR_ba      ),
  .DDR_cas_n     (DDR_cas_n   ),
  .DDR_ck_n      (DDR_ck_n    ),
  .DDR_ck_p      (DDR_ck_p    ),
  .DDR_cke       (DDR_cke     ),
  .DDR_cs_n      (DDR_cs_n    ),
  .DDR_dm        (DDR_dm      ),
  .DDR_dq        (DDR_dq      ),
  .DDR_dqs_n     (DDR_dqs_n   ),
  .DDR_dqs_p     (DDR_dqs_p   ),
  .DDR_odt       (DDR_odt     ),
  .DDR_ras_n     (DDR_ras_n   ),
  .DDR_reset_n   (DDR_reset_n ),
  .DDR_we_n      (DDR_we_n    ),
  // system signals
  .fclk_clk_o    (fclk        ),
  .fclk_rstn_o   (frstn       ),
  // ADC analog inputs
  .vinp_i        (vinp_i      ),
  .vinn_i        (vinn_i      ),
  // CAN0
  .CAN0_rx       (CAN0_rx     ),
  .CAN0_tx       (CAN0_tx     ),
  // CAN1
  .CAN1_rx       (CAN1_rx     ),
  .CAN1_tx       (CAN1_tx     ),
  // GPIO
  .gpio          (gpio),
  // system read/write channel
  .bus           (ps_sys      ),
  // AXI masters
  .axi1_clk_i    (axi1_clk    ),  .axi0_clk_i    (axi0_clk    ),  // global clock
  .axi1_rstn_i   (axi1_rstn   ),  .axi0_rstn_i   (axi0_rstn   ),  // global reset
  .axi1_waddr_i  (axi1_waddr  ),  .axi0_waddr_i  (axi0_waddr  ),  // system write address
  .axi1_wdata_i  (axi1_wdata  ),  .axi0_wdata_i  (axi0_wdata  ),  // system write data
  .axi1_wsel_i   (axi1_wsel   ),  .axi0_wsel_i   (axi0_wsel   ),  // system write byte select
  .axi1_wvalid_i (axi1_wvalid ),  .axi0_wvalid_i (axi0_wvalid ),  // system write data valid
  .axi1_wlen_i   (axi1_wlen   ),  .axi0_wlen_i   (axi0_wlen   ),  // system write burst length
  .axi1_wfixed_i (axi1_wfixed ),  .axi0_wfixed_i (axi0_wfixed ),  // system write burst type (fixed / incremental)
  .axi1_werr_o   (axi1_werr   ),  .axi0_werr_o   (axi0_werr   ),  // system write error
  .axi1_wrdy_o   (axi1_wrdy   ),  .axi0_wrdy_o   (axi0_wrdy   )   // system write ready
);

////////////////////////////////////////////////////////////////////////////////
// system bus decoder & multiplexer (it breaks memory addresses into 8 regions)
////////////////////////////////////////////////////////////////////////////////

sys_bus_interconnect #(
  .SN (8),
  .SW (20)
) sys_bus_interconnect (
  .bus_m (ps_sys),
  .bus_s (sys)
);

// silence unused busses
generate
for (genvar i=6; i<8; i++) begin: for_sys
  sys_bus_stub sys_bus_stub_5_7 (sys[i]);
end: for_sys
endgenerate

////////////////////////////////////////////////////////////////////////////////
// Analog mixed signals (PDM analog outputs)
////////////////////////////////////////////////////////////////////////////////

//logic [4-1:0] [8-1:0] pdm_cfg;

//red_pitaya_ams i_ams (
//  // power test
//  .clk_i           (adc_clk ),  // clock
//  .rstn_i          (adc_rstn),  // reset - active low
//  // PWM configuration
//  .dac_a_o         (pdm_cfg[0]),
//  .dac_b_o         (pdm_cfg[1]),
//  .dac_c_o         (pdm_cfg[2]),
//  .dac_d_o         (pdm_cfg[3]),
//  // System bus
//  .sys_addr        (sys[4].addr ),
//  .sys_wdata       (sys[4].wdata),
//  .sys_wen         (sys[4].wen  ),
//  .sys_ren         (sys[4].ren  ),
//  .sys_rdata       (sys[4].rdata),
//  .sys_err         (sys[4].err  ),
//  .sys_ack         (sys[4].ack  )
//);

//red_pitaya_pdm pdm (
//  // system signals
//  .clk   (adc_clk ),
//  .rstn  (adc_rstn),
//  // configuration
//  .cfg   (pdm_cfg),
//  .ena      (1'b1),
//  .rng      (8'd255),
//  // PWM outputs
//  .pdm (dac_pwm_o)
//);

////////////////////////////////////////////////////////////////////////////////
// ADC IO
////////////////////////////////////////////////////////////////////////////////

ODDR i_adc_clk_p ( .Q(adc_clk_o[0]), .D1(1'b1), .D2(1'b0), .C(adc_clk_daisy), .CE(1'b1), .R(1'b0), .S(1'b0));
ODDR i_adc_clk_n ( .Q(adc_clk_o[1]), .D1(1'b0), .D2(1'b1), .C(adc_clk_daisy), .CE(1'b1), .R(1'b0), .S(1'b0));

assign adc_cdcs_o = 1'b1 ;

logic [2-1:0] [14-1:0] adc_dat_raw;

// IO block registers should be used here
// lowest 2 bits reserved for 16bit ADC

assign adc_dat_raw[0] = adc_dat_i[0][16-1:2];
assign adc_dat_raw[1] = adc_dat_i[1][16-1:2];

// transform into 2's complement (negative slope)
always @(posedge adc_clk) begin
  adc_dat[0] <= digital_loop ? dac_a : {adc_dat_raw[0][14-1], ~adc_dat_raw[0][14-2:0]};
  adc_dat[1] <= digital_loop ? dac_b : {adc_dat_raw[1][14-1], ~adc_dat_raw[1][14-2:0]};
end

////////////////////////////////////////////////////////////////////////////////
// DAC IO
////////////////////////////////////////////////////////////////////////////////

// Sumation of ASG and PID signal perform saturation before sending to DAC 
assign dac_a_sum = asg_dat[0] + pid_dat[0];
assign dac_b_sum = asg_dat[1] + pid_dat[1];

// saturation
//assign dac_a = (^dac_a_sum[15-1:15-2]) ? {dac_a_sum[15-1], {13{~dac_a_sum[15-1]}}} : dac_a_sum[14-1:0];
//assign dac_b = (^dac_b_sum[15-1:15-2]) ? {dac_b_sum[15-1], {13{~dac_b_sum[15-1]}}} : dac_b_sum[14-1:0];

// output registers + signed to unsigned (also to negative slope)
always @(posedge dac_clk_1x)
begin
  dac_dat_a <= {dac_a[14-1], ~dac_a[14-2:0]};
  dac_dat_b <= {dac_b[14-1], ~dac_b[14-2:0]};
end

// DDR outputs
ODDR oddr_dac_clk          (.Q(dac_clk_o), .D1(1'b0     ), .D2(1'b1     ), .C(dac_clk_2p), .CE(1'b1), .R(1'b0   ), .S(1'b0));
ODDR oddr_dac_wrt          (.Q(dac_wrt_o), .D1(1'b0     ), .D2(1'b1     ), .C(dac_clk_2x), .CE(1'b1), .R(1'b0   ), .S(1'b0));
ODDR oddr_dac_sel          (.Q(dac_sel_o), .D1(1'b1     ), .D2(1'b0     ), .C(dac_clk_1x), .CE(1'b1), .R(dac_rst), .S(1'b0));
ODDR oddr_dac_rst          (.Q(dac_rst_o), .D1(dac_rst  ), .D2(dac_rst  ), .C(dac_clk_1x), .CE(1'b1), .R(1'b0   ), .S(1'b0));
ODDR oddr_dac_dat [14-1:0] (.Q(dac_dat_o), .D1(dac_dat_b), .D2(dac_dat_a), .C(dac_clk_1x), .CE(1'b1), .R(dac_rst), .S(1'b0));

////////////////////////////////////////////////////////////////////////////////
//  House Keeping
////////////////////////////////////////////////////////////////////////////////

logic [DWE-1: 0] exp_p_in ,  exp_n_in ;
logic [DWE-1: 0] exp_p_out,  exp_n_out;
logic [DWE-1: 0] exp_p_dir,  exp_n_dir;
logic [DWE-1: 0] exp_p_otr,  exp_n_otr;
logic [DWE-1: 0] exp_p_dtr,  exp_n_dtr;
logic [DWE-1: 0] exp_p_alt,  exp_n_alt;
logic [DWE-1: 0] exp_p_altr, exp_n_altr;
logic [DWE-1: 0] exp_p_altd, exp_n_altd;

red_pitaya_hk #(.DWE(DWE)) i_hk (
  // system signals
  .clk_i           (adc_clk ),  // clock
  .rstn_i          (adc_rstn),  // reset - active low
  // LED
  //.led_o           (  led_o                      ),  // LED output
  // global configuration
  .digital_loop    (digital_loop),
  .daisy_mode_o    (daisy_mode),
  // Expansion connector
  .exp_p_dat_i     (exp_p_in ),  // input data
  .exp_p_dat_o     (exp_p_out),  // output data
  .exp_p_dir_o     (exp_p_dir),  // 1-output enable
  .exp_n_dat_i     (exp_n_in ),
  .exp_n_dat_o     (exp_n_out),
  .exp_n_dir_o     (exp_n_dir),
  .diag_i          (locked_pll_cnt_r2),
  .can_on_o        (can_on   ),
   // System bus
  .sys_addr        (sys[0].addr ),
  .sys_wdata       (sys[0].wdata),
  .sys_wen         (sys[0].wen  ),
  .sys_ren         (sys[0].ren  ),
  .sys_rdata       (sys[0].rdata),
  .sys_err         (sys[0].err  ),
  .sys_ack         (sys[0].ack  )
);

////////////////////////////////////////////////////////////////////////////////
// LED
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// GPIO
////////////////////////////////////////////////////////////////////////////////

assign trig_output_sel = daisy_mode[2] ? trig_asg_out : scope_trigo;

assign exp_p_alt  = {DWE{1'b0}};
assign exp_n_alt  = {{DWE-8{1'b0}},  can_on,  can_on, 5'h0, daisy_mode[1]  };

assign exp_p_altr = {DWE{1'b0}};
assign exp_n_altr = {{DWE-8{1'b0}}, CAN0_tx, CAN1_tx, 5'h0, trig_output_sel};

assign exp_p_altd = {DWE{1'b0}};
assign exp_n_altd = {{DWE-8{1'b0}},   1'b1,   1'b1, 5'h0, 1'b1};

genvar GM;
generate
for(GM = 0 ; GM < DWE ; GM = GM + 1) begin : gpios
  assign exp_p_otr[GM] = exp_p_alt[GM] ? exp_p_altr[GM] : exp_p_out[GM];
  assign exp_n_otr[GM] = exp_n_alt[GM] ? exp_n_altr[GM] : exp_n_out[GM];

  assign exp_p_dtr[GM] = exp_p_alt[GM] ? exp_p_altd[GM] : exp_p_dir[GM];
  assign exp_n_dtr[GM] = exp_n_alt[GM] ? exp_n_altd[GM] : exp_n_dir[GM];
end
endgenerate

IOBUF i_iobufp [DWE-1:0] (.O(exp_p_in), .IO(exp_p_io), .I(exp_p_otr), .T(~exp_p_dtr) );
IOBUF i_iobufn [DWE-1:0] (.O(exp_n_in), .IO(exp_n_io), .I(exp_n_otr), .T(~exp_n_dtr) );

assign gpio.i[2*GDW-1:  GDW] = exp_p_in[GDW-1:0];
assign gpio.i[3*GDW-1:2*GDW] = exp_n_in[GDW-1:0];

assign CAN0_rx = can_on & exp_p_in[7];
assign CAN1_rx = can_on & exp_p_in[6];

////////////////////////////////////////////////////////////////////////////////
// oscilloscope
////////////////////////////////////////////////////////////////////////////////


//red_pitaya_scope i_scope (
//  // ADC
//  .adc_a_i       (adc_dat[0]  ),  // CH 1
//  .adc_b_i       (adc_dat[1]  ),  // CH 2
//  .adc_clk_i     (adc_clk     ),  // clock
//  .adc_rstn_i    (adc_rstn    ),  // reset - active low
//  .trig_ext_i    (trig_ext    ),  // external trigger
//  .trig_asg_i    (trig_asg_out),  // ASG trigger
//  .trig_ext_asg_o(trig_ext_asg01),
//  .trig_ext_asg_i(trig_ext_asg01),
//  .daisy_trig_o  (scope_trigo ),
//  // AXI0 master                 // AXI1 master
//  .axi0_clk_o    (axi0_clk   ),  .axi1_clk_o    (axi1_clk   ),
//  .axi0_rstn_o   (axi0_rstn  ),  .axi1_rstn_o   (axi1_rstn  ),
//  .axi0_waddr_o  (axi0_waddr ),  .axi1_waddr_o  (axi1_waddr ),
//  .axi0_wdata_o  (axi0_wdata ),  .axi1_wdata_o  (axi1_wdata ),
//  .axi0_wsel_o   (axi0_wsel  ),  .axi1_wsel_o   (axi1_wsel  ),
//  .axi0_wvalid_o (axi0_wvalid),  .axi1_wvalid_o (axi1_wvalid),
//  .axi0_wlen_o   (axi0_wlen  ),  .axi1_wlen_o   (axi1_wlen  ),
//  .axi0_wfixed_o (axi0_wfixed),  .axi1_wfixed_o (axi1_wfixed),
//  .axi0_werr_i   (axi0_werr  ),  .axi1_werr_i   (axi1_werr  ),
//  .axi0_wrdy_i   (axi0_wrdy  ),  .axi1_wrdy_i   (axi1_wrdy  ),
//  // System bus
//  .sys_addr      (sys[1].addr ),
//  .sys_wdata     (sys[1].wdata),
//  .sys_wen       (sys[1].wen  ),
//  .sys_ren       (sys[1].ren  ),
//  .sys_rdata     (sys[1].rdata),
//  .sys_err       (sys[1].err  ),
//  .sys_ack       (sys[1].ack  )
//);

////////////////////////////////////////////////////////////////////////////////
//  DAC arbitrary signal generator
////////////////////////////////////////////////////////////////////////////////


//red_pitaya_asg i_asg (
//   // DAC
//  .dac_a_o         (asg_dat[0]  ),  // CH 1
//  .dac_b_o         (asg_dat[1]  ),  // CH 2
//  .dac_clk_i       (adc_clk     ),  // clock
//  .dac_rstn_i      (adc_rstn    ),  // reset - active low
//  .trig_a_i        (trig_ext    ),
//  .trig_b_i        (trig_ext    ),
//  .trig_out_o      (trig_asg_out),
//  // System bus
//  .sys_addr        (sys[2].addr ),
//  .sys_wdata       (sys[2].wdata),
//  .sys_wen         (sys[2].wen  ),
//  .sys_ren         (sys[2].ren  ),
//  .sys_rdata       (sys[2].rdata),
//  .sys_err         (sys[2].err  ),
//  .sys_ack         (sys[2].ack  )
//);

////////////////////////////////////////////////////////////////////////////////
//  MIMO PID controller
////////////////////////////////////////////////////////////////////////////////

//red_pitaya_pid i_pid (
//   // signals
//  .clk_i           (adc_clk   ),  // clock
//  .rstn_i          (adc_rstn  ),  // reset - active low
//  .dat_a_i         (adc_dat[0]),  // in 1
//  .dat_b_i         (adc_dat[1]),  // in 2
//  .dat_a_o         (pid_dat[0]),  // out 1
//  .dat_b_o         (pid_dat[1]),  // out 2
//  // System bus
//  .sys_addr        (sys[3].addr ),
//  .sys_wdata       (sys[3].wdata),
//  .sys_wen         (sys[3].wen  ),
//  .sys_ren         (sys[3].ren  ),
//  .sys_rdata       (sys[3].rdata),
//  .sys_err         (sys[3].err  ),
//  .sys_ack         (sys[3].ack  )
//);

////////////////////////////////////////////////////////////////////////////////
// Daisy test code
////////////////////////////////////////////////////////////////////////////////

wire daisy_rx_rdy ;
wire dly_clk = fclk[3]; // 200MHz clock from PS - used for IDELAY (optionaly)
wire [16-1:0] par_dati = daisy_mode[0] ? {16{trig_output_sel}} : 16'h1234;
wire          par_dvi  = daisy_mode[0] ? 1'b0 : daisy_rx_rdy;

red_pitaya_daisy i_daisy (
   // SATA connector
  .daisy_p_o       (  daisy_p_o                  ),  // line 1 is clock capable
  .daisy_n_o       (  daisy_n_o                  ),
  .daisy_p_i       (  daisy_p_i                  ),  // line 1 is clock capable
  .daisy_n_i       (  daisy_n_i                  ),
   // Data
  .ser_clk_i       (  ser_clk                    ),  // high speed serial
  .dly_clk_i       (  dly_clk                    ),  // delay clock
   // TX
  .par_clk_i       (  adc_clk                    ),  // data paralel clock
  .par_rstn_i      (  adc_rstn                   ),  // reset - active low
  .par_rdy_o       (  daisy_rx_rdy               ),
  .par_dv_i        (  par_dvi                    ),
  .par_dat_i       (  par_dati                   ),
   // RX
  .par_clk_o       ( adc_clk_daisy               ),
  .par_rstn_o      (                             ),
  .par_dv_o        (                             ),
  .par_dat_o       ( par_dat                     ),

  .sync_mode_i     (  daisy_mode[0]              ),
  .debug_o         (/*led_o*/                    ),
   // System bus
  .sys_clk_i       (  adc_clk                    ),  // clock
  .sys_rstn_i      (  adc_rstn                   ),  // reset - active low
  .sys_addr_i      (  sys[5].addr                ),
  .sys_sel_i       (                             ),
  .sys_wdata_i     (  sys[5].wdata               ),
  .sys_wen_i       (  sys[5].wen                 ),
  .sys_ren_i       (  sys[5].ren                 ),
  .sys_rdata_o     (  sys[5].rdata               ),
  .sys_err_o       (  sys[5].err                 ),
  .sys_ack_o       (  sys[5].ack                 )
);

//new code
////////////////////////////////////////////////////////// old version where redpitaya deals with timing and sends triggers to QBlox
//reg [27:0]counter1 = 28'd0;

//reg [27:0]counter2 = 28'd0;
//reg [27:0]counter_tmax = 28'd0;
//reg [27:0]dead_time = 28'd0;
//reg led = 1'b0;
//reg first_pulse = 1'b0;
//// Declare an intermediate wire to select which value should go to dac_a
//reg [13:0] dac_a_selected;
//reg [13:0] dac_b_selected;
//parameter TMAX = 28'd2560;
//// Rising edge detection with hysteresis
//parameter RISING_THRESHOLD = 14'h0FF0; // Upper threshold for rising edge
//parameter FALLING_THRESHOLD = 14'h0300; // Lower threshold for falling edge

//wire up1 = adc_dat[0] > RISING_THRESHOLD && adc_dat[0] <= 14'h1FFF; // Because of two's complement format the value goes to >h2000 for negative ADC values
//wire down1 = adc_dat[0] < FALLING_THRESHOLD;
//reg state_high1 = 1'b0;
//wire up2 = adc_dat[1] > RISING_THRESHOLD && adc_dat[1] <= 14'h1FFF; // Because of two's complement format the value goes to >h2000 for negative ADC values
//wire down2 = adc_dat[1] < FALLING_THRESHOLD;
//reg state_high2 = 1'b0;

//// Sequential logic for rising edge detection and LED control
//always @(posedge adc_clk) begin
//    counter1 <= counter1+1;
//    counter2 <= counter2+1;
//    counter_tmax <= counter_tmax+1;
//    dead_time <= dead_time+1;
    
//    if ((up1 && !state_high1 || up2 && !state_high2) && dead_time > 28'd4560)  begin 
//        if (up1 && !state_high1) begin
//            state_high1 <= 1;
//        end
//        else if (up2 && !state_high2) begin
//            state_high2 <= 1;
//        end
//        if (first_pulse == 0) begin//send first pulse
//            // reset the read-out TTL signal
//            exp_p_out[1] <= 1'b0;  // Set GPIO low
//            exp_p_dir[1] <= 1'b1;  // Configure as output
//            first_pulse <= 1;
//            counter_tmax <= 0;
//            //led <=1;           // Turn on LED on rising edge
//            if (up1 && !state_high1) begin
//                dac_a_selected <= 14'h1FFF; // dac output to max
//                counter1 <= 28'd0;                     // reset the counter
//            end else begin
//                dac_b_selected <= 14'h1FFF; // dac output to max
//                counter2 <= 28'd0;                     // reset the counter
//            end
//        end else begin
//            if (counter_tmax <= TMAX) begin //send second pulse
//                first_pulse <= 0;
//                //led <=1;           // Turn on LED on rising edge
//                if (up1 && !state_high1) begin
//                    dac_a_selected <= 14'h1000; // dac output not to max
//                    counter1 <= 28'd0;                     // reset the counter
//                end else begin
//                    dac_b_selected <= 14'h1000; // dac output not to max
//                    counter2 <= 28'd0;                     // reset the counter
//                end
//                // start dead time
//                dead_time <= 28'd0;
//                // send TTL to trigger read-out pulse
//                exp_p_out[1] <= 1'b1;  // Set GPIO high
//                exp_p_dir[1] <= 1'b1;  // Configure as output
//            end else begin //second click came too late, send first pulse again
//                first_pulse <= 1;
//                counter_tmax <= 0;
//                //led <=1;           // Turn on LED on rising edge
//                if (up1 && !state_high1) begin
//                    dac_a_selected <= 14'h1FFF; // dac output to max
//                    counter1 <= 28'd0;                     // reset the counter
//                end else begin
//                    dac_b_selected <= 14'h1FFF; // dac output to max
//                    counter2 <= 28'd0;                     // reset the counter
//                end
//            end
//        end
//    end else begin
//        if (counter1 >= 28'd256) begin      // 256e5 periods of clock of 125 MHz
//            //led <= 0;                          // led will blink with a period of aprox. 0.2 sec
//            dac_a_selected <= 14'h0000; // dac output to 0
//            counter1 <= 28'd0;                     // reset the counter
//        end
//        if (counter2 >= 28'd256) begin      // 256e5 periods of clock of 125 MHz
//            //led <= 0;                          // led will blink with a period of aprox. 0.2 sec
//            dac_b_selected <= 14'h0000; // dac output to 0
//            counter2 <= 28'd0;                     // reset the counter
//        end 
//    end
//    if (down1 && state_high1) begin //falling edge detected
//        state_high1 <= 0;
//    end else if (down2 && state_high2) begin
//        state_high2 <= 0;
//    end
//end

//assign dac_a = dac_a_selected;  // Assign the selected value to dac_a
//assign dac_b = dac_b_selected;  // Assign the selected value to dac_a
//assign led_o[0] = led;                       // assign the register value to the led output


////////////////////////////////////////////////////////////////////////////////// new version where red pitaya only acts as logic gates
reg led = 1'b0;

// Declare an intermediate wire to select which value should go to dac_a
reg [13:0] dac_a_selected;
reg [13:0] dac_b_selected;
parameter RISING_THRESHOLD = 14'h0FF0; // Upper threshold for rising edge
always @(posedge adc_clk) begin
    
    if (adc_dat[0] > RISING_THRESHOLD && adc_dat[0] <= 14'h1FFF) begin 
        if (adc_dat[1] > RISING_THRESHOLD && adc_dat[1] <= 14'h1FFF) begin
        dac_a_selected <= 14'h0000; // dac output to 0
        dac_b_selected <= 14'h0000; // dac output to 0
        end else begin
        dac_a_selected <= 14'h0000; // dac output to 0
        dac_b_selected <= 14'h1FFF; // dac output to max
        end
    end else begin
        if (adc_dat[1] > RISING_THRESHOLD && adc_dat[1] <= 14'h1FFF) begin
        dac_a_selected <= 14'h0000; // dac output to 0
        dac_b_selected <= 14'h0000; // dac output to 0
        end else begin
        dac_a_selected <= 14'h1FFF; // dac output to max
        dac_b_selected <= 14'h0000; // dac output to 0
        end
    end
end

assign dac_a = dac_a_selected;  // Assign the selected value to dac_a
assign dac_b = dac_b_selected;  // Assign the selected value to dac_a
assign led_o[0] = led;                       // assign the register value to the led output


endmodule: red_pitaya_top
