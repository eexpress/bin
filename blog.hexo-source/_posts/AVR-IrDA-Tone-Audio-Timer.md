title: AVR-IrDA-Tone-Audio-Timer
date: 2013-03-05 11:22
tags:
- avr
- tone
- audio
- IrDA
---
功能说明：
1。同时识别最多4个遥控器，2组编码固定在ROM，2组编码可随时录制到EEPROM。占用T0定时器。
2。全程独立按键提示音。不可识别按键，使用语音提示。全实时混合midi/wav输出。占用T1/T2定时器。
3。详细的串口输出调试信息，带ansi彩色输出。串口无输入功能。纯遥控器操作。
4。内部晶振。外部2引脚接IrDA/Mic，加电源/地共4引脚。除开wav数据，程序约3.4k。
5。没空余定时器了。复用T0，并累积IrDA中断的TCNT0，以校准时间。设置分：秒定时，每分钟和最后一分钟的每10秒，有不同提示音。完成后播放音乐。
6。目前内置4组midi音乐。可随时切换设置。
7。电池，MCU，遥控接收管，耳机插座（或无源蜂鸣器）4个元件。耳机音量也够了，只是语音的声音小了。外接了一个小音箱。
![](/img/irda1.jpg)
```
--IrDA--    00-FF-4A-B5
Found ROM Function Key '+'.
--------    BufCmd:     0A.
--IrDA--    00-FF-B8-47
Found ROM Digital Key 02.
--------    BufCmd:     0A-02.
--IrDA--    00-FF-B0-4F
Found ROM Digital Key 04.
--------    BufCmd:     0A-02-04.
--IrDA--    00-FF-E0-1F
Found ROM Function Key 'ok'.
Current Timer: 00:18.
--------    BufCmd:     .
Current Timer: 00:14.
Current Timer: 00:0A.
Current Timer: 00:00.
Timer OVER.
```
```
--------Start----------
eeircode --> {0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, },
eeircode --> {0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, },
eeindex  --> FF.
AVR-IrDA-Tone-Audio start.
version 1.4
--IrDA--    00-FD-58-A7
Found EEPROM Digital Key 01.
--IrDA--    00-FF-E8-17
Found ROM Digital Key 08.
--IrDA--    00-FF-FA-05
Found ROM Function Key 'ok'.
--------    BufCmd:     04-0A-08.
```
```
--IrDA--    00-FD-00-FF
New Device Key.
.E..E.--IrDA--  00-FD-10-EF
New Device Key.
--IrDA--    00-FD-08-F7
New Device Key.
--IrDA--    00-FD-30-CF
New Device Key.
--IrDA--    00-FD-00-FF
New Device Key.
.E.--IrDA-- 00-FD-00-FF
Repeat Key.
--IrDA--    00-FD-00-FF
Repeat Key.
.E.--IrDA-- 00-FD-00-FF
Repeat Key.
.E..E.--IrDA--  00-FD-00-FF
Repeat Key.
Recording...    Input Digital Key 00:
.E..E.00-FD-20-DF
        Input Digital Key 01:
00-FD-10-EF
        Input Digital Key 02:
00-FD-90-6F
        Input Digital Key 03:
00-FD-10-EF
        Input Digital Key 04:
00-FD-10-EF
        Input Digital Key 05:
00-FD-10-EF
        Input Digital Key 06:
00-FD-10-EF
        Input Digital Key 07:
00-FD-10-EF
        Input Digital Key 08:
00-FD-10-EF
        Input Digital Key 09:
00-FD-10-EF
        Input Function Key '+':
00-FD-10-EF
        Input Function Key '-':
00-FD-10-EF
        Input Function Key 'esc':
00-FD-10-EF
        Input Function Key 'ok':
00-FD-10-EF
Finish Record New Device.
eeircode --> {0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, },
eeircode --> {0x00, 0xFD, 0x20, 0x10, 0x90, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, },
eeindex  --> 02.
```
```
● make
avr-gcc -Wall -Wextra -mmcu=atmega8 -O1 -g -o a.out obj/*
avr-objdump -dS a.out >a.asm
avr-objcopy -j .text -j .data -O ihex a.out a.hex
avr-size a.out -C --mcu=atmega8
AVR Memory Usage
----------------
Device: atmega8
Program:    7066 bytes (86.3% Full)
(.text + .data + .bootloader)
.......
.......
● ll wav2c/ok_ray_cut.wav 
-rw-rw-r-- 1 eexp eexp 3.6K  3月  4 11:25 wav2c/ok_ray_cut.wav
```
