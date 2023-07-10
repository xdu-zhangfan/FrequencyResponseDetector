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
    output     [31 : 0] phase_fword
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
  reg [31 : 0] configure_ram[7 : 0];
  reg [8 : 0] configure_ram_ci;

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
            addr_buf  <= addr_buf;

            param_wen <= 1'b0;

            if (spi_s_valid && spi_s_ready) begin
              spi_s_ready     <= 1'b0;
              spi_s_tx_data   <= addr_buf;
              data_buf[7 : 0] <= spi_s_rx_data;

              config_state    <= CONFIG_STATE_RECV_DATA_B1;
            end else begin
              spi_s_ready   <= 1'b1;
              spi_s_tx_data <= 8'h0;

              config_state  <= CONFIG_STATE_RECV_DATA_B0;
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

  assign phase_fword = configure_ram[0];

endmodule
