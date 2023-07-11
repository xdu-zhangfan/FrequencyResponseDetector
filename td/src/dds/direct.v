module direct #(
    parameter DDS_FREQ = 32'd120000000
) (
    input clk,
    input rstn,

    input          param_wen,
    input [31 : 0] direct_fword,
    input [31 : 0] direct_pword,
    input [31 : 0] direct_amp,

    input direct_en,

    input               dds_clk,
    output reg [31 : 0] direct_output_fword,
    output reg [31 : 0] direct_output_pword,
    output reg [31 : 0] direct_output_amp
);

  reg [31 : 0] direct_fword_buf;
  reg [31 : 0] direct_pword_buf;
  reg [31 : 0] direct_amp_buf;
  always @(posedge clk) begin
    if (!rstn) begin
      direct_fword_buf <= 32'h0;
      direct_pword_buf <= 32'h0;
      direct_amp_buf   <= 32'h0;
    end else begin
      if (param_wen) begin
        direct_fword_buf <= direct_fword;
        direct_pword_buf <= direct_pword;
        direct_amp_buf   <= direct_amp;
      end else begin
        direct_fword_buf <= direct_fword_buf;
        direct_pword_buf <= direct_pword_buf;
        direct_amp_buf   <= direct_amp_buf;
      end
    end
  end

  always @(posedge dds_clk) begin
    if (!rstn) begin
      direct_output_fword <= 32'h0;
      direct_output_pword <= 32'h0;
      direct_output_amp   <= 32'h0;
    end else begin
      if (direct_en) begin
        direct_output_fword <= direct_fword_buf;
        direct_output_pword <= direct_pword_buf;
        direct_output_amp   <= direct_amp_buf;
      end else begin
        direct_output_fword <= direct_output_fword;
        direct_output_pword <= direct_output_pword;
        direct_output_amp   <= direct_output_amp;
      end
    end
  end

endmodule
