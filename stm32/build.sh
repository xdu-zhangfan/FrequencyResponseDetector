make -j64
openocd \
-f interface/cmsis-dap.cfg \
-f target/stm32f4x.cfg \
-c "init" \
-c "transport select swd" \
-c "halt" \
-c "flash write_image erase build/FrequencyResponseDetector.elf" \
-c "reset" \
-c "shutdown"