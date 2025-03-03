ENTRY(Reset_Handler);

MEMORY {
  flash(rx)     : ORIGIN = 0x08000000, LENGTH = 1024k
  sram(rwx)     : ORIGIN = 0x24000000, LENGTH = 320k
  dtcmram(rwx)  : ORIGIN = 0x20000000, LENGTH = 128K
}

_estack     = ORIGIN(sram) + LENGTH(sram);

SECTIONS {
  .vectors  : { KEEP(*(.isr_vector)) }   > flash
  .text     : { *(.text*) }           > flash
  .rodata   : { *(.rodata*) }         > flash

  .data : {
    _sdata = .;
    *(.first_data)
    *(.data SORT(.data.*))
    _edata = .;
  } > sram AT > flash

  _sidata = LOADADDR(.data);

  .bss : {
    _sbss = .;
    *(.bss SORT(.bss.*) COMMON)
    _ebss = .;
  } > dtcmram

  . = ALIGN(8);

  _end = .;
}
