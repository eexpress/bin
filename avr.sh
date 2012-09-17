#!/bin/bash

avr-gcc -Wall -mmcu=atmega8 -g -O1 $1 -o $1.out 
echo ====$?====
[ $? != 0 ] && echo "compile error $?." && exit
avr-objdump -dS $1.out>$1.asm
avr-objcopy -j .text -j .data -O ihex $1.out $1.hex
avrdude -p m8 -c usbasp -e -U flash:w:$1.hex
#stty -F /dev/ttyUSB0 9600 cs8 -ignpar -cstopb #8N1
stty -F /dev/ttyUSB0 5:0:8bd:0:3:1c:7f:15:4:0:1:0:11:13:1a:0:12:f:17:16:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0
cat /dev/ttyUSB0
