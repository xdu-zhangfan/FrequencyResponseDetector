module drg_core #(
    parameter DDS_FREQ = 32'd120000000
) (
    input clk,
    input rstn,

    input          param_wen,
    input [31 : 0] drg_start,
    input [31 : 0] drg_end,
    input [31 : 0] drg_step,
    input [31 : 0] drg_pulse,

    input drg_en,

    input               dds_clk,
    output reg [31 : 0] drg_output
);
  reg [31 : 0] drg_start_buf;
  reg [31 : 0] drg_end_buf;
  reg [31 : 0] drg_step_buf;
  reg [31 : 0] drg_pulse_buf;
  always @(posedge clk) begin
    if (!rstn) begin
      drg_start_buf <= 32'h0;
      drg_end_buf   <= 32'h0;
      drg_step_buf  <= 32'h0;
      drg_pulse_buf <= 32'h0;
    end else begin
      if (param_wen) begin
        drg_start_buf <= drg_start;
        drg_end_buf   <= drg_end;
        drg_step_buf  <= drg_step;
        drg_pulse_buf <= drg_pulse;
      end else begin
        drg_start_buf <= drg_start_buf;
        drg_end_buf   <= drg_end_buf;
        drg_step_buf  <= drg_step_buf;
        drg_pulse_buf <= drg_pulse_buf;
      end
    end
  end

  reg [31 : 0] drg_pulse_cnt;
  always @(posedge dds_clk) begin
    if (!rstn) begin
      drg_pulse_cnt <= 32'h0;
      drg_output    <= drg_start_buf;
    end else begin
      if (drg_en) begin
        if (drg_pulse_cnt >= drg_pulse_buf) begin
          drg_pulse_cnt <= 32'h0;

          if (drg_output + drg_step_buf < drg_end_buf) begin
            drg_output <= drg_output + drg_step_buf;
          end else begin
            drg_output <= drg_start_buf;
          end
        end else begin
          drg_pulse_cnt <= drg_pulse_cnt + 1;

          drg_output <= drg_output;
        end
      end else begin
        drg_output <= drg_output;
      end
    end
  end

endmodule

module drg #(
    parameter DDS_FREQ = 32'd120000000
) (
    input clk,
    input rstn,

    input          param_wen,
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

    input [2 : 0] drg_en,

    input           dds_clk,
    output [31 : 0] drg_output_fword,
    output [31 : 0] drg_output_pword,
    output [31 : 0] drg_output_amp
);

  drg_core #(
      .DDS_FREQ(DDS_FREQ)
  ) drg_freqreq_inst (
      .clk (clk),
      .rstn(rstn),

      .param_wen(param_wen),
      .drg_start(drg_freq_start),
      .drg_end  (drg_freq_end),
      .drg_step (drg_freq_step),
      .drg_pulse(drg_freq_pulse),

      .drg_en(drg_en[0]),

      .dds_clk   (dds_clk),
      .drg_output(drg_output_fword)
  );

  drg_core #(
      .DDS_FREQ(DDS_FREQ)
  ) drg_phasehase_inst (
      .clk (clk),
      .rstn(rstn),

      .param_wen(param_wen),
      .drg_start(drg_phase_start),
      .drg_end  (drg_phase_end),
      .drg_step (drg_phase_step),
      .drg_pulse(drg_phase_pulse),

      .drg_en(drg_en[1]),

      .dds_clk   (dds_clk),
      .drg_output(drg_output_pword)
  );

  drg_core #(
      .DDS_FREQ(DDS_FREQ)
  ) drg_ampmp_inst (
      .clk (clk),
      .rstn(rstn),

      .param_wen(param_wen),
      .drg_start(drg_amp_start),
      .drg_end  (drg_amp_end),
      .drg_step (drg_amp_step),
      .drg_pulse(drg_amp_pulse),

      .drg_en(drg_en[2]),

      .dds_clk   (dds_clk),
      .drg_output(drg_output_amp)
  );

endmodule
