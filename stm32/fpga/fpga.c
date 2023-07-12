#include "fpga.h"

SPI_HandleTypeDef *hspi_master;
SPI_HandleTypeDef *hspi_slave;

int fpga_init(SPI_HandleTypeDef *hspi_master_i, SPI_HandleTypeDef *hspi_slave_i)
{
    hspi_master = hspi_master_i;
    hspi_slave = hspi_slave_i;

    return 0;
}

int fpga_write_reg(unsigned char addr, unsigned int data)
{
    unsigned char spi_send_buffer[6] = {0};
    unsigned char spi_recv_buffer[6] = {0};

    spi_send_buffer[0] = 0x5a;
    spi_send_buffer[1] = addr;
    memcpy(&(spi_send_buffer[2]), &data, sizeof(unsigned int));

    HAL_SPI_TransmitReceive(hspi_master, spi_send_buffer, spi_recv_buffer, 6, HAL_MAX_DELAY);

    return 0;
}