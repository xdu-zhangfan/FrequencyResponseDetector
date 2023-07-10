/* USER CODE BEGIN Header */
/**
 ******************************************************************************
 * @file    stm32f4xx_it.c
 * @brief   Interrupt Service Routines.
 ******************************************************************************
 * @attention
 *
 * Copyright (c) 2023 STMicroelectronics.
 * All rights reserved.
 *
 * This software is licensed under terms that can be found in the LICENSE file
 * in the root directory of this software component.
 * If no LICENSE file comes with this software, it is provided AS-IS.
 *
 ******************************************************************************
 */
/* USER CODE END Header */

/* Includes ------------------------------------------------------------------*/
#include "main.h"
#include "stm32f4xx_it.h"
/* Private includes ----------------------------------------------------------*/
/* USER CODE BEGIN Includes */
/* USER CODE END Includes */

/* Private typedef -----------------------------------------------------------*/
/* USER CODE BEGIN TD */

/* USER CODE END TD */

/* Private define ------------------------------------------------------------*/
/* USER CODE BEGIN PD */

/* USER CODE END PD */

/* Private macro -------------------------------------------------------------*/
/* USER CODE BEGIN PM */

/* USER CODE END PM */

/* Private variables ---------------------------------------------------------*/
/* USER CODE BEGIN PV */

/* USER CODE END PV */

/* Private function prototypes -----------------------------------------------*/
/* USER CODE BEGIN PFP */

/* USER CODE END PFP */

/* Private user code ---------------------------------------------------------*/
/* USER CODE BEGIN 0 */

/* USER CODE END 0 */

/* External variables --------------------------------------------------------*/
extern DMA_HandleTypeDef hdma_adc1;
extern DMA_HandleTypeDef hdma_spi2_rx;
extern TIM_HandleTypeDef htim1;
extern DMA_HandleTypeDef hdma_usart2_rx;
/* USER CODE BEGIN EV */
extern unsigned int led_state;

extern unsigned int *adc_buffer;
extern unsigned char *hmi_buffer;

extern unsigned char *hmi_num_buffer;
extern unsigned int hmi_num_buffer_index;

extern unsigned int hmi_single_tone_freq;
extern unsigned int hmi_single_tone_phase_delay;
extern unsigned int hmi_single_tone_amp_attenuation;

extern unsigned int hmi_sweep_freq_start;
extern unsigned int hmi_sweep_freq_end;
extern unsigned int hmi_sweep_freq_step;

extern unsigned int hmi_page_n;
extern unsigned int hmi_page_2_box_n;

extern SPI_HandleTypeDef hspi1;
extern SPI_HandleTypeDef hspi2;
extern ADC_HandleTypeDef hadc1;
/* USER CODE END EV */

/******************************************************************************/
/*           Cortex-M4 Processor Interruption and Exception Handlers          */
/******************************************************************************/
/**
 * @brief This function handles Non maskable interrupt.
 */
void NMI_Handler(void)
{
  /* USER CODE BEGIN NonMaskableInt_IRQn 0 */

  /* USER CODE END NonMaskableInt_IRQn 0 */
  HAL_RCC_NMI_IRQHandler();
  /* USER CODE BEGIN NonMaskableInt_IRQn 1 */
  while (1)
  {
  }
  /* USER CODE END NonMaskableInt_IRQn 1 */
}

/**
 * @brief This function handles Hard fault interrupt.
 */
void HardFault_Handler(void)
{
  /* USER CODE BEGIN HardFault_IRQn 0 */

  /* USER CODE END HardFault_IRQn 0 */
  while (1)
  {
    /* USER CODE BEGIN W1_HardFault_IRQn 0 */
    /* USER CODE END W1_HardFault_IRQn 0 */
  }
}

/**
 * @brief This function handles Memory management fault.
 */
void MemManage_Handler(void)
{
  /* USER CODE BEGIN MemoryManagement_IRQn 0 */

  /* USER CODE END MemoryManagement_IRQn 0 */
  while (1)
  {
    /* USER CODE BEGIN W1_MemoryManagement_IRQn 0 */
    /* USER CODE END W1_MemoryManagement_IRQn 0 */
  }
}

/**
 * @brief This function handles Pre-fetch fault, memory access fault.
 */
void BusFault_Handler(void)
{
  /* USER CODE BEGIN BusFault_IRQn 0 */

  /* USER CODE END BusFault_IRQn 0 */
  while (1)
  {
    /* USER CODE BEGIN W1_BusFault_IRQn 0 */
    /* USER CODE END W1_BusFault_IRQn 0 */
  }
}

/**
 * @brief This function handles Undefined instruction or illegal state.
 */
void UsageFault_Handler(void)
{
  /* USER CODE BEGIN UsageFault_IRQn 0 */

  /* USER CODE END UsageFault_IRQn 0 */
  while (1)
  {
    /* USER CODE BEGIN W1_UsageFault_IRQn 0 */
    /* USER CODE END W1_UsageFault_IRQn 0 */
  }
}

/**
 * @brief This function handles System service call via SWI instruction.
 */
void SVC_Handler(void)
{
  /* USER CODE BEGIN SVCall_IRQn 0 */

  /* USER CODE END SVCall_IRQn 0 */
  /* USER CODE BEGIN SVCall_IRQn 1 */

  /* USER CODE END SVCall_IRQn 1 */
}

/**
 * @brief This function handles Debug monitor.
 */
void DebugMon_Handler(void)
{
  /* USER CODE BEGIN DebugMonitor_IRQn 0 */

  /* USER CODE END DebugMonitor_IRQn 0 */
  /* USER CODE BEGIN DebugMonitor_IRQn 1 */

  /* USER CODE END DebugMonitor_IRQn 1 */
}

/**
 * @brief This function handles Pendable request for system service.
 */
void PendSV_Handler(void)
{
  /* USER CODE BEGIN PendSV_IRQn 0 */

  /* USER CODE END PendSV_IRQn 0 */
  /* USER CODE BEGIN PendSV_IRQn 1 */

  /* USER CODE END PendSV_IRQn 1 */
}

/**
 * @brief This function handles System tick timer.
 */
void SysTick_Handler(void)
{
  /* USER CODE BEGIN SysTick_IRQn 0 */

  /* USER CODE END SysTick_IRQn 0 */
  HAL_IncTick();
  /* USER CODE BEGIN SysTick_IRQn 1 */

  /* USER CODE END SysTick_IRQn 1 */
}

/******************************************************************************/
/* STM32F4xx Peripheral Interrupt Handlers                                    */
/* Add here the Interrupt Handlers for the used peripherals.                  */
/* For the available peripheral interrupt handler names,                      */
/* please refer to the startup file (startup_stm32f4xx.s).                    */
/******************************************************************************/

/**
 * @brief This function handles DMA1 stream3 global interrupt.
 */
void DMA1_Stream3_IRQHandler(void)
{
  /* USER CODE BEGIN DMA1_Stream3_IRQn 0 */

  /* USER CODE END DMA1_Stream3_IRQn 0 */
  HAL_DMA_IRQHandler(&hdma_spi2_rx);
  /* USER CODE BEGIN DMA1_Stream3_IRQn 1 */

  /* USER CODE END DMA1_Stream3_IRQn 1 */
}

/**
 * @brief This function handles DMA1 stream5 global interrupt.
 */
void DMA1_Stream5_IRQHandler(void)
{
  /* USER CODE BEGIN DMA1_Stream5_IRQn 0 */

  /* USER CODE END DMA1_Stream5_IRQn 0 */
  HAL_DMA_IRQHandler(&hdma_usart2_rx);
  /* USER CODE BEGIN DMA1_Stream5_IRQn 1 */

  /* USER CODE END DMA1_Stream5_IRQn 1 */
}

/**
 * @brief This function handles TIM1 update interrupt and TIM10 global interrupt.
 */
void TIM1_UP_TIM10_IRQHandler(void)
{
  /* USER CODE BEGIN TIM1_UP_TIM10_IRQn 0 */

  HAL_GPIO_WritePin(LED_GPIO_Port, LED_Pin, led_state % 2);
  ++led_state;

  /* USER CODE END TIM1_UP_TIM10_IRQn 0 */
  HAL_TIM_IRQHandler(&htim1);
  /* USER CODE BEGIN TIM1_UP_TIM10_IRQn 1 */

  /* USER CODE END TIM1_UP_TIM10_IRQn 1 */
}

/**
 * @brief This function handles DMA2 stream0 global interrupt.
 */
void DMA2_Stream0_IRQHandler(void)
{
  /* USER CODE BEGIN DMA2_Stream0_IRQn 0 */

  /* USER CODE END DMA2_Stream0_IRQn 0 */
  HAL_DMA_IRQHandler(&hdma_adc1);
  /* USER CODE BEGIN DMA2_Stream0_IRQn 1 */

  /* USER CODE END DMA2_Stream0_IRQn 1 */
}

/* USER CODE BEGIN 1 */

void HAL_UART_RxCpltCallback(UART_HandleTypeDef *huart)
{
  char hmi_send_buf[HMI_SEND_BUF_SIZE] = {0};

  unsigned char spi_tx_buffer[6] = {0};
  unsigned char spi_rx_buffer[6] = {0};
  spi_tx_buffer[0] = 0x5a;

#ifdef DEBUG
  printf("[%.3f] STM32F4XX_IT: HMI Reviced: %02x %02x\r\n", 1.0f * getCurrentMicros() / 1000.0f, hmi_buffer[0], hmi_buffer[1]);
#endif

#ifdef DEBUG
  printf("[%.3f] STM32F4XX_IT: %d %d %d %d %d %d %d %d\r\n", 1.0f * getCurrentMicros() / 1000.0f,
         hmi_single_tone_freq, hmi_single_tone_phase_delay, hmi_single_tone_amp_attenuation,
         hmi_sweep_freq_start, hmi_sweep_freq_end, hmi_sweep_freq_step,
         hmi_page_n, hmi_page_2_box_n);
#endif

  if (hmi_buffer[0] == 0x01)
  {

#ifdef DEBUG
    printf("[%.3f] STM32F4XX_IT: HMI Reviced: Keyboard number.\r\n", 1.0f * getCurrentMicros() / 1000.0f);
#endif

    if (hmi_num_buffer_index < LENGTH_HMI_NUM_BUF - 1)
    {
      hmi_num_buffer[hmi_num_buffer_index] = '0' + hmi_buffer[1];
      ++hmi_num_buffer_index;
    }

#ifdef DEBUG
    printf("[%.3f] STM32F4XX_IT: hmi_num_buffer: %s\r\n", 1.0f * getCurrentMicros() / 1000.0f, hmi_num_buffer);
#endif

    if (hmi_page_n == 1)
    {
      memset(hmi_send_buf, 0x00, HMI_SEND_BUF_SIZE);
      sprintf(hmi_send_buf, "n0.val=%s\xff\xff\xff", hmi_num_buffer);
      HAL_UART_Transmit(huart, hmi_send_buf, strlen(hmi_send_buf), HAL_MAX_DELAY);
    }
    else if (hmi_page_n == 2)
    {
      memset(hmi_send_buf, 0x00, HMI_SEND_BUF_SIZE);
      sprintf(hmi_send_buf, "n%d.val=%s\xff\xff\xff", hmi_page_2_box_n, hmi_num_buffer);
      HAL_UART_Transmit(huart, hmi_send_buf, strlen(hmi_send_buf), HAL_MAX_DELAY);
    }
  }
  else if (hmi_buffer[0] == 0x02)
  {
#ifdef DEBUG
    printf("[%.3f] STM32F4XX_IT: HMI Reviced: Keyboard options.\r\n", 1.0f * getCurrentMicros() / 1000.0f);
#endif

    if (hmi_buffer[1] == 0x01)
    {
      if (hmi_num_buffer_index > 0)
      {
        --hmi_num_buffer_index;
        hmi_num_buffer[hmi_num_buffer_index] = 0x00;
      }

      if (hmi_page_n == 1)
      {
        memset(hmi_send_buf, 0x00, HMI_SEND_BUF_SIZE);
        sprintf(hmi_send_buf, "n0.val=%s\xff\xff\xff", hmi_num_buffer);
        HAL_UART_Transmit(huart, hmi_send_buf, strlen(hmi_send_buf), HAL_MAX_DELAY);
      }
      else if (hmi_page_n == 2)
      {
        memset(hmi_send_buf, 0x00, HMI_SEND_BUF_SIZE);
        sprintf(hmi_send_buf, "n%d.val=%s\xff\xff\xff", hmi_page_2_box_n, hmi_num_buffer);
        HAL_UART_Transmit(huart, hmi_send_buf, strlen(hmi_send_buf), HAL_MAX_DELAY);
      }
    }
    else if (hmi_buffer[1] == 0x02)
    {
      if (hmi_page_n == 1)
      {
        hmi_single_tone_freq = atoi(hmi_num_buffer) * 1000;

        unsigned int phase_fword = 1.0f * hmi_single_tone_freq * 0x100000000 / DDS_FREQ + 0.5f;
        spi_tx_buffer[1] = 0x00;
        memcpy(&(spi_tx_buffer[2]), &phase_fword, sizeof(unsigned int));
        HAL_SPI_TransmitReceive(&hspi1, spi_tx_buffer, spi_rx_buffer, 6, 100);

        int adc_ch1_value = 0;
        int adc_ch2_value = 0;

        HAL_ADC_Start(&hadc1);
        if (HAL_OK == HAL_ADC_PollForConversion(&hadc1, 100))
          adc_ch1_value = HAL_ADC_GetValue(&hadc1);

        memset(hmi_send_buf, 0x00, HMI_SEND_BUF_SIZE);
        sprintf(hmi_send_buf, "n1.val=%d\xff\xff\xff", adc_ch1_value);
        HAL_UART_Transmit(huart, hmi_send_buf, strlen(hmi_send_buf), HAL_MAX_DELAY);

        HAL_ADC_Start(&hadc1);
        if (HAL_OK == HAL_ADC_PollForConversion(&hadc1, 100))
          adc_ch2_value = HAL_ADC_GetValue(&hadc1);

        memset(hmi_send_buf, 0x00, HMI_SEND_BUF_SIZE);
        sprintf(hmi_send_buf, "n2.val=%d\xff\xff\xff", adc_ch1_value);
        HAL_UART_Transmit(huart, hmi_send_buf, strlen(hmi_send_buf), HAL_MAX_DELAY);
      }
      else if (hmi_page_n == 2)
      {
        if (hmi_page_2_box_n == 1)
        {
          hmi_sweep_freq_start = atoi(hmi_num_buffer) * 1000;
        }
        else if (hmi_page_2_box_n == 2)
        {
          hmi_sweep_freq_end = atoi(hmi_num_buffer) * 1000;
        }
        else if (hmi_page_2_box_n == 3)
        {
          hmi_sweep_freq_step = atoi(hmi_num_buffer) * 1000;
        }
      }

      memset(hmi_num_buffer, 0x00, LENGTH_HMI_NUM_BUF);
      hmi_num_buffer_index = 0;
    }
  }
  else if (hmi_buffer[0] == 0x03)
  {
#ifdef DEBUG
    printf("[%.3f] STM32F4XX_IT: HMI Reviced: Page jumping.\r\n", 1.0f * getCurrentMicros() / 1000.0f);
#endif

    hmi_page_n = hmi_buffer[1];

    memset(hmi_num_buffer, 0x00, LENGTH_HMI_NUM_BUF);
    hmi_num_buffer_index = 0;

    if (hmi_page_n == 2)
    {
      memset(hmi_send_buf, 0x00, HMI_SEND_BUF_SIZE);
      sprintf(hmi_send_buf, "n1.val=%d\xff\xff\xff", hmi_sweep_freq_start / 1000);
      HAL_UART_Transmit(huart, hmi_send_buf, strlen(hmi_send_buf), HAL_MAX_DELAY);

      memset(hmi_send_buf, 0x00, HMI_SEND_BUF_SIZE);
      sprintf(hmi_send_buf, "n2.val=%d\xff\xff\xff", hmi_sweep_freq_end / 1000);
      HAL_UART_Transmit(huart, hmi_send_buf, strlen(hmi_send_buf), HAL_MAX_DELAY);

      memset(hmi_send_buf, 0x00, HMI_SEND_BUF_SIZE);
      sprintf(hmi_send_buf, "n3.val=%d\xff\xff\xff", hmi_sweep_freq_step / 1000);
      HAL_UART_Transmit(huart, hmi_send_buf, strlen(hmi_send_buf), HAL_MAX_DELAY);
    }
    else if (hmi_page_n == 3)
    {

#ifdef DEBUG
      printf("[%.3f] STM32F4XX_IT: Start sweep frequency test.\r\n", 1.0f * getCurrentMicros() / 1000.0f);
#endif

      for (unsigned int i = hmi_sweep_freq_start; i < hmi_sweep_freq_end; i += hmi_sweep_freq_step)
      {
        unsigned int phase_fword = 1.0f * i * 0x100000000 / DDS_FREQ + 0.5f;
        spi_tx_buffer[1] = 0x00;
        memcpy(&(spi_tx_buffer[2]), &phase_fword, sizeof(unsigned int));
        HAL_SPI_TransmitReceive(&hspi1, spi_tx_buffer, spi_rx_buffer, 6, 100);

        // Get ADC value
        int adc_ch1_value = 0;
        int adc_ch2_value = 0;

        HAL_ADC_Start(&hadc1);
        if (HAL_OK == HAL_ADC_PollForConversion(&hadc1, 100))
          adc_ch1_value = HAL_ADC_GetValue(&hadc1);

        memset(hmi_send_buf, 0x00, HMI_SEND_BUF_SIZE);
        sprintf(hmi_send_buf, "add 2,0,%d\xff\xff\xff", adc_ch1_value / 200 + 192);
        HAL_UART_Transmit(huart, hmi_send_buf, strlen(hmi_send_buf), HAL_MAX_DELAY);

        HAL_ADC_Start(&hadc1);
        if (HAL_OK == HAL_ADC_PollForConversion(&hadc1, 100))
          adc_ch2_value = HAL_ADC_GetValue(&hadc1);

        memset(hmi_send_buf, 0x00, HMI_SEND_BUF_SIZE);
        sprintf(hmi_send_buf, "add 2,1,%d\xff\xff\xff", adc_ch2_value / 200 + 64);
        HAL_UART_Transmit(huart, hmi_send_buf, strlen(hmi_send_buf), HAL_MAX_DELAY);
      }
    }
  }
  else if (hmi_buffer[0] == 0x04)
  {
    hmi_page_2_box_n = hmi_buffer[1];

#ifdef DEBUG
    printf("[%.3f] STM32F4XX_IT: HMI Reviced: page 2 input select.\r\n", 1.0f * getCurrentMicros() / 1000.0f);
#endif

    memset(hmi_send_buf, 0x00, HMI_SEND_BUF_SIZE);
    sprintf(hmi_send_buf, "n1.val=%d\xff\xff\xff", hmi_sweep_freq_start / 1000);
    HAL_UART_Transmit(huart, hmi_send_buf, strlen(hmi_send_buf), HAL_MAX_DELAY);

    memset(hmi_send_buf, 0x00, HMI_SEND_BUF_SIZE);
    sprintf(hmi_send_buf, "n2.val=%d\xff\xff\xff", hmi_sweep_freq_end / 1000);
    HAL_UART_Transmit(huart, hmi_send_buf, strlen(hmi_send_buf), HAL_MAX_DELAY);

    memset(hmi_send_buf, 0x00, HMI_SEND_BUF_SIZE);
    sprintf(hmi_send_buf, "n3.val=%d\xff\xff\xff", hmi_sweep_freq_step / 1000);
    HAL_UART_Transmit(huart, hmi_send_buf, strlen(hmi_send_buf), HAL_MAX_DELAY);

    memset(hmi_num_buffer, 0x00, LENGTH_HMI_NUM_BUF);
    hmi_num_buffer_index = 0;
  }
  else
  {
#ifdef DEBUG
    printf("[%.3f] STM32F4XX_IT: HMI Reviced: Unknown option: %02x %02x\r\n", 1.0f * getCurrentMicros() / 1000.0f, hmi_buffer[0], hmi_buffer[1]);
#endif
  }
}

/* USER CODE END 1 */
