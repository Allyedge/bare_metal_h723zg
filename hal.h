#pragma once

#include "stm32h723xx.h"

#include <stdbool.h>

#define BIT(x) (1UL << (x))
#define PIN(bank, num) ((((bank) - 'A') << 8) | (num))
#define PINNO(pin) (pin & 255)
#define PINBANK(pin) (pin >> 8)

static inline void spin(volatile uint32_t count) {
  for (volatile int i = 0; i < count; i++)
    ;
}

#define GPIO(bank) ((GPIO_TypeDef *)(GPIOA_BASE + 0x400U * (bank)))
enum { GPIO_MODE_INPUT, GPIO_MODE_OUTPUT, GPIO_MODE_AF, GPIO_MODE_ANALOG };

static inline void gpio_set_mode(uint16_t pin, uint8_t mode) {
  GPIO_TypeDef *gpio = GPIO(PINBANK(pin));
  int n = PINNO(pin);
  RCC->AHB1ENR |= BIT(PINBANK(pin));
  gpio->MODER &= ~(3U << (n * 2));
  gpio->MODER |= (mode & 3U) << (n * 2);
}

static inline void gpio_write(uint16_t pin, bool val) {
  GPIO_TypeDef *gpio = GPIO(PINBANK(pin));
  gpio->BSRR = (1U << PINNO(pin)) << (val ? 0 : 16);
}
