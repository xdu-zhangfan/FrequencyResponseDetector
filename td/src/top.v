`define SYS_CLK 260000000
`define ADC_CLK 65000000
`define DAC_CLK 130000000

`define DAC_WIDTH 14
`define ADC_WIDTH 12

module top (
             input          clk_100m,
    (*keep*) input  [4 : 1] keys,
             output [8 : 1] leds,

    input  spi_s_mosi,
    output spi_s_miso,
    input  spi_s_sck,
    input  spi_s_csn,

    output spi_m_mosi,
    input  spi_m_miso,
    output spi_m_sck,
    output spi_m_csn,

    output                      dac_clk_1,
    output                      dac_wrt_1,
    output [`DAC_WIDTH - 1 : 0] dac_data_1,

    output                      dac_clk_2,
    output                      dac_wrt_2,
    output [`DAC_WIDTH - 1 : 0] dac_data_2,

             output                      adc_clk_1,
    (*keep*) input  [`ADC_WIDTH - 1 : 0] adc_data_1,
             input                       adc_otr_1,

             output                      adc_clk_2,
    (*keep*) input  [`ADC_WIDTH - 1 : 0] adc_data_2,
             input                       adc_otr_2
);

  (*keep*)wire sys_clk;
  (*keep*)wire sys_rstn;
  (*keep*)wire adc_clk;
  (*keep*)wire dac_clk;
  sys_pll sys_pll_inst (
      .refclk(clk_100m),
      .reset (~keys[1]),

      .lock(sys_rstn),

      .clk0_out(sys_clk),
      .clk1_out(adc_clk),
      .clk2_out(dac_clk)
  );

  assign adc_clk_1 = adc_clk;
  assign adc_clk_2 = adc_clk;
  assign dac_clk_1 = dac_clk;
  assign dac_clk_2 = dac_clk;
  assign dac_wrt_1 = dac_clk;
  assign dac_wrt_2 = dac_clk;

  (*keep*)wire          param_wen;
  (*keep*)wire [31 : 0] dds_fword_source;
  (*keep*)wire [31 : 0] dds_pword_source;
  (*keep*)wire [31 : 0] dds_amp_source;
  (*keep*)wire [31 : 0] direct_fword;
  (*keep*)wire [31 : 0] direct_pword;
  (*keep*)wire [31 : 0] direct_amp;
  (*keep*)wire [31 : 0] drg_freq_start;
  (*keep*)wire [31 : 0] drg_freq_end;
  (*keep*)wire [31 : 0] drg_freq_step;
  (*keep*)wire [31 : 0] drg_freq_pulse;
  (*keep*)wire [31 : 0] drg_phase_start;
  (*keep*)wire [31 : 0] drg_phase_end;
  (*keep*)wire [31 : 0] drg_phase_step;
  (*keep*)wire [31 : 0] drg_phase_pulse;
  (*keep*)wire [31 : 0] drg_amp_start;
  (*keep*)wire [31 : 0] drg_amp_end;
  (*keep*)wire [31 : 0] drg_amp_step;
  (*keep*)wire [31 : 0] drg_amp_pulse;
  (*keep*)wire [31 : 0] adc_freq_center;
  (*keep*)wire [31 : 0] adc_freq_kf;
  (*keep*)wire [31 : 0] adc_freq_ch_sel;
  (*keep*)wire [31 : 0] adc_freq_zero_cal;
  (*keep*)wire [31 : 0] adc_phase_center;
  (*keep*)wire [31 : 0] adc_phase_kf;
  (*keep*)wire [31 : 0] adc_phase_ch_sel;
  (*keep*)wire [31 : 0] adc_phase_zero_cal;
  (*keep*)wire [31 : 0] adc_amp_center;
  (*keep*)wire [31 : 0] adc_amp_kf;
  (*keep*)wire [31 : 0] adc_amp_ch_sel;
  (*keep*)wire [31 : 0] adc_amp_zero_cal;
  spi #(
      .SYSCLK_FREQ(`SYS_CLK),
      .SPICLK_FREQ(1000000),

      .CPOL (0),
      .CPHA (0),
      .FSB  (1),
      .WIDTH(8)
  ) spi_inst (
      .clk (sys_clk),
      .rstn(sys_rstn),

      .spi_s_sclk(spi_s_sck),
      .spi_s_ss_n(spi_s_csn),
      .spi_s_mosi(spi_s_mosi),
      .spi_s_miso(spi_s_miso),

      .spi_m_sclk(spi_m_sck),
      .spi_m_ss_n(spi_m_csn),
      .spi_m_mosi(spi_m_mosi),
      .spi_m_miso(spi_m_miso),

      .param_wen         (param_wen),
      .dds_fword_source  (dds_fword_source),
      .dds_pword_source  (dds_pword_source),
      .dds_amp_source    (dds_amp_source),
      .direct_fword      (direct_fword),
      .direct_pword      (direct_pword),
      .direct_amp        (direct_amp),
      .drg_freq_start    (drg_freq_start),
      .drg_freq_end      (drg_freq_end),
      .drg_freq_step     (drg_freq_step),
      .drg_freq_pulse    (drg_freq_pulse),
      .drg_phase_start   (drg_phase_start),
      .drg_phase_end     (drg_phase_end),
      .drg_phase_step    (drg_phase_step),
      .drg_phase_pulse   (drg_phase_pulse),
      .drg_amp_start     (drg_amp_start),
      .drg_amp_end       (drg_amp_end),
      .drg_amp_step      (drg_amp_step),
      .drg_amp_pulse     (drg_amp_pulse),
      .adc_freq_center   (adc_freq_center),
      .adc_freq_kf       (adc_freq_kf),
      .adc_freq_ch_sel   (adc_freq_ch_sel),
      .adc_freq_zero_cal (adc_freq_zero_cal),
      .adc_phase_center  (adc_phase_center),
      .adc_phase_kf      (adc_phase_kf),
      .adc_phase_ch_sel  (adc_phase_ch_sel),
      .adc_phase_zero_cal(adc_phase_zero_cal),
      .adc_amp_center    (adc_amp_center),
      .adc_amp_kf        (adc_amp_kf),
      .adc_amp_ch_sel    (adc_amp_ch_sel),
      .adc_amp_zero_cal  (adc_amp_zero_cal)
  );

  dds #(
      .DDS_FREQ (`DAC_CLK),
      .DAC_WIDTH(`DAC_WIDTH),
      .ADC_WIDTH(`ADC_WIDTH)
  ) dds_inst (
      .clk (sys_clk),
      .rstn(sys_rstn),

      .dac_clk   (dac_clk),
      .dac_data_1(dac_data_1),
      .dac_data_2(dac_data_2),

      .adc_clk   (adc_clk),
      .adc_data_1(adc_data_1),
      .adc_data_2(adc_data_2),

      .param_wen         (param_wen),
      .dds_fword_source  (dds_fword_source),
      .dds_pword_source  (dds_pword_source),
      .dds_amp_source    (dds_amp_source),
      .direct_fword      (direct_fword),
      .direct_pword      (direct_pword),
      .direct_amp        (direct_amp),
      .drg_freq_start    (drg_freq_start),
      .drg_freq_end      (drg_freq_end),
      .drg_freq_step     (drg_freq_step),
      .drg_freq_pulse    (drg_freq_pulse),
      .drg_phase_start   (drg_phase_start),
      .drg_phase_end     (drg_phase_end),
      .drg_phase_step    (drg_phase_step),
      .drg_phase_pulse   (drg_phase_pulse),
      .drg_amp_start     (drg_amp_start),
      .drg_amp_end       (drg_amp_end),
      .drg_amp_step      (drg_amp_step),
      .drg_amp_pulse     (drg_amp_pulse),
      .adc_freq_center   (adc_freq_center),
      .adc_freq_kf       (adc_freq_kf),
      .adc_freq_ch_sel   (adc_freq_ch_sel),
      .adc_freq_zero_cal (adc_freq_zero_cal),
      .adc_phase_center  (adc_phase_center),
      .adc_phase_kf      (adc_phase_kf),
      .adc_phase_ch_sel  (adc_phase_ch_sel),
      .adc_phase_zero_cal(adc_phase_zero_cal),
      .adc_amp_center    (adc_amp_center),
      .adc_amp_kf        (adc_amp_kf),
      .adc_amp_ch_sel    (adc_amp_ch_sel),
      .adc_amp_zero_cal  (adc_amp_zero_cal)
  );

  reg [31 : 0] led_cnt;
  assign leds = ~led_cnt[31 : 24];
  always @(posedge sys_clk) begin
    if (!sys_rstn) begin
      led_cnt <= 32'h0;
    end else begin
      led_cnt <= led_cnt + 1;
    end
  end
endmodule
