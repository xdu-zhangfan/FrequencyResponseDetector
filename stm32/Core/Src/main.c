/* USER CODE BEGIN Header */
/**
 ******************************************************************************
 * @file           : main.c
 * @brief          : Main program body
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
#include "adc.h"
#include "dma.h"
#include "spi.h"
#include "tim.h"
#include "usart.h"
#include "gpio.h"

/* Private includes ----------------------------------------------------------*/
/* USER CODE BEGIN Includes */

/* USER CODE END Includes */

/* Private typedef -----------------------------------------------------------*/
/* USER CODE BEGIN PTD */

/* USER CODE END PTD */

/* Private define ------------------------------------------------------------*/
/* USER CODE BEGIN PD */

/* USER CODE END PD */

/* Private macro -------------------------------------------------------------*/
/* USER CODE BEGIN PM */

/* USER CODE END PM */

/* Private variables ---------------------------------------------------------*/

/* USER CODE BEGIN PV */
unsigned int led_state = 0;

unsigned int *adc_buffer = BASEADDR_ADC_RX_BUF;
unsigned char *hmi_buffer = BASEADDR_HMI_RX_BUF;
unsigned char *hmi_num_buffer = BASEADDR_HMI_NUM_BUF;
unsigned int hmi_num_buffer_index = 0;

unsigned int hmi_single_tone_freq = 0;
unsigned int hmi_single_tone_phase_delay = 0;
unsigned int hmi_single_tone_amp_attenuation = 0;

unsigned int hmi_sweep_freq_start = 100000;
unsigned int hmi_sweep_freq_end = 10000000;
unsigned int hmi_sweep_freq_step = 10000;

unsigned int hmi_page_n = 0;
unsigned int hmi_page_2_box_n = 0;
/* USER CODE END PV */

/* Private function prototypes -----------------------------------------------*/
void SystemClock_Config(void);
/* USER CODE BEGIN PFP */

/* USER CODE END PFP */

/* Private user code ---------------------------------------------------------*/
/* USER CODE BEGIN 0 */
int _write(int file, char *ptr, int len)
{
  HAL_UART_Transmit(&huart1, (const uint8_t *)ptr, len, HAL_MAX_DELAY);
  return len;
}

__STATIC_INLINE uint32_t GXT_SYSTICK_IsActiveCounterFlag(void)
{
  return ((SysTick->CTRL & SysTick_CTRL_COUNTFLAG_Msk) == (SysTick_CTRL_COUNTFLAG_Msk));
}

uint32_t getCurrentMicros(void)
{
  /* Ensure COUNTFLAG is reset by reading SysTick control and status register */
  GXT_SYSTICK_IsActiveCounterFlag();
  uint32_t m = HAL_GetTick();
  const uint32_t tms = SysTick->LOAD + 1;
  __IO uint32_t u = tms - SysTick->VAL;
  if (GXT_SYSTICK_IsActiveCounterFlag())
  {
    m = HAL_GetTick();
    u = tms - SysTick->VAL;
  }
  return (m * 1000 + (u * 1000) / tms);
}
/* USER CODE END 0 */

/**
  * @brief  The application entry point.
  * @retval int
  */
int main(void)
{
  /* USER CODE BEGIN 1 */

  /* USER CODE END 1 */

  /* MCU Configuration--------------------------------------------------------*/

  /* Reset of all peripherals, Initializes the Flash interface and the Systick. */
  HAL_Init();

  /* USER CODE BEGIN Init */

  /* USER CODE END Init */

  /* Configure the system clock */
  SystemClock_Config();

  /* USER CODE BEGIN SysInit */

  /* USER CODE END SysInit */

  /* Initialize all configured peripherals */
  MX_GPIO_Init();
  MX_DMA_Init();
  MX_ADC1_Init();
  MX_TIM1_Init();
  MX_TIM2_Init();
  MX_SPI1_Init();
  MX_SPI2_Init();
  MX_USART1_UART_Init();
  MX_USART2_UART_Init();
  /* USER CODE BEGIN 2 */

  char hmi_send_buf[HMI_SEND_BUF_SIZE] = {0};

  printf("Hello World.\r\n");

#ifdef DEBUG
  printf("[%.3f] MAIN: Initializing TIMs.\r\n", 1.0f * getCurrentMicros() / 1000.0f);
#endif

  HAL_TIM_Base_Start_IT(&htim1);
  HAL_TIM_Base_Start_IT(&htim2);

#ifdef DEBUG
  printf("[%.3f] MAIN: Initializing ADC.\r\n", 1.0f * getCurrentMicros() / 1000.0f);
#endif

  HAL_ADC_Start_DMA(&hadc1, adc_buffer, LENGTH_ADC_RX_BUF);

#ifdef DEBUG
  printf("[%.3f] MAIN: Initializing HMI.\r\n", 1.0f * getCurrentMicros() / 1000.0f);
#endif

  HAL_UART_Receive_DMA(&huart2, hmi_buffer, LENGTH_HMI_RX_BUF);

#ifdef DEBUG
  printf("[%.3f] MAIN: Initializing FPGA.\r\n", 1.0f * getCurrentMicros() / 1000.0f);
#endif

  unsigned int sine_freq = 10000000;

  unsigned int phase_fword = 1.0f * sine_freq * 0x100000000 / DDS_FREQ + 0.5f;
  unsigned int offset_pos_cal = 0;
  unsigned int offset_neg_cal = 0;

  unsigned char spi_tx_buffer[6] = {0};
  unsigned char spi_rx_buffer[6] = {0};
  spi_tx_buffer[0] = 0x5a;

#ifdef DEBUG
  printf("[%.3f] MAIN: \r\n", 1.0f * getCurrentMicros() / 1000.0f);
#endif

  memset(hmi_send_buf, 0x00, HMI_SEND_BUF_SIZE);
  sprintf(hmi_send_buf, "page 0\xff\xff\xff");
  HAL_UART_Transmit(&huart2, hmi_send_buf, strlen(hmi_send_buf), HAL_MAX_DELAY);

  /* USER CODE END 2 */

  /* Infinite loop */
  /* USER CODE BEGIN WHILE */
  while (1)
  {
    /* USER CODE END WHILE */

    /* USER CODE BEGIN 3 */
    // spi_tx_buffer[1] = 0x00;
    // memcpy(&(spi_tx_buffer[2]), &phase_fword, sizeof(unsigned int));
    // HAL_SPI_TransmitReceive(&hspi1, spi_tx_buffer, spi_rx_buffer, 6, 100);
    // printf("[%.3f] MAIN: %02x %02x %02x %02x %02x %02x\r\n", 1.0f * getCurrentMicros() / 1000.0f,
    //  spi_rx_buffer[0], spi_rx_buffer[1], spi_rx_buffer[2], spi_rx_buffer[3], spi_rx_buffer[4], spi_rx_buffer[5]);

    // HAL_Delay(10);

    // spi_tx_buffer[1] = 0x01;
    // memcpy(&(spi_tx_buffer[2]), &offset_pos_cal, sizeof(unsigned int));
    // HAL_SPI_TransmitReceive(&hspi1, spi_tx_buffer, spi_rx_buffer, 6, 100);
    // printf("[%.3f] MAIN: %02x %02x %02x %02x %02x %02x\r\n", 1.0f * getCurrentMicros() / 1000.0f,
    //  spi_rx_buffer[0], spi_rx_buffer[1], spi_rx_buffer[2], spi_rx_buffer[3], spi_rx_buffer[4], spi_rx_buffer[5]);

    // HAL_Delay(10);

    // spi_tx_buffer[1] = 0x02;
    // memcpy(&(spi_tx_buffer[2]), &offset_neg_cal, sizeof(unsigned int));
    // HAL_SPI_TransmitReceive(&hspi1, spi_tx_buffer, spi_rx_buffer, 6, 100);
    // printf("[%.3f] MAIN: %02x %02x %02x %02x %02x %02x\r\n", 1.0f * getCurrentMicros() / 1000.0f,
    //  spi_rx_buffer[0], spi_rx_buffer[1], spi_rx_buffer[2], spi_rx_buffer[3], spi_rx_buffer[4], spi_rx_buffer[5]);

    HAL_Delay(500);
  }
  /* USER CODE END 3 */
}

/**
  * @brief System Clock Configuration
  * @retval None
  */
void SystemClock_Config(void)
{
  RCC_OscInitTypeDef RCC_OscInitStruct = {0};
  RCC_ClkInitTypeDef RCC_ClkInitStruct = {0};

  /** Configure the main internal regulator output voltage
  */
  __HAL_RCC_PWR_CLK_ENABLE();
  __HAL_PWR_VOLTAGESCALING_CONFIG(PWR_REGULATOR_VOLTAGE_SCALE2);

  /** Initializes the RCC Oscillators according to the specified parameters
  * in the RCC_OscInitTypeDef structure.
  */
  RCC_OscInitStruct.OscillatorType = RCC_OSCILLATORTYPE_HSE;
  RCC_OscInitStruct.HSEState = RCC_HSE_ON;
  RCC_OscInitStruct.PLL.PLLState = RCC_PLL_ON;
  RCC_OscInitStruct.PLL.PLLSource = RCC_PLLSOURCE_HSE;
  RCC_OscInitStruct.PLL.PLLM = 25;
  RCC_OscInitStruct.PLL.PLLN = 168;
  RCC_OscInitStruct.PLL.PLLP = RCC_PLLP_DIV2;
  RCC_OscInitStruct.PLL.PLLQ = 4;
  if (HAL_RCC_OscConfig(&RCC_OscInitStruct) != HAL_OK)
  {
    Error_Handler();
  }

  /** Initializes the CPU, AHB and APB buses clocks
  */
  RCC_ClkInitStruct.ClockType = RCC_CLOCKTYPE_HCLK|RCC_CLOCKTYPE_SYSCLK
                              |RCC_CLOCKTYPE_PCLK1|RCC_CLOCKTYPE_PCLK2;
  RCC_ClkInitStruct.SYSCLKSource = RCC_SYSCLKSOURCE_PLLCLK;
  RCC_ClkInitStruct.AHBCLKDivider = RCC_SYSCLK_DIV1;
  RCC_ClkInitStruct.APB1CLKDivider = RCC_HCLK_DIV2;
  RCC_ClkInitStruct.APB2CLKDivider = RCC_HCLK_DIV1;

  if (HAL_RCC_ClockConfig(&RCC_ClkInitStruct, FLASH_LATENCY_2) != HAL_OK)
  {
    Error_Handler();
  }

  /** Enables the Clock Security System
  */
  HAL_RCC_EnableCSS();
}

/* USER CODE BEGIN 4 */

/* USER CODE END 4 */

/**
  * @brief  This function is executed in case of error occurrence.
  * @retval None
  */
void Error_Handler(void)
{
  /* USER CODE BEGIN Error_Handler_Debug */
  /* User can add his own implementation to report the HAL error return state */
  __disable_irq();
  while (1)
  {
  }
  /* USER CODE END Error_Handler_Debug */
}

#ifdef  USE_FULL_ASSERT
/**
  * @brief  Reports the name of the source file and the source line number
  *         where the assert_param error has occurred.
  * @param  file: pointer to the source file name
  * @param  line: assert_param error line source number
  * @retval None
  */
void assert_failed(uint8_t *file, uint32_t line)
{
  /* USER CODE BEGIN 6 */
  /* User can add his own implementation to report the file name and line number,
     ex: printf("Wrong parameters value: file %s on line %d\r\n", file, line) */
  /* USER CODE END 6 */
}
#endif /* USE_FULL_ASSERT */
