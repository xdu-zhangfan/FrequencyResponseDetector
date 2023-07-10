module drg (
    input clk,
    input rstn,

    input          param_write,
    input [31 : 0] drg_start,
    input [31 : 0] drg_end,
    input [31 : 0] drg_step,

    input               dds_clk,
    output reg [31 : 0] drg_output
);

  reg [31 : 0] drg_start_buf;
  reg [31 : 0] drg_end_buf;
  reg [31 : 0] drg_step_buf;

  always @(posedge clk) begin
    if (!rstn) begin
      drg_start_buf <= 32'h0;
      drg_end_buf   <= 32'h0;
      drg_step_buf  <= 32'h0;
    end else begin
      if (param_write) begin
        drg_start_buf <= drg_start;
        drg_end_buf   <= drg_end;
        drg_step_buf  <= drg_step;
      end else begin
        drg_start_buf <= drg_start_buf;
        drg_end_buf   <= drg_end_buf;
        drg_step_buf  <= drg_step_buf;
      end
    end
  end

  always @(posedge dds_clk) begin
    if (!rstn) begin
      drg_output <= drg_start_buf;
    end else begin
      if (drg_output + drg_step_buf < drg_end_buf) begin
        drg_output <= drg_output + drg_step_buf;
      end else begin
        drg_output <= drg_start_buf;
      end
    end
  end

endmodule
