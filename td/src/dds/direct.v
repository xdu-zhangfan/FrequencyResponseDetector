module direct_core #(
    parameter DDS_FREQ = 32'd120000000
) (
    input clk,
    input rstn,

    input          param_wen,
    input [31 : 0] direct_word,

    input direct_en,

    input               dds_clk,
    output reg [31 : 0] direct_output
);
  reg [31 : 0] direct_word_buf;
  always @(posedge clk) begin
    if (!rstn) begin
      direct_word_buf <= 32'h0;
    end else begin
      if (param_wen) begin
        direct_word_buf <= direct_word;
      end else begin
        direct_word_buf <= direct_word_buf;
      end
    end
  end

  always @(posedge dds_clk) begin
    if (!rstn) begin
      direct_output <= 32'h0;
    end else begin
      if (direct_en) begin
        direct_output <= direct_word_buf;
      end else begin
        direct_output <= direct_output;
      end
    end
  end
endmodule

module direct #(
    parameter DDS_FREQ = 32'd120000000
) (
    input clk,
    input rstn,

    input          param_wen,
    input [31 : 0] direct_fword,
    input [31 : 0] direct_pword,
    input [31 : 0] direct_amp,

    input [2 : 0] direct_en,

    input           dds_clk,
    output [31 : 0] direct_output_fword,
    output [31 : 0] direct_output_pword,
    output [31 : 0] direct_output_amp
);

  direct_core #(
      .DDS_FREQ(DDS_FREQ)
  ) direct_freq_inst (
      .clk (clk),
      .rstn(rstn),

      .param_wen  (param_wen),
      .direct_word(direct_fword),

      .direct_en(direct_en[0]),

      .dds_clk(dds_clk),
      .direct_output(direct_output_fword)
  );

  direct_core #(
      .DDS_FREQ(DDS_FREQ)
  ) direct_phase_inst (
      .clk (clk),
      .rstn(rstn),

      .param_wen  (param_wen),
      .direct_word(direct_pword),

      .direct_en(direct_en[1]),

      .dds_clk(dds_clk),
      .direct_output(direct_output_pword)
  );

  direct_core #(
      .DDS_FREQ(DDS_FREQ)
  ) direct_amp_inst (
      .clk (clk),
      .rstn(rstn),

      .param_wen  (param_wen),
      .direct_word(direct_amp),

      .direct_en(direct_en[2]),

      .dds_clk(dds_clk),
      .direct_output(direct_output_amp)
  );

endmodule
