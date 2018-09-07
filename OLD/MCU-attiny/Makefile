CC=avr-gcc
MCU=attiny13a
OUTPUT=$(shell grep -l -m 1  main *.c|sed 's/\.c//')
CFLAGS=-Wall -Wextra -mmcu=$(MCU) -O1 -g -I./src
AVRDUDE=avrdude -p t13 -c usbasp
OBJCOPY=avr-objcopy -j .text -j .data -O ihex
OBJDUMP=avr-objdump
SIZE=avr-size
#------------------------------------------
#make 缺省执行目标是 makefile 中的第一个目标
all :: compile download
#------------------------------------------
compile :
	@echo "=====> $(OUTPUT) <====="
	$(CC) $(CFLAGS) $(OUTPUT).c -o $(OUTPUT).out
	$(OBJDUMP) -dS $(OUTPUT).out >$(OUTPUT).asm
	$(OBJCOPY) $(OUTPUT).out $(OUTPUT).hex
	$(SIZE) $(OUTPUT).out -C --mcu=$(MCU)
#------------------------------------------
fuse9.6M:
	$(AVRDUDE) -U lfuse:w:0x6a:h
fuse4.8M:
	$(AVRDUDE) -U lfuse:w:0x69:h
fuse128K:
	$(AVRDUDE) -U lfuse:w:0x6b:h
fuseOscExt:
	$(AVRDUDE) -U lfuse:w:0x68:h
#------------------------------------------
readflash:
	$(AVRDUDE) -U flash:r:-:h
readeeprom:
	$(AVRDUDE) -U eeprom:r:-:h
readfuse:
	$(AVRDUDE) -U hfuse:r:-:h -U lfuse:r:-:h
readlock:
	$(AVRDUDE) -U lock:r:-:h
#    hex format output to stdout, normally is 0x3F
#------------------------------------------
download:
	$(AVRDUDE) -e -U flash:w:$(OUTPUT).out:e
#    $(AVRDUDE) -e -U flash:w:$(OUTPUT).hex
#------------------------------------------
monitor:
	stty -F /dev/ttyUSB0 9600 cs8 -parenb -cstopb
	cat /dev/ttyUSB0
#------------------------------------------
