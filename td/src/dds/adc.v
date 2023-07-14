module adc_core #(
    parameter DDS_FREQ  = 32'd120000000,
    parameter ADC_WIDTH = 12
) (
    input clk,
    input rstn,

    input          param_wen,
    input [31 : 0] adc_center,
    input [31 : 0] adc_kf,
    input [31 : 0] adc_ch_sel,
    input [31 : 0] adc_zero_cal,

    input adc_en,

    input                     adc_clk,
    input [ADC_WIDTH - 1 : 0] adc_data_1,
    input [ADC_WIDTH - 1 : 0] adc_data_2,

    input           dds_clk,
    output [31 : 0] adc_core_output
);

  reg [31 : 0] adc_center_buf;
  reg [31 : 0] adc_kf_buf;
  reg [31 : 0] adc_ch_sel_buf;
  reg [31 : 0] adc_zero_cal_buf;
  always @(posedge clk) begin
    if (!rstn) begin
      adc_center_buf   <= 32'h0;
      adc_kf_buf       <= 32'h0;
      adc_ch_sel_buf   <= 32'h0;
      adc_zero_cal_buf <= 32'h0;
    end else begin
      if (param_wen) begin
        adc_center_buf   <= adc_center;
        adc_kf_buf       <= adc_kf;
        adc_ch_sel_buf   <= adc_ch_sel;
        adc_zero_cal_buf <= adc_zero_cal;
      end else begin
        adc_center_buf   <= adc_center_buf;
        adc_kf_buf       <= adc_kf_buf;
        adc_ch_sel_buf   <= adc_ch_sel_buf;
        adc_zero_cal_buf <= adc_zero_cal_buf;
      end
    end
  end

  reg [ADC_WIDTH - 1 : 0] adc_data;
  always @(posedge adc_clk) begin
    if (!rstn) begin
      adc_data <= {ADC_WIDTH{1'b0}};
    end else begin
      if (adc_ch_sel_buf == 32'h0000_0001) begin
        adc_data <= adc_data_1;
      end else if (adc_ch_sel_buf == 32'h0000_0002) begin
        adc_data <= adc_data_2;
      end else begin
        adc_data <= {ADC_WIDTH{1'b0}};
      end
    end
  end

  reg  [31 : 0] adc_core_output_i;
  wire [31 : 0] adc_mul_temp_0;
  always @(posedge adc_clk) begin
    if (!rstn) begin
      adc_core_output_i <= 32'h0;
    end else begin
      if (adc_data < adc_zero_cal_buf) begin
        adc_core_output_i <= adc_center_buf - adc_mul_temp_0;
      end else begin
        adc_core_output_i <= adc_center_buf + adc_mul_temp_0;
      end
    end
  end

  dds_adc_mul_0 dds_adc_mul_0_inst (
      .clk(adc_clk),
      .rst(~rstn),

      .a(adc_kf_buf),
      .y(adc_data < adc_zero_cal_buf ? adc_zero_cal_buf - adc_data : adc_data - adc_zero_cal_buf),
      .p(adc_mul_temp_0)
  );

  adc_core_fifo_0 adc_core_fifo_0_inst (
      .rst(~rstn),

      .clkw(adc_clk),
      .we  (adc_en),
      .di  (adc_core_output_i),

      .clkr(dds_clk),
      .re  (adc_en),
      .dout(adc_core_output),

      .valid     (),
      .full_flag (),
      .empty_flag(),
      .afull     (),
      .aempty    (),
      .wrusedw   (),
      .rdusedw   ()
  );

endmodule

module adc #(
    parameter DDS_FREQ  = 32'd120000000,
    parameter ADC_WIDTH = 12
) (
    input clk,
    input rstn,

    input          param_wen,
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
    input [31 : 0] adc_amp_zero_cal,

    input [2 : 0] adc_en,

    input          adc_clk,
    input [11 : 0] adc_data_1,
    input [11 : 0] adc_data_2,

    input           dds_clk,
    output [31 : 0] adc_output_fword,
    output [31 : 0] adc_output_pword,
    output [31 : 0] adc_output_amp
);

  adc_core #(
      .DDS_FREQ (DDS_FREQ),
      .ADC_WIDTH(ADC_WIDTH)
  ) adc_freq_inst (
      .clk (clk),
      .rstn(rstn),

      .param_wen   (param_wen),
      .adc_center  (adc_freq_center),
      .adc_kf      (adc_freq_kf),
      .adc_ch_sel  (adc_freq_ch_sel),
      .adc_zero_cal(adc_freq_zero_cal),

      .adc_en(adc_en[0]),

      .adc_clk   (adc_clk),
      .adc_data_1(adc_data_1),
      .adc_data_2(adc_data_2),

      .dds_clk        (dds_clk),
      .adc_core_output(adc_output_fword)
  );

  adc_core #(
      .DDS_FREQ (DDS_FREQ),
      .ADC_WIDTH(ADC_WIDTH)
  ) adc_phase_inst (
      .clk (clk),
      .rstn(rstn),

      .param_wen   (param_wen),
      .adc_center  (adc_phase_center),
      .adc_kf      (adc_phase_kf),
      .adc_ch_sel  (adc_phase_ch_sel),
      .adc_zero_cal(adc_phase_zero_cal),

      .adc_en(adc_en[1]),

      .adc_clk   (adc_clk),
      .adc_data_1(adc_data_1),
      .adc_data_2(adc_data_2),

      .dds_clk        (dds_clk),
      .adc_core_output(adc_output_pword)
  );

  adc_core #(
      .DDS_FREQ (DDS_FREQ),
      .ADC_WIDTH(ADC_WIDTH)
  ) adc_amp_inst (
      .clk (clk),
      .rstn(rstn),

      .param_wen   (param_wen),
      .adc_center  (adc_amp_center),
      .adc_kf      (adc_amp_kf),
      .adc_ch_sel  (adc_amp_ch_sel),
      .adc_zero_cal(adc_amp_zero_cal),

      .adc_en(adc_en[2]),

      .adc_clk   (adc_clk),
      .adc_data_1(adc_data_1),
      .adc_data_2(adc_data_2),

      .dds_clk        (dds_clk),
      .adc_core_output(adc_output_amp)
  );

endmodule
