#ifndef FPGA_H
#define FPGA_H

#include "main.h"

#include <stdlib.h>
#include <string.h>

#define DDS_FREQ 125000000.0f
#define FWORD_BANDWIDTH 4294967296.0f

int fpga_init(SPI_HandleTypeDef *hspi_master_i, SPI_HandleTypeDef *hspi_slave_i);
int fpga_write_reg(unsigned char addr, unsigned int data);

#endif