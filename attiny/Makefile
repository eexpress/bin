CC=avr-gcc
MCU=attiny13a
OUTPUT=wmonitor
CFLAGS=-Wall -Wextra -mmcu=$(MCU) -O1 -g -I./src
AVRDUDE=avrdude -p t13 -c usbasp
OBJCOPY=avr-objcopy -j .text -j .data -O ihex
OBJDUMP=avr-objdump
SIZE=avr-size
#------------------------------------------
all :
	$(CC) $(CFLAGS) $(OUTPUT).c -o $(OUTPUT).out
	$(OBJDUMP) -dS $(OUTPUT).out >$(OUTPUT).asm
	$(OBJCOPY) $(OUTPUT).out $(OUTPUT).hex
	$(SIZE) $(OUTPUT).out -C --mcu=$(MCU)
#------------------------------------------
fuse9.6M:
	$(AVRDUDE) -U lfuse:w:0x6a:m
fuse4.8M:
	$(AVRDUDE) -U lfuse:w:0x69:m
fuse128K:
	$(AVRDUDE) -U lfuse:w:0x6b:m
fuseOscExt:
	$(AVRDUDE) -U lfuse:w:0x68:m
#------------------------------------------
download:
	$(AVRDUDE) -e -U flash:w:$(OUTPUT).hex
#------------------------------------------
monitor:
	stty -F /dev/ttyUSB0 9600 cs8 -parenb -cstopb
	cat /dev/ttyUSB0
#------------------------------------------
