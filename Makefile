# CFLAGS  ?=  -W -Wall -Wextra -Werror -Wundef -Wshadow -Wdouble-promotion \
#             -Wformat-truncation -fno-common -Wconversion \

CFLAGS ?= -g3 -Os -ffunction-sections -fdata-sections \
          -I. -Iinclude -Icmsis_core/CMSIS/Core/Include -Icmsis_h7/Include  \
          -mcpu=cortex-m7 -mthumb -mfloat-abi=hard $(EXTRA_CFLAGS)
LDFLAGS ?= -Tlink.ld -nostartfiles -nostdlib --specs nano.specs -lc -lgcc -Wl,--gc-sections -Wl,-Map=$@.map
SOURCES = main.c syscalls.c
SOURCES += cmsis_h7/Source/Templates/gcc/startup_stm32h723xx.s

ifeq ($(OS),Windows_NT)
  RM = cmd /C del /Q /F
else
  RM = rm -f
endif

build: firmware.bin

firmware.elf: cmsis_core cmsis_h7 hal.h link.ld Makefile $(SOURCES)
	arm-none-eabi-gcc $(SOURCES) $(CFLAGS) $(LDFLAGS) -o $@

firmware.bin: firmware.elf
	arm-none-eabi-objcopy -O binary $< $@

flash: firmware.bin
	st-flash --reset write $< 0x8000000

cmsis_core:
	git clone --depth 1 -b 5.9.0 https://github.com/ARM-software/CMSIS_5 $@

cmsis_h7:
	git clone --depth 1 -b v1.10.6 https://github.com/STMicroelectronics/cmsis_device_h7 $@

clean:
	$(RM) firmware.* cmsis_*
