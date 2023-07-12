#ifndef FPGA_H
#define FPGA_H

#include "main.h"

#include <stdlib.h>
#include <string.h>

int fpga_init(SPI_HandleTypeDef *hspi_master_i, SPI_HandleTypeDef *hspi_slave_i);
int fpga_write_reg(unsigned char addr, unsigned int data);

#endif