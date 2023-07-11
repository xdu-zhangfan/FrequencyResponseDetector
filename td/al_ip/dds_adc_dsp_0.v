// Verilog netlist created by Tang Dynasty v5.6.71036
// Tue Jul 11 09:44:26 2023

`timescale 1ns / 1ps
module dds_adc_mul_0
  (
  a,
  clk,
  rst,
  y,
  p
  );

  input [31:0] a;
  input clk;
  input rst;
  input [11:0] y;
  output [31:0] p;

  wire [44:0] mult0_syn_1;
  wire [53:0] mult0_syn_170;
  wire [26:0] mult0_syn_255;
  wire [17:0] mult0_syn_300;
  wire [44:0] mult0_syn_319;
  wire [44:0] mult0_syn_364;
  wire [53:0] mult0_syn_409;
  wire [53:0] mult0_syn_550;
  wire [26:0] mult0_syn_635;
  wire [17:0] mult0_syn_680;
  wire [53:0] mult0_syn_94;
  wire [31:0] reg_5_q;

  PH1_PHY_DSPREG #(
    .CEMUX("1"),
    .CLKMUX("SIG"),
    .RSTMODE("SYNC"),
    .RSTMUX("SIG"),
    .WIDTH(45))
    \mult0_syn_148/M_reg  (
    .ce(1'b1),
    .clk(clk),
    .d(mult0_syn_364),
    .rst(rst),
    .q(mult0_syn_319));
  PH1_PHY_DSPREG #(
    .CEMUX("1"),
    .CLKMUX("SIG"),
    .RSTMODE("SYNC"),
    .RSTMUX("SIG"),
    .WIDTH(54))
    \mult0_syn_148/POU_p_reg  (
    .ce(1'b1),
    .clk(clk),
    .d(mult0_syn_409),
    .rst(rst),
    .q({mult0_syn_550[53:15],p[31:17]}));
  PH1_PHY_DSPMULT \mult0_syn_148/_mult  (
    .opctrl(2'b11),
    .x(mult0_syn_635),
    .y(mult0_syn_680),
    .p(mult0_syn_364));
  PH1_PHY_DSPTADD #(
    .CI_INVERT("NO"),
    .INV_OPCTRL(4'b0000),
    .RND_CONST(54'b0),
    .USE_OVERFLOW("S53"),
    .X1_EXTEND("YES"),
    .Y1_ROUND("NO"),
    .Z1_SHIFT("YES"))
    \mult0_syn_148/_tadd  (
    .ci(1'b0),
    .ci_special(1'b0),
    .opctrl(9'b010100000),
    .x1_special({mult0_syn_319[44],mult0_syn_319[44],mult0_syn_319[44],mult0_syn_319[44],mult0_syn_319[44],mult0_syn_319[44],mult0_syn_319[44],mult0_syn_319[44],mult0_syn_319[44],mult0_syn_319}),
    .y0(54'b000000000000000000000000000000000000000000000000000000),
    .y1_special(54'b000000000000000000000000000000000000000000000000000000),
    .z0({mult0_syn_94[44],mult0_syn_94[44],mult0_syn_94[44],mult0_syn_94[44],mult0_syn_94[44],mult0_syn_94[44],mult0_syn_94[44],mult0_syn_94[44],mult0_syn_94[44],mult0_syn_94[44:0]}),
    .z1_special({mult0_syn_94[44],mult0_syn_94[44],mult0_syn_94[44],mult0_syn_94[44],mult0_syn_94[44],mult0_syn_94[44],mult0_syn_94[44],mult0_syn_94[44],mult0_syn_94[44],mult0_syn_94[44:0]}),
    .sum(mult0_syn_409));
  PH1_PHY_DSPMREG #(
    .CEMUX("1"),
    .CLKMUX("SIG"),
    .DYNAMIC_DATA("Q"),
    .RSTMODE("SYNC"),
    .RSTMUX("SIG"),
    .WIDTH(27))
    \mult0_syn_148/xa_mreg  (
    .ce(1'b1),
    .clk(clk),
    .d({a[31],a[31],a[31],a[31],a[31],a[31],a[31],a[31],a[31],a[31],a[31],a[31],a[31:17]}),
    .opctrl(1'b0),
    .rst(rst),
    .dynamic_q(mult0_syn_635));
  PH1_PHY_DSPMREG #(
    .CEMUX("1"),
    .CLKMUX("SIG"),
    .DYNAMIC_DATA("Q"),
    .RSTMODE("SYNC"),
    .RSTMUX("SIG"),
    .WIDTH(18))
    \mult0_syn_148/y_mreg  (
    .ce(1'b1),
    .clk(clk),
    .d({y[11],y[11],y[11],y[11],y[11],y[11],y}),
    .opctrl(1'b0),
    .rst(rst),
    .dynamic_q(mult0_syn_680));
  PH1_PHY_DSPREG #(
    .CEMUX("1"),
    .CLKMUX("SIG"),
    .RSTMODE("SYNC"),
    .RSTMUX("SIG"),
    .WIDTH(45))
    \mult0_syn_93/M_reg  (
    .ce(1'b1),
    .clk(clk),
    .d(mult0_syn_1),
    .rst(rst),
    .q({mult0_syn_170[44:17],reg_5_q[15],reg_5_q[16],reg_5_q[17],reg_5_q[18],reg_5_q[19],reg_5_q[20],reg_5_q[21],reg_5_q[22],reg_5_q[23],reg_5_q[24],reg_5_q[25],reg_5_q[26],reg_5_q[27],reg_5_q[28],reg_5_q[29],reg_5_q[30],reg_5_q[31]}));
  PH1_PHY_DSPMULT \mult0_syn_93/_mult  (
    .opctrl(2'b11),
    .x(mult0_syn_255),
    .y(mult0_syn_300),
    .p(mult0_syn_1));
  PH1_PHY_DSPMREG #(
    .CEMUX("1"),
    .CLKMUX("SIG"),
    .DYNAMIC_DATA("D"),
    .RSTMODE("ASYNC"),
    .RSTMUX("0"),
    .WIDTH(54))
    \mult0_syn_93/cpo_mreg  (
    .d({open_n59,open_n60,open_n61,open_n62,open_n63,open_n64,open_n65,open_n66,open_n67,mult0_syn_170[44:17],reg_5_q[15],reg_5_q[16],reg_5_q[17],reg_5_q[18],reg_5_q[19],reg_5_q[20],reg_5_q[21],reg_5_q[22],reg_5_q[23],reg_5_q[24],reg_5_q[25],reg_5_q[26],reg_5_q[27],reg_5_q[28],reg_5_q[29],reg_5_q[30],reg_5_q[31]}),
    .opctrl(1'b1),
    .dynamic_q({open_n69,open_n70,open_n71,open_n72,open_n73,open_n74,open_n75,open_n76,open_n77,mult0_syn_94[44:0]}));
  PH1_PHY_DSPMREG #(
    .CEMUX("1"),
    .CLKMUX("SIG"),
    .DYNAMIC_DATA("Q"),
    .RSTMODE("SYNC"),
    .RSTMUX("SIG"),
    .WIDTH(27))
    \mult0_syn_93/xa_mreg  (
    .ce(1'b1),
    .clk(clk),
    .d({10'b0000000000,a[16:0]}),
    .opctrl(1'b0),
    .rst(rst),
    .dynamic_q(mult0_syn_255));
  PH1_PHY_DSPMREG #(
    .CEMUX("1"),
    .CLKMUX("SIG"),
    .DYNAMIC_DATA("Q"),
    .RSTMODE("SYNC"),
    .RSTMUX("SIG"),
    .WIDTH(18))
    \mult0_syn_93/y_mreg  (
    .ce(1'b1),
    .clk(clk),
    .d({y[11],y[11],y[11],y[11],y[11],y[11],y}),
    .opctrl(1'b0),
    .rst(rst),
    .dynamic_q(mult0_syn_300));
  AL_DFF_X reg_5_15 (
    .ar(1'b0),
    .as(1'b0),
    .clk(clk),
    .d(reg_5_q[15]),
    .en(1'b1),
    .sr(rst),
    .ss(1'b0),
    .q(p[16]));
  AL_DFF_X reg_5_16 (
    .ar(1'b0),
    .as(1'b0),
    .clk(clk),
    .d(reg_5_q[16]),
    .en(1'b1),
    .sr(rst),
    .ss(1'b0),
    .q(p[15]));
  AL_DFF_X reg_5_17 (
    .ar(1'b0),
    .as(1'b0),
    .clk(clk),
    .d(reg_5_q[17]),
    .en(1'b1),
    .sr(rst),
    .ss(1'b0),
    .q(p[14]));
  AL_DFF_X reg_5_18 (
    .ar(1'b0),
    .as(1'b0),
    .clk(clk),
    .d(reg_5_q[18]),
    .en(1'b1),
    .sr(rst),
    .ss(1'b0),
    .q(p[13]));
  AL_DFF_X reg_5_19 (
    .ar(1'b0),
    .as(1'b0),
    .clk(clk),
    .d(reg_5_q[19]),
    .en(1'b1),
    .sr(rst),
    .ss(1'b0),
    .q(p[12]));
  AL_DFF_X reg_5_20 (
    .ar(1'b0),
    .as(1'b0),
    .clk(clk),
    .d(reg_5_q[20]),
    .en(1'b1),
    .sr(rst),
    .ss(1'b0),
    .q(p[11]));
  AL_DFF_X reg_5_21 (
    .ar(1'b0),
    .as(1'b0),
    .clk(clk),
    .d(reg_5_q[21]),
    .en(1'b1),
    .sr(rst),
    .ss(1'b0),
    .q(p[10]));
  AL_DFF_X reg_5_22 (
    .ar(1'b0),
    .as(1'b0),
    .clk(clk),
    .d(reg_5_q[22]),
    .en(1'b1),
    .sr(rst),
    .ss(1'b0),
    .q(p[9]));
  AL_DFF_X reg_5_23 (
    .ar(1'b0),
    .as(1'b0),
    .clk(clk),
    .d(reg_5_q[23]),
    .en(1'b1),
    .sr(rst),
    .ss(1'b0),
    .q(p[8]));
  AL_DFF_X reg_5_24 (
    .ar(1'b0),
    .as(1'b0),
    .clk(clk),
    .d(reg_5_q[24]),
    .en(1'b1),
    .sr(rst),
    .ss(1'b0),
    .q(p[7]));
  AL_DFF_X reg_5_25 (
    .ar(1'b0),
    .as(1'b0),
    .clk(clk),
    .d(reg_5_q[25]),
    .en(1'b1),
    .sr(rst),
    .ss(1'b0),
    .q(p[6]));
  AL_DFF_X reg_5_26 (
    .ar(1'b0),
    .as(1'b0),
    .clk(clk),
    .d(reg_5_q[26]),
    .en(1'b1),
    .sr(rst),
    .ss(1'b0),
    .q(p[5]));
  AL_DFF_X reg_5_27 (
    .ar(1'b0),
    .as(1'b0),
    .clk(clk),
    .d(reg_5_q[27]),
    .en(1'b1),
    .sr(rst),
    .ss(1'b0),
    .q(p[4]));
  AL_DFF_X reg_5_28 (
    .ar(1'b0),
    .as(1'b0),
    .clk(clk),
    .d(reg_5_q[28]),
    .en(1'b1),
    .sr(rst),
    .ss(1'b0),
    .q(p[3]));
  AL_DFF_X reg_5_29 (
    .ar(1'b0),
    .as(1'b0),
    .clk(clk),
    .d(reg_5_q[29]),
    .en(1'b1),
    .sr(rst),
    .ss(1'b0),
    .q(p[2]));
  AL_DFF_X reg_5_30 (
    .ar(1'b0),
    .as(1'b0),
    .clk(clk),
    .d(reg_5_q[30]),
    .en(1'b1),
    .sr(rst),
    .ss(1'b0),
    .q(p[1]));
  AL_DFF_X reg_5_31 (
    .ar(1'b0),
    .as(1'b0),
    .clk(clk),
    .d(reg_5_q[31]),
    .en(1'b1),
    .sr(rst),
    .ss(1'b0),
    .q(p[0]));

  // synthesis translate_off
  glbl glbl();
  always @(*) begin
    glbl.gsr <= PH1_PHY_GSR.gsr;
    glbl.gsrn <= PH1_PHY_GSR.gsrn;
    glbl.done_gwe <= PH1_PHY_GSR.done_gwe;
    glbl.usr_gsrn_en <= PH1_PHY_GSR.usr_gsrn_en;
  end
  // synthesis translate_on

endmodule 

