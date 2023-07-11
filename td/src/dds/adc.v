module adc_freq #(
    parameter DDS_FREQ  = 32'd120000000,
    parameter ADC_WIDTH = 12
) (
    input clk,
    input rstn,

    input          param_wen,
    input [31 : 0] adc_freq_center,
    input [31 : 0] adc_freq_kf,
    input [31 : 0] adc_freq_ch_sel,

    input adc_en,

    input                     adc_clk,
    input [ADC_WIDTH - 1 : 0] adc_data_1,
    input [ADC_WIDTH - 1 : 0] adc_data_2,

    input               dds_clk,
    output reg [31 : 0] adc_output_fword
);

  reg [31 : 0] adc_freq_center_buf;
  reg [31 : 0] adc_freq_kf_buf;
  reg [31 : 0] adc_freq_ch_sel_buf;
  always @(posedge clk) begin
    if (!rstn) begin
      adc_freq_center_buf <= 32'h0;
      adc_freq_kf_buf     <= 32'h0;
      adc_freq_ch_sel_buf <= 32'h0;
    end else begin
      if (param_wen) begin
        adc_freq_center_buf <= adc_freq_center;
        adc_freq_kf_buf     <= adc_freq_kf;
        adc_freq_ch_sel_buf <= adc_freq_ch_sel;
      end else begin
        adc_freq_center_buf <= adc_freq_center_buf;
        adc_freq_kf_buf     <= adc_freq_kf_buf;
        adc_freq_ch_sel_buf <= adc_freq_ch_sel_buf;
      end
    end
  end

  reg [ADC_WIDTH - 1 : 0] adc_data;
  always @(posedge adc_clk) begin
    if (!rstn) begin
      adc_data <= {ADC_WIDTH{1'b0}};
    end else begin
      if (adc_freq_ch_sel_buf == 32'h0000_0001) begin
        adc_data <= adc_data_1;
      end else if (adc_freq_ch_sel_buf == 32'h0000_0002) begin
        adc_data <= adc_data_2;
      end else begin
        adc_data <= {ADC_WIDTH{1'b0}};
      end
    end
  end

  reg  [31 : 0] adc_output_fword_i;
  wire [31 : 0] adc_mul_temp_0;
  always @(posedge adc_clk) begin
    if ((!rstn) || (!adc_en)) begin
      adc_output_fword_i <= 32'h0;
    end else begin
      if (adc_data < (1 << (ADC_WIDTH - 1))) begin
        adc_output_fword_i <= adc_freq_center_buf - adc_mul_temp_0;
      end else begin
        adc_output_fword_i <= adc_freq_center_buf + adc_mul_temp_0;
      end
    end
  end

  always @(posedge dds_clk) begin
    if ((!rstn) || (!adc_en)) begin
      adc_output_fword <= 32'h0;
    end else begin
      adc_output_fword <= adc_output_fword_i;
    end
  end

  dds_adc_mul_0 dds_adc_mul_0_inst (
      .clk(adc_clk),
      .rst(~rstn),

      .a(adc_amp_kf_buf),
      .y(adc_data),
      .p(adc_mul_temp_0)
  );

endmodule

module adc_amp #(
    parameter DDS_FREQ  = 32'd120000000,
    parameter ADC_WIDTH = 12
) (
    input clk,
    input rstn,

    input          param_wen,
    input [31 : 0] adc_amp_center,
    input [31 : 0] adc_amp_kf,
    input [31 : 0] adc_amp_ch_sel,

    input adc_en,

    input          adc_clk,
    input [11 : 0] adc_data_1,
    input [11 : 0] adc_data_2,

    input               dds_clk,
    output reg [31 : 0] adc_output_amp
);

  reg [31 : 0] adc_amp_center_buf;
  reg [31 : 0] adc_amp_kf_buf;
  reg [31 : 0] adc_amp_ch_sel_buf;
  always @(posedge clk) begin
    if (!rstn) begin
      adc_amp_center_buf <= 32'h0;
      adc_amp_kf_buf     <= 32'h0;
      adc_amp_ch_sel_buf <= 32'h0;
    end else begin
      if (param_wen) begin
        adc_amp_center_buf <= adc_amp_center;
        adc_amp_kf_buf     <= adc_amp_kf;
        adc_amp_ch_sel_buf <= adc_amp_ch_sel;
      end else begin
        adc_amp_center_buf <= adc_amp_center_buf;
        adc_amp_kf_buf     <= adc_amp_kf_buf;
        adc_amp_ch_sel_buf <= adc_amp_ch_sel_buf;
      end
    end
  end

  reg [ADC_WIDTH - 1 : 0] adc_data;
  always @(posedge adc_clk) begin
    if (!rstn) begin
      adc_data <= {ADC_WIDTH{1'b0}};
    end else begin
      if (adc_amp_ch_sel_buf == 32'h0000_0001) begin
        adc_data <= adc_data_1;
      end else if (adc_amp_ch_sel_buf == 32'h0000_0002) begin
        adc_data <= adc_data_2;
      end else begin
        adc_data <= {ADC_WIDTH{1'b0}};
      end
    end
  end

  reg  [31 : 0] adc_output_amp_i;
  wire [31 : 0] adc_mul_temp_0;
  always @(posedge adc_clk) begin
    if (!rstn) begin
      adc_output_amp_i <= 32'h0;
    end else begin
      if (adc_en) begin
        if (adc_data < (1 << (ADC_WIDTH - 1))) begin
          adc_output_amp_i <= adc_amp_center_buf - adc_mul_temp_0;
        end else begin
          adc_output_amp_i <= adc_amp_center_buf + adc_mul_temp_0;
        end
      end else begin
        adc_output_amp_i <= adc_output_amp_i;
      end
    end
  end

  always @(posedge dds_clk) begin
    if ((!rstn) || (!adc_en)) begin
      adc_output_amp <= 32'h0;
    end else begin
      adc_output_amp <= adc_output_amp_i;
    end
  end

  dds_adc_mul_0 dds_adc_mul_0_inst (
      .clk(adc_clk),
      .rst(~rstn),

      .a(adc_amp_kf_buf),
      .y(adc_data),
      .p(adc_mul_temp_0)
  );

endmodule

module adc #(
    parameter DDS_FREQ  = 32'd120000000,
    parameter ADC_WIDTH = 12
) (
    input clk,
    input rstn,

    input          param_wen,
    input [31 : 0] adc_amp_center,
    input [31 : 0] adc_amp_kf,
    input [31 : 0] adc_amp_ch_sel,
    input [31 : 0] adc_freq_center,
    input [31 : 0] adc_freq_kf,
    input [31 : 0] adc_freq_ch_sel,

    input adc_en,

    input          adc_clk,
    input [11 : 0] adc_data_1,
    input [11 : 0] adc_data_2,

    input           dds_clk,
    output [31 : 0] adc_output_fword,
    output [31 : 0] adc_output_pword,
    output [31 : 0] adc_output_amp
);

  adc_freq #(
      .DDS_FREQ (DDS_FREQ),
      .ADC_WIDTH(ADC_WIDTH)
  ) adc_freq_inst (
      .clk (clk),
      .rstn(rstn),

      .param_wen      (param_wen),
      .adc_freq_center(adc_freq_center),
      .adc_freq_kf    (adc_freq_kf),
      .adc_freq_ch_sel(adc_freq_ch_sel),

      .adc_en(adc_en),

      .adc_clk   (adc_clk),
      .adc_data_1(adc_data_1),
      .adc_data_2(adc_data_2),

      .dds_clk         (dds_clk),
      .adc_output_fword(adc_output_fword)
  );

  adc_amp #(
      .DDS_FREQ (DDS_FREQ),
      .ADC_WIDTH(ADC_WIDTH)
  ) adc_amp_inst (
      .clk (clk),
      .rstn(rstn),

      .param_wen     (param_wen),
      .adc_amp_center(adc_amp_center),
      .adc_amp_kf    (adc_amp_kf),
      .adc_amp_ch_sel(adc_amp_ch_sel),

      .adc_en(adc_en),

      .adc_clk   (adc_clk),
      .adc_data_1(adc_data_1),
      .adc_data_2(adc_data_2),

      .dds_clk       (dds_clk),
      .adc_output_amp(adc_output_amp)
  );

  assign adc_output_pword = 32'h0;

endmodule
