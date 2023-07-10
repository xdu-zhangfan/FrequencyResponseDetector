module dds (
    input clk,
    input rstn,

    input           dac_clk,
    output [13 : 0] dac_data_1,
    output [13 : 0] dac_data_2,

    input          param_wen,
    input [31 : 0] phase_fword
);
  reg [31 : 0] phase_fword_buf;

  always @(posedge clk) begin
    if (!rstn) begin
      phase_fword_buf <= 32'h0;
    end else begin
      if (param_wen) begin
        phase_fword_buf <= phase_fword;
      end else begin
        phase_fword_buf <= phase_fword_buf;
      end
    end
  end

  reg  [31 : 0] dds_phase;
  wire [31 : 0] dds_phy_phase_out;
  wire          dds_phy_rdy;

  wire [13 : 0] dac_data_1_i;
  wire [13 : 0] dac_data_2_i;

  assign dac_data_1 = (dds_phy_rdy) ? dac_data_1_i + 14'd8192 : 14'b0;
  assign dac_data_2 = (dds_phy_rdy) ? dac_data_2_i + 14'd8192 : 14'b0;

  reg [31 : 0] phase_fword_i;
  reg [31 : 0] phase_pword_i;
  always @(posedge dac_clk) begin
    if (!rstn) begin
      phase_fword_i <= 32'hf0000000;
    end else begin
      phase_fword_i <= phase_fword_buf;
    end
  end

  dds_phy dds_phy_inst (
      .clk  (dac_clk),
      .rst_n(rstn),

      .fword(phase_fword_i),
      .pword(phase_pword_i),

      .phase_out(dds_phy_phase_out),
      .rdy      (dds_phy_rdy),
      .wave_cos (dac_data_2_i),
      .wave_sin (dac_data_1_i)
  );

endmodule
