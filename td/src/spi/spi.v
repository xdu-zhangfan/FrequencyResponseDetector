module spi #(
    parameter SYSCLK_FREQ = 50000000,  // System clock frequency, default 50MHz
    parameter SPICLK_FREQ = 1000000,   // SPI clock frequency, default 1MHz

    parameter CPOL  = 0,  // Clock Polarity, 0 and 1 allowed
    parameter CPHA  = 0,  // Clock Phase, 0 and 1 allowed
    parameter FSB   = 1,  // First bit, 0-LSB, 1-MSB
    parameter WIDTH = 8   // Data bit width
) (
    input clk,
    input rstn,

    input  spi_s_sclk,
    input  spi_s_ss_n,
    input  spi_s_mosi,
    output spi_s_miso,

    output spi_m_sclk,
    output spi_m_ss_n,
    output spi_m_mosi,
    input  spi_m_miso,

    output reg          param_wen,
    output     [31 : 0] dds_fword_source,
    output     [31 : 0] dds_pword_source,
    output     [31 : 0] dds_amp_source,
    output     [31 : 0] direct_fword,
    output     [31 : 0] direct_pword,
    output     [31 : 0] direct_amp,
    output     [31 : 0] drg_freq_start,
    output     [31 : 0] drg_freq_end,
    output     [31 : 0] drg_freq_step,
    output     [31 : 0] drg_freq_pulse,
    output     [31 : 0] drg_phase_start,
    output     [31 : 0] drg_phase_end,
    output     [31 : 0] drg_phase_step,
    output     [31 : 0] drg_phase_pulse,
    output     [31 : 0] drg_amp_start,
    output     [31 : 0] drg_amp_end,
    output     [31 : 0] drg_amp_step,
    output     [31 : 0] drg_amp_pulse,
    output     [31 : 0] adc_freq_center,
    output     [31 : 0] adc_freq_kf,
    output     [31 : 0] adc_freq_ch_sel,
    output     [31 : 0] adc_freq_zero_cal,
    output     [31 : 0] adc_phase_center,
    output     [31 : 0] adc_phase_kf,
    output     [31 : 0] adc_phase_ch_sel,
    output     [31 : 0] adc_phase_zero_cal,
    output     [31 : 0] adc_amp_center,
    output     [31 : 0] adc_amp_kf,
    output     [31 : 0] adc_amp_ch_sel,
    output     [31 : 0] adc_amp_zero_cal
);

  wire                 spi_m_valid;
  reg                  spi_m_ready;
  wire [WIDTH - 1 : 0] spi_m_rx_data;
  reg  [WIDTH - 1 : 0] spi_m_tx_data;
  spi_master #(
      .SYSCLK_FREQ(SYSCLK_FREQ),
      .SPICLK_FREQ(SPICLK_FREQ),

      .CPOL (CPOL),
      .CPHA (CPHA),
      .FSB  (FSB),
      .WIDTH(WIDTH)
  ) spi_master_inst (
      .clk (clk),
      .rstn(rstn),

      .spi_sclk(spi_m_sclk),
      .spi_ss_n(spi_m_ss_n),
      .spi_mosi(spi_m_mosi),
      .spi_miso(spi_m_miso),

      .spi_valid  (spi_m_valid),
      .spi_ready  (spi_m_ready),
      .spi_rx_data(spi_m_rx_data),
      .spi_tx_data(spi_m_tx_data)
  );

  wire                 spi_s_valid;
  reg                  spi_s_ready;
  wire [WIDTH - 1 : 0] spi_s_rx_data;
  reg  [WIDTH - 1 : 0] spi_s_tx_data;
  spi_slave #(
      .CPOL (CPOL),
      .CPHA (CPHA),
      .FSB  (FSB),
      .WIDTH(WIDTH)
  ) spi_slave_inst (
      .clk (clk),
      .rstn(rstn),

      .spi_sclk(spi_s_sclk),
      .spi_ss_n(spi_s_ss_n),
      .spi_mosi(spi_s_mosi),
      .spi_miso(spi_s_miso),

      .spi_valid  (spi_s_valid),
      .spi_ready  (spi_s_ready),
      .spi_rx_data(spi_s_rx_data),
      .spi_tx_data(spi_s_tx_data)
  );

  localparam CONFIG_STATE_RESET = 8'h00;
  localparam CONFIG_STATE_IDEL = 8'h01;
  localparam CONFIG_STATE_RECV_ADDR = 8'h02;
  localparam CONFIG_STATE_RECV_DATA_B0 = 8'h03;
  localparam CONFIG_STATE_RECV_DATA_B1 = 8'h04;
  localparam CONFIG_STATE_RECV_DATA_B2 = 8'h05;
  localparam CONFIG_STATE_RECV_DATA_B3 = 8'h06;
  localparam CONFIG_STATE_WRITE = 8'h07;
  reg [ 7 : 0] config_state;
  reg [ 7 : 0] addr_buf;
  reg [31 : 0] data_buf;

  localparam CONFIGURE_RAM_CI_MAX = 256;
  reg [31 : 0] configure_ram[0 : 255];
  reg [15 : 0] configure_ram_ci;

  always @(posedge clk) begin
    if (!rstn) begin
      configure_ram_ci <= 8'h0;

      addr_buf         <= 8'h0;
      data_buf         <= 32'h0;
      spi_s_ready      <= 1'b0;

      param_wen        <= 1'b0;

      config_state     <= CONFIG_STATE_RESET;
    end else begin
      if (configure_ram_ci < CONFIGURE_RAM_CI_MAX) begin
        configure_ram[configure_ram_ci] <= 32'h0;
        configure_ram_ci                <= configure_ram_ci + 1;

        addr_buf                        <= 8'h0;
        data_buf                        <= 32'h0;
        spi_s_ready                     <= 1'b0;

        param_wen                       <= 1'b0;

        config_state                    <= CONFIG_STATE_RESET;
      end else begin
        configure_ram_ci <= CONFIGURE_RAM_CI_MAX;

        case (config_state)
          CONFIG_STATE_RESET: begin
            addr_buf      <= 8'h0;
            data_buf      <= 32'h0;
            spi_s_ready   <= 1'b0;
            spi_s_tx_data <= 8'h0;

            param_wen     <= 1'b0;

            config_state  <= CONFIG_STATE_IDEL;
          end

          CONFIG_STATE_IDEL: begin
            addr_buf      <= 8'h0;
            data_buf      <= 32'h0;
            spi_s_tx_data <= 8'h0;

            param_wen     <= 1'b0;

            if ((spi_s_valid && spi_s_ready) & (spi_s_rx_data == 8'h5a)) begin
              spi_s_ready  <= 1'b0;
              config_state <= CONFIG_STATE_RECV_ADDR;
            end else begin
              spi_s_ready  <= 1'b1;
              config_state <= CONFIG_STATE_IDEL;
            end
          end

          CONFIG_STATE_RECV_ADDR: begin
            data_buf      <= 32'h0;
            spi_s_tx_data <= 8'h0;

            param_wen     <= 1'b0;

            if (spi_s_valid && spi_s_ready) begin
              spi_s_ready  <= 1'b0;
              addr_buf     <= spi_s_rx_data;

              config_state <= CONFIG_STATE_RECV_DATA_B0;
            end else begin
              spi_s_ready  <= 1'b1;

              config_state <= CONFIG_STATE_RECV_ADDR;
            end
          end

          CONFIG_STATE_RECV_DATA_B0: begin
            addr_buf      <= addr_buf;
            spi_s_tx_data <= addr_buf;

            param_wen     <= 1'b0;

            if (spi_s_valid && spi_s_ready) begin
              spi_s_ready     <= 1'b0;
              data_buf[7 : 0] <= spi_s_rx_data;

              config_state    <= CONFIG_STATE_RECV_DATA_B1;
            end else begin
              spi_s_ready  <= 1'b1;

              config_state <= CONFIG_STATE_RECV_DATA_B0;
            end
          end

          CONFIG_STATE_RECV_DATA_B1: begin
            addr_buf      <= addr_buf;
            spi_s_tx_data <= 8'h0;

            param_wen     <= 1'b0;

            if (spi_s_valid && spi_s_ready) begin
              spi_s_ready      <= 1'b0;
              data_buf[15 : 8] <= spi_s_rx_data;

              config_state     <= CONFIG_STATE_RECV_DATA_B2;
            end else begin
              spi_s_ready  <= 1'b1;

              config_state <= CONFIG_STATE_RECV_DATA_B1;
            end
          end

          CONFIG_STATE_RECV_DATA_B2: begin
            addr_buf      <= addr_buf;
            spi_s_tx_data <= 8'h0;

            param_wen     <= 1'b0;

            if (spi_s_valid && spi_s_ready) begin
              spi_s_ready       <= 1'b0;
              data_buf[23 : 16] <= spi_s_rx_data;

              config_state      <= CONFIG_STATE_RECV_DATA_B3;
            end else begin
              spi_s_ready  <= 1'b1;

              config_state <= CONFIG_STATE_RECV_DATA_B2;
            end
          end

          CONFIG_STATE_RECV_DATA_B3: begin
            addr_buf      <= addr_buf;
            spi_s_tx_data <= 8'h0;

            param_wen     <= 1'b0;

            if (spi_s_valid && spi_s_ready) begin
              spi_s_ready       <= 1'b0;
              data_buf[31 : 24] <= spi_s_rx_data;

              config_state      <= CONFIG_STATE_WRITE;
            end else begin
              spi_s_ready  <= 1'b1;

              config_state <= CONFIG_STATE_RECV_DATA_B3;
            end
          end

          CONFIG_STATE_WRITE: begin
            addr_buf                <= addr_buf;
            data_buf                <= data_buf;
            spi_s_ready             <= 1'b0;
            spi_s_tx_data           <= 8'h0;

            param_wen               <= 1'b1;

            configure_ram[addr_buf] <= data_buf;

            config_state            <= CONFIG_STATE_IDEL;
          end

          default: begin
            addr_buf      <= 8'h0;
            data_buf      <= 32'h0;
            spi_s_ready   <= 1'b0;
            spi_s_tx_data <= 8'h0;

            param_wen     <= 1'b0;

            config_state  <= CONFIG_STATE_RESET;
          end
        endcase
      end
    end
  end

  assign dds_fword_source   = configure_ram[8'h01];
  assign dds_pword_source   = configure_ram[8'h02];
  assign dds_amp_source     = configure_ram[8'h03];
  assign direct_fword       = configure_ram[8'h11];
  assign direct_pword       = configure_ram[8'h12];
  assign direct_amp         = configure_ram[8'h13];
  assign drg_freq_start     = configure_ram[8'h21];
  assign drg_freq_end       = configure_ram[8'h22];
  assign drg_freq_step      = configure_ram[8'h23];
  assign drg_freq_pulse     = configure_ram[8'h24];
  assign drg_phase_start    = configure_ram[8'h25];
  assign drg_phase_end      = configure_ram[8'h26];
  assign drg_phase_step     = configure_ram[8'h27];
  assign drg_phase_pulse    = configure_ram[8'h28];
  assign drg_amp_start      = configure_ram[8'h29];
  assign drg_amp_end        = configure_ram[8'h2a];
  assign drg_amp_step       = configure_ram[8'h2b];
  assign drg_amp_pulse      = configure_ram[8'h2c];
  assign adc_freq_center    = configure_ram[8'h31];
  assign adc_freq_kf        = configure_ram[8'h32];
  assign adc_freq_ch_sel    = configure_ram[8'h33];
  assign adc_freq_zero_cal  = configure_ram[8'h34];
  assign adc_phase_center   = configure_ram[8'h35];
  assign adc_phase_kf       = configure_ram[8'h36];
  assign adc_phase_ch_sel   = configure_ram[8'h37];
  assign adc_phase_zero_cal = configure_ram[8'h38];
  assign adc_amp_center     = configure_ram[8'h39];
  assign adc_amp_kf         = configure_ram[8'h3a];
  assign adc_amp_ch_sel     = configure_ram[8'h3b];
  assign adc_amp_zero_cal   = configure_ram[8'h3c];
endmodule
