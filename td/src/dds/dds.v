

module dds #(
    parameter DDS_FREQ  = 32'd120000000,
    parameter DAC_WIDTH = 14,
    parameter ADC_WIDTH = 12
) (
    input clk,
    input rstn,

    input                          dac_clk,
    output reg [DAC_WIDTH - 1 : 0] dac_data_1,
    output reg [DAC_WIDTH - 1 : 0] dac_data_2,

    input                     adc_clk,
    input [ADC_WIDTH - 1 : 0] adc_data_1,
    input [ADC_WIDTH - 1 : 0] adc_data_2,

    input          param_wen,
    input [31 : 0] dds_fword_source,
    input [31 : 0] dds_pword_source,
    input [31 : 0] dds_amp_source,
    input [31 : 0] direct_fword,
    input [31 : 0] direct_pword,
    input [31 : 0] direct_amp,
    input [31 : 0] drg_freq_start,
    input [31 : 0] drg_freq_end,
    input [31 : 0] drg_freq_step,
    input [31 : 0] drg_freq_pulse,
    input [31 : 0] drg_phase_start,
    input [31 : 0] drg_phase_end,
    input [31 : 0] drg_phase_step,
    input [31 : 0] drg_phase_pulse,
    input [31 : 0] drg_amp_start,
    input [31 : 0] drg_amp_end,
    input [31 : 0] drg_amp_step,
    input [31 : 0] drg_amp_pulse,
    input [31 : 0] adc_freq_center,
    input [31 : 0] adc_freq_kf,
    input [31 : 0] adc_freq_ch_sel,
    input [31 : 0] adc_freq_zero_cal,
    input [31 : 0] adc_phase_center,
    input [31 : 0] adc_phase_kf,
    input [31 : 0] adc_phase_ch_sel,
    input [31 : 0] adc_phase_zero_cal,
    input [31 : 0] adc_amp_center,
    input [31 : 0] adc_amp_kf,
    input [31 : 0] adc_amp_ch_sel,
    input [31 : 0] adc_amp_zero_cal
);
  reg  [           31 : 0] dac_data_1_i;
  reg  [           31 : 0] dac_data_2_i;
  reg  [DAC_WIDTH - 1 : 0] dac_data_1_i0;
  reg  [DAC_WIDTH - 1 : 0] dac_data_2_i0;
  wire [           31 : 0] dds_div_cos_output;
  wire [           31 : 0] dds_div_sin_output;
  wire [           31 : 0] dds_phy_phase_out;
  wire                     dds_divider_0_inst_cos_done;
  wire                     dds_divider_0_inst_sin_done;
  always @(posedge dac_clk) begin
    if (!rstn) begin
      dac_data_1_i  <= 32'h0;
      dac_data_1_i0 <= {DAC_WIDTH{1'b0}};
      dac_data_2_i  <= 32'h0;
      dac_data_2_i0 <= {DAC_WIDTH{1'b0}};
    end else begin
      if (dds_divider_0_inst_cos_done) begin
        dac_data_1_i  <= dds_div_cos_output + (1 << (DAC_WIDTH - 1));
        dac_data_1_i0 <= dac_data_1_i[DAC_WIDTH-1 : 0];
      end else begin
        dac_data_1_i  <= dac_data_1_i;
        dac_data_1_i0 <= dac_data_1_i0;
      end

      if (dds_divider_0_inst_cos_done) begin
        dac_data_2_i  <= dds_div_sin_output + (1 << (DAC_WIDTH - 1));
        dac_data_2_i0 <= dac_data_2_i[DAC_WIDTH-1 : 0];
      end else begin
        dac_data_2_i  <= dac_data_2_i;
        dac_data_2_i0 <= dac_data_2_i0;
      end
    end
  end

  always @(posedge dac_clk) begin
    if (!rstn) begin
      dac_data_1 <= 32'h0;
      dac_data_2 <= 32'h0;
    end else begin
      if (dds_divider_0_inst_cos_done) begin
        dac_data_1 <= dac_data_1_i0;
      end else begin
        dac_data_1 <= dac_data_1;
      end

      if (dds_divider_0_inst_cos_done) begin
        dac_data_2 <= dac_data_2_i0;
      end else begin
        dac_data_2 <= dac_data_2;
      end
    end
  end

  (*keep*)reg  [31 : 0] phase_fword_i;
  (*keep*)reg  [31 : 0] phase_pword_i;
  (*keep*)reg  [31 : 0] amptitude;
  wire [31 : 0] dds_cos_output;
  wire [31 : 0] dds_sin_output;
  wire          dds_phy_rdy;
  dds_phy dds_phy_inst (
      .clk  (dac_clk),
      .rst_n(rstn),

      .fword(phase_fword_i),
      .pword(phase_pword_i),

      .phase_out(dds_phy_phase_out),
      .rdy      (dds_phy_rdy),
      .wave_cos (dds_cos_output),
      .wave_sin (dds_sin_output)
  );

  dds_divider_0 dds_divider_0_inst_cos (
      .clk(dac_clk),
      .rst(~rstn),

      .numerator(dds_cos_output),
      .denominator(amptitude),
      .start(dds_phy_rdy),

      .done(dds_divider_0_inst_cos_done),
      .quotient(dds_div_cos_output),
      .remainder()
  );

  dds_divider_0 dds_divider_0_inst_sin (
      .clk(dac_clk),
      .rst(~rstn),

      .numerator(dds_sin_output),
      .denominator(amptitude),
      .start(dds_phy_rdy),

      .done(dds_divider_0_inst_sin_done),
      .quotient(dds_div_sin_output),
      .remainder()
  );

  (*keep*)reg [31 : 0] dds_fword_source_buf;
  (*keep*)reg [31 : 0] dds_pword_source_buf;
  (*keep*)reg [31 : 0] dds_amp_source_buf;
  always @(posedge clk) begin
    if (!rstn) begin
      dds_fword_source_buf <= 32'h0;
      dds_pword_source_buf <= 32'h0;
      dds_amp_source_buf   <= 32'h0;
    end else begin
      if (param_wen) begin
        dds_fword_source_buf <= dds_fword_source;
        dds_pword_source_buf <= dds_pword_source;
        dds_amp_source_buf   <= dds_amp_source;
      end else begin
        dds_fword_source_buf <= dds_fword_source_buf;
        dds_pword_source_buf <= dds_pword_source_buf;
        dds_amp_source_buf   <= dds_amp_source_buf;
      end
    end
  end

  wire [31 : 0] direct_output_fword;
  wire [31 : 0] direct_output_pword;
  wire [31 : 0] direct_output_amp;
  reg  [ 2 : 0] direct_en;
  direct #(
      .DDS_FREQ(DDS_FREQ)
  ) direct_inst (
      .clk (clk),
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
  reg  [ 2 : 0] drg_en;
  drg #(
      .DDS_FREQ(DDS_FREQ)
  ) drg_inst (
      .clk (clk),
      .rstn(rstn),

      .param_wen      (param_wen),
      .drg_freq_start (drg_freq_start),
      .drg_freq_end   (drg_freq_end),
      .drg_freq_step  (drg_freq_step),
      .drg_freq_pulse (drg_freq_pulse),
      .drg_phase_start(drg_phase_start),
      .drg_phase_end  (drg_phase_end),
      .drg_phase_step (drg_phase_step),
      .drg_phase_pulse(drg_phase_pulse),
      .drg_amp_start  (drg_amp_start),
      .drg_amp_end    (drg_amp_end),
      .drg_amp_step   (drg_amp_step),
      .drg_amp_pulse  (drg_amp_pulse),

      .drg_en(drg_en),

      .dds_clk         (dac_clk),
      .drg_output_fword(drg_output_fword),
      .drg_output_pword(drg_output_pword),
      .drg_output_amp  (drg_output_amp)
  );

  wire [31 : 0] adc_output_fword;
  wire [31 : 0] adc_output_pword;
  wire [31 : 0] adc_output_amp;
  reg  [ 2 : 0] adc_en;
  adc #(
      .DDS_FREQ (DDS_FREQ),
      .ADC_WIDTH(ADC_WIDTH)
  ) adc_inst (
      .clk (clk),
      .rstn(rstn),

      .param_wen         (param_wen),
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
      .adc_amp_zero_cal  (adc_amp_zero_cal),

      .adc_en(adc_en),

      .adc_clk   (adc_clk),
      .adc_data_1(adc_data_1),
      .adc_data_2(adc_data_2),

      .dds_clk         (dac_clk),
      .adc_output_fword(adc_output_fword),
      .adc_output_pword(adc_output_pword),
      .adc_output_amp  (adc_output_amp)
  );

  always @(posedge dac_clk) begin
    if (!rstn) begin
      direct_en     <= 3'b0;
      drg_en        <= 3'b0;
      adc_en        <= 3'b0;

      phase_fword_i <= 32'h0;
      phase_pword_i <= 32'h0;
      amptitude     <= 32'h0;
    end
    begin
      case (dds_fword_source)
        32'h0000_0001: begin
          direct_en[0]  <= 1'b1;
          drg_en[0]     <= 1'b0;
          adc_en[0]     <= 1'b0;

          phase_fword_i <= direct_output_fword;
        end

        32'h0000_0002: begin
          direct_en[0]  <= 1'b0;
          drg_en[0]     <= 1'b1;
          adc_en[0]     <= 1'b0;

          phase_fword_i <= drg_output_fword;
        end

        32'h0000_0003: begin
          direct_en[0]  <= 1'b0;
          drg_en[0]     <= 1'b0;
          adc_en[0]     <= 1'b1;

          phase_fword_i <= adc_output_fword;
        end

        default: begin
          direct_en[0]  <= 1'b0;
          drg_en[0]     <= 1'b0;
          adc_en[0]     <= 1'b0;

          phase_fword_i <= 32'h0;
        end
      endcase

      case (dds_pword_source)
        32'h0000_0001: begin
          direct_en[1]  <= 1'b1;
          drg_en[1]     <= 1'b0;
          adc_en[1]     <= 1'b0;

          phase_pword_i <= direct_output_pword;
        end

        32'h0000_0002: begin
          direct_en[1]  <= 1'b0;
          drg_en[1]     <= 1'b1;
          adc_en[1]     <= 1'b0;

          phase_pword_i <= drg_output_pword;
        end

        32'h0000_0003: begin
          direct_en[1]  <= 1'b0;
          drg_en[1]     <= 1'b0;
          adc_en[1]     <= 1'b1;

          phase_pword_i <= adc_output_pword;
        end

        default: begin
          direct_en[1]  <= 1'b0;
          drg_en[1]     <= 1'b0;
          adc_en[1]     <= 1'b0;

          phase_pword_i <= 32'h0;
        end
      endcase

      case (dds_amp_source)
        32'h0000_0001: begin
          direct_en[2] <= 1'b1;
          drg_en[2]    <= 1'b0;
          adc_en[2]    <= 1'b0;

          amptitude    <= direct_output_amp;
        end

        32'h0000_0002: begin
          direct_en[2] <= 1'b0;
          drg_en[2]    <= 1'b1;
          adc_en[2]    <= 1'b0;

          amptitude    <= drg_output_amp;
        end

        32'h0000_0003: begin
          direct_en[2] <= 1'b0;
          drg_en[2]    <= 1'b0;
          adc_en[2]    <= 1'b1;

          amptitude    <= adc_output_amp;
        end

        default: begin
          direct_en[2] <= 1'b0;
          drg_en[2]    <= 1'b0;
          adc_en[2]    <= 1'b0;

          amptitude    <= 32'h0;
        end
      endcase
    end
  end

endmodule
