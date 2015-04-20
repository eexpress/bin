title: pgmspace总结
date: 2013-02-09 00:16
tags:
- avr-gcc 
---
```
const char MenuItem1[] PROGMEM = "Menu Item 1"; 
prog_char MenuItem2[] = "Menu Item 2"; 
prog_char MenuItem3[] = "Menu Item 3"; 
char* MenuItemPointers[] PROGMEM = {MenuItem1, MenuItem2, MenuItem3}; 
char *sp=(char*)pgm_read_word(&MenuItemPointers[1]);
void USART_TxString_P(const char *data)
{
    while (pgm_read_byte(data) != 0x00)
        USART_Tx(pgm_read_byte(data++));
}
USART_TxString_P(PSTR("FLASH STRING"));
USART_TxString_P(MenuItem1);
USART_TxString_P(sp);
```
也是经常容易忘记的。
