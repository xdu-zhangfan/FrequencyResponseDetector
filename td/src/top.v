`define SYS_CLK 200000000
`define ADC_CLK 60000000
`define DAC_CLK 100000000

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
    input  [`ADC_WIDTH - 1 : 0] adc_data_1,
    input                       adc_otr_1,

    output                      adc_clk_2,
    input  [`ADC_WIDTH - 1 : 0] adc_data_2,
    input                       adc_otr_2
);

  wire sys_clk;
  wire sys_rstn;
  wire adc_clk;
  wire dac_clk;
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

  wire          param_wen;
  wire [31 : 0] mode;
  wire [31 : 0] direct_fword;
  wire [31 : 0] direct_pword;
  wire [31 : 0] direct_amp;
  wire [31 : 0] drg_f_start;
  wire [31 : 0] drg_f_end;
  wire [31 : 0] drg_f_step;
  wire [31 : 0] drg_p_start;
  wire [31 : 0] drg_p_end;
  wire [31 : 0] drg_p_step;
  wire [31 : 0] drg_a_start;
  wire [31 : 0] drg_a_end;
  wire [31 : 0] drg_a_step;
  wire [31 : 0] adc_amp_center;
  wire [31 : 0] adc_amp_kf;
  wire [31 : 0] adc_amp_ch_sel;
  wire [31 : 0] adc_freq_center;
  wire [31 : 0] adc_freq_kf;
  wire [31 : 0] adc_freq_ch_sel;
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

      .param_wen      (param_wen),
      .mode           (mode),
      .direct_fword   (direct_fword),
      .direct_pword   (direct_pword),
      .direct_amp     (direct_amp),
      .drg_f_start    (drg_f_start),
      .drg_f_end      (drg_f_end),
      .drg_f_step     (drg_f_step),
      .drg_p_start    (drg_p_start),
      .drg_p_end      (drg_p_end),
      .drg_p_step     (drg_p_step),
      .drg_a_start    (drg_a_start),
      .drg_a_end      (drg_a_end),
      .drg_a_step     (drg_a_step),
      .adc_amp_center (adc_amp_center),
      .adc_amp_kf     (adc_amp_kf),
      .adc_amp_ch_sel (adc_amp_ch_sel),
      .adc_freq_center(adc_freq_center),
      .adc_freq_kf    (adc_freq_kf),
      .adc_freq_ch_sel(adc_freq_ch_sel)
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

      .param_wen      (param_wen),
      .mode           (mode),
      .direct_fword   (direct_fword),
      .direct_pword   (direct_pword),
      .direct_amp     (direct_amp),
      .drg_f_start    (drg_f_start),
      .drg_f_end      (drg_f_end),
      .drg_f_step     (drg_f_step),
      .drg_p_start    (drg_p_start),
      .drg_p_end      (drg_p_end),
      .drg_p_step     (drg_p_step),
      .drg_a_start    (drg_a_start),
      .drg_a_end      (drg_a_end),
      .drg_a_step     (drg_a_step),
      .adc_amp_center (adc_amp_center),
      .adc_amp_kf     (adc_amp_kf),
      .adc_amp_ch_sel (adc_amp_ch_sel),
      .adc_freq_center(adc_freq_center),
      .adc_freq_kf    (adc_freq_kf),
      .adc_freq_ch_sel(adc_freq_ch_sel)
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
