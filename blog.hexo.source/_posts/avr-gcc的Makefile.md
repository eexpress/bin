title: avr-gcc的Makefile
date: 2013-02-27 21:24
tags:
- avr-gcc
- Makefile 
---
```
● cat Makefile 
CC=avr-gcc
MCU=atmega8
OUTPUT=a
CFLAGS=-Wall -Wextra -mmcu=$(MCU) -O1 -g
AVRDUDE=avrdude -p m8 -c usbasp
OBJCOPY=avr-objcopy -j .text -j .data -O ihex
OBJDUMP=avr-objdump
SIZE=avr-size
allsrc := $(wildcard src/*.c)
allobj := $(patsubst src/%.c, obj/%.o,$(allsrc))
compile :: $(allobj) link
all :: compile download monitor
obj/%.o :: src/%.c
    $(CC) $(CFLAGS) -c $< -o $@
link:
    $(CC) $(CFLAGS) -o $(OUTPUT).out obj/*
    $(OBJDUMP) -dS $(OUTPUT).out >$(OUTPUT).asm
    $(OBJCOPY) $(OUTPUT).out $(OUTPUT).hex
    $(SIZE) $(OUTPUT).out -C --mcu=$(MCU)
fuse8M:
    $(AVRDUDE) -U lfuse:w:0xe4:m
download:
    $(AVRDUDE) -e -U flash:w:$(OUTPUT).hex
monitor:
    stty -F /dev/ttyUSB0 9600 cs8 -parenb -cstopb
    cat /dev/ttyUSB0
```
