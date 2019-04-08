title: 最简单的EEPROM操作
date: 2013-02-08 23:37
tags:
- avr-gcc 
---
```
 uint8_t  EEMEM NonVolatileChar=12; 
 uint16_t EEMEM NonVolatileInt; 
 uint8_t  EEMEM NonVolatileString[10]; 
 int main(void) 
 { 
     uint8_t  SRAMchar; 
     uint16_t SRAMint; 
     uint8_t  SRAMstring[10];    
     SRAMchar = eeprom_read_byte(&NonVolatileChar); 
     SRAMint  = eeprom_read_word(&NonVolatileInt); 
     eeprom_read_block((void*)&SRAMstring, (const void*)&NonVolatileString, 10); 
 }
```
内存一样的操作。高级的EEMEM。
