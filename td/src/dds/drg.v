module drg #(
    parameter DDS_FREQ = 32'd120000000
) (
    input clk,
    input rstn,

    input          param_wen,
    input [31 : 0] drg_f_start,
    input [31 : 0] drg_f_end,
    input [31 : 0] drg_f_step,
    input [31 : 0] drg_p_start,
    input [31 : 0] drg_p_end,
    input [31 : 0] drg_p_step,
    input [31 : 0] drg_a_start,
    input [31 : 0] drg_a_end,
    input [31 : 0] drg_a_step,

    input drg_en,

    input               dds_clk,
    output reg [31 : 0] drg_output_fword,
    output reg [31 : 0] drg_output_pword,
    output reg [31 : 0] drg_output_amp
);

  reg [31 : 0] drg_f_start_buf;
  reg [31 : 0] drg_f_end_buf;
  reg [31 : 0] drg_f_step_buf;
  reg [31 : 0] drg_p_start_buf;
  reg [31 : 0] drg_p_end_buf;
  reg [31 : 0] drg_p_step_buf;
  reg [31 : 0] drg_a_start_buf;
  reg [31 : 0] drg_a_end_buf;
  reg [31 : 0] drg_a_step_buf;
  always @(posedge clk) begin
    if (!rstn) begin
      drg_f_start_buf <= 32'h0;
      drg_f_end_buf   <= 32'h0;
      drg_f_step_buf  <= 32'h0;
      drg_p_start_buf <= 32'h0;
      drg_p_end_buf   <= 32'h0;
      drg_p_step_buf  <= 32'h0;
      drg_a_start_buf <= 32'h0;
      drg_a_end_buf   <= 32'h0;
      drg_a_step_buf  <= 32'h0;
    end else begin
      if (param_wen) begin
        drg_f_start_buf <= drg_f_start;
        drg_f_end_buf   <= drg_f_end;
        drg_f_step_buf  <= drg_f_step;
        drg_p_start_buf <= drg_p_start;
        drg_p_end_buf   <= drg_p_end;
        drg_p_step_buf  <= drg_p_step;
        drg_a_start_buf <= drg_a_start;
        drg_a_end_buf   <= drg_a_end;
        drg_a_step_buf  <= drg_a_step;
      end else begin
        drg_f_start_buf <= drg_f_start_buf;
        drg_f_end_buf   <= drg_f_end_buf;
        drg_f_step_buf  <= drg_f_step_buf;
        drg_p_start_buf <= drg_p_start_buf;
        drg_p_end_buf   <= drg_p_end_buf;
        drg_p_step_buf  <= drg_p_step_buf;
        drg_a_start_buf <= drg_a_start_buf;
        drg_a_end_buf   <= drg_a_end_buf;
        drg_a_step_buf  <= drg_a_step_buf;
      end
    end
  end

  always @(posedge dds_clk) begin
    if (!rstn) begin
      drg_output_fword <= drg_f_start_buf;
      drg_output_pword <= drg_p_start_buf;
    end else begin
      if (drg_en) begin
        if (drg_output_fword + drg_f_step_buf < drg_f_end_buf) begin
          drg_output_fword <= drg_output_fword + drg_f_step_buf;
        end else begin
          drg_output_fword <= drg_f_start_buf;
        end

        if (drg_output_pword + drg_p_step_buf < drg_p_end_buf) begin
          drg_output_pword <= drg_output_pword + drg_p_step_buf;
        end else begin
          drg_output_pword <= drg_p_start_buf;
        end

        if (drg_output_amp + drg_a_step_buf < drg_a_end_buf) begin
          drg_output_amp <= drg_output_amp + drg_a_step_buf;
        end else begin
          drg_output_amp <= drg_a_start_buf;
        end
      end else begin
        drg_output_fword <= drg_output_fword;
        drg_output_pword <= drg_output_pword;
        drg_output_amp   <= drg_output_amp;
      end
    end
  end

endmodule
