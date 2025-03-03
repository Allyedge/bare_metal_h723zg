#include "hal.h"
#include <stdbool.h>

void SystemInit(void) {}

int main(void) {
  uint16_t led = PIN('B', 0);
  RCC->AHB4ENR |= BIT(PINBANK(led));
  gpio_set_mode(led, GPIO_MODE_OUTPUT);

  for (;;) {
    gpio_write(led, true);
    spin(1000000);
    gpio_write(led, false);
    spin(1000000);
  }

  return 0;
}

__attribute__((weak)) void ExitRun0Mode(void) {}
