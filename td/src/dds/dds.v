`define DDS_MODE_DISABLE 32'h0000_0000
`define DDS_MODE_DIRECT 32'h0000_0001
`define DDS_MODE_DRG_PHASE 32'h0000_0002
`define DDS_MODE_ADC_PHASE 32'h0000_0003

module dds #(
    parameter DDS_FREQ  = 32'd120000000,
    parameter DAC_WIDTH = 14,
    parameter ADC_WIDTH = 12
) (
    input clk,
    input rstn,

    input                      dac_clk,
    output [DAC_WIDTH - 1 : 0] dac_data_1,
    output [DAC_WIDTH - 1 : 0] dac_data_2,

    input                     adc_clk,
    input [ADC_WIDTH - 1 : 0] adc_data_1,
    input [ADC_WIDTH - 1 : 0] adc_data_2,

    input          param_wen,
    input [31 : 0] mode,
    input [31 : 0] direct_fword,
    input [31 : 0] direct_pword,
    input [31 : 0] direct_amp,
    input [31 : 0] drg_f_start,
    input [31 : 0] drg_f_end,
    input [31 : 0] drg_f_step,
    input [31 : 0] drg_p_start,
    input [31 : 0] drg_p_end,
    input [31 : 0] drg_p_step,
    input [31 : 0] drg_a_start,
    input [31 : 0] drg_a_end,
    input [31 : 0] drg_a_step,
    input [31 : 0] adc_amp_center,
    input [31 : 0] adc_amp_kf,
    input [31 : 0] adc_amp_ch_sel,
    input [31 : 0] adc_freq_center,
    input [31 : 0] adc_freq_kf,
    input [31 : 0] adc_freq_ch_sel
);
  wire [DAC_WIDTH - 1 : 0] dac_data_1_i;
  wire [DAC_WIDTH - 1 : 0] dac_data_2_i;

  assign dac_data_1 = (dds_phy_rdy) ? dac_data_1_i + 14'd8192 : 14'b0;
  assign dac_data_2 = (dds_phy_rdy) ? dac_data_2_i + 14'd8192 : 14'b0;

  (*keep*) reg [31 : 0] mode_buf;
  always @(posedge clk) begin
    if (!rstn) begin
      mode_buf <= 32'h0;
    end else begin
      if (param_wen) begin
        mode_buf <= mode;
      end else begin
        mode_buf <= mode_buf;
      end
    end
  end

  wire [31 : 0] direct_output_fword;
  wire [31 : 0] direct_output_pword;
  wire [31 : 0] direct_output_amp;
  reg direct_en;
  direct #(
      .DDS_FREQ(DDS_FREQ)
  ) direct_inst (
      .clk (dac_clk),
      .rstn(rstn),

      .param_wen   (param_wen),
      .direct_fword(direct_fword),
      .direct_pword(direct_pword),
      .direct_amp  (direct_amp),

      .direct_en(direct_en),

      .dds_clk            (dac_clk),
      .direct_output_fword(direct_output_fword),
      .direct_output_pword(direct_output_pword),
      .direct_output_amp  (direct_output_amp)
  );

  wire [31 : 0] drg_output_fword;
  wire [31 : 0] drg_output_pword;
  wire [31 : 0] drg_output_amp;
  reg drg_en;
  drg #(
      .DDS_FREQ(DDS_FREQ)
  ) drg_inst (
      .clk (dac_clk),
      .rstn(rstn),

      .param_wen  (param_wen),
      .drg_f_start(drg_f_start),
      .drg_f_end  (drg_f_end),
      .drg_f_step (drg_f_step),
      .drg_p_start(drg_p_start),
      .drg_p_end  (drg_p_end),
      .drg_p_step (drg_p_step),
      .drg_a_start(drg_a_start),
      .drg_a_end  (drg_a_end),
      .drg_a_step (drg_a_step),

      .drg_en(drg_en),

      .dds_clk         (dac_clk),
      .drg_output_fword(drg_output_fword),
      .drg_output_pword(drg_output_pword),
      .drg_output_amp  (drg_output_amp)
  );

  wire [31 : 0] adc_output_fword;
  wire [31 : 0] adc_output_pword;
  wire [31 : 0] adc_output_amp;
  reg adc_en;
  adc #(
      .DDS_FREQ (DDS_FREQ),
      .ADC_WIDTH(ADC_WIDTH)
  ) adc_inst (
      .clk (dac_clk),
      .rstn(rstn),

      .param_wen      (param_wen),
      .adc_freq_center(adc_freq_center),
      .adc_freq_kf    (adc_freq_kf),
      .adc_freq_ch_sel(adc_freq_ch_sel),
      .adc_amp_center (adc_amp_center),
      .adc_amp_kf     (adc_amp_kf),
      .adc_amp_ch_sel (adc_amp_ch_sel),

      .adc_en(adc_en),

      .adc_clk   (adc_clk),
      .adc_data_1(adc_data_1),
      .adc_data_2(adc_data_2),

      .dds_clk         (dac_clk),
      .adc_output_fword(adc_output_fword),
      .adc_output_pword(adc_output_pword),
      .adc_output_amp  (adc_output_amp)
  );

  reg [31 : 0] phase_fword_i;
  reg [31 : 0] phase_pword_i;
  reg [31 : 0] amptitude;
  dds_phy dds_phy_inst (
      .clk  (dac_clk),
      .rst_n(rstn),

      .fword(phase_fword_i),
      .pword(phase_pword_i),

      .phase_out(dds_phy_phase_out),
      .rdy      (dds_phy_rdy),
      .wave_cos (dac_data_1_i),
      .wave_sin (dac_data_2_i)
  );

  always @(posedge dac_clk) begin
    if (!rstn) begin
      direct_en     <= 1'b0;
      drg_en        <= 1'b0;
      adc_en        <= 1'b0;

      phase_fword_i <= 32'h0;
      phase_pword_i <= 32'h0;
      amptitude     <= 32'h0;
    end
    begin
      case (mode_buf)
        `DDS_MODE_DISABLE: begin
          direct_en     <= 1'b0;
          drg_en        <= 1'b0;
          adc_en        <= 1'b0;

          phase_fword_i <= 32'h0;
          phase_pword_i <= 32'h0;
          amptitude     <= 32'h0;
        end

        `DDS_MODE_DIRECT: begin
          direct_en     <= 1'b1;
          drg_en        <= 1'b0;
          adc_en        <= 1'b0;

          phase_fword_i <= direct_output_fword;
          phase_pword_i <= direct_output_pword;
          amptitude     <= direct_output_amp;
        end

        `DDS_MODE_DRG_PHASE: begin
          direct_en     <= 1'b0;
          drg_en        <= 1'b1;
          adc_en        <= 1'b0;

          phase_fword_i <= drg_output_fword;
          phase_pword_i <= drg_output_pword;
          amptitude     <= drg_output_amp;
        end

        `DDS_MODE_ADC_PHASE: begin
          direct_en     <= 1'b0;
          drg_en        <= 1'b0;
          adc_en        <= 1'b1;

          phase_fword_i <= adc_output_fword;
          phase_pword_i <= adc_output_pword;
          amptitude     <= adc_output_amp;
        end

        default: begin
          direct_en     <= 1'b0;
          drg_en        <= 1'b0;
          adc_en        <= 1'b0;

          phase_fword_i <= 32'h0;
          phase_pword_i <= 32'h0;
          amptitude     <= 32'h0;
        end
      endcase
    end
  end

endmodule
