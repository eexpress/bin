title: Avr-libc 升级导致的代码兼容问题
date: 2014-06-01 13:39
tags:
- gcc
- avr
- avr-libc 
---
2年前的代码，突然不能编译了。显示
```
error: variable ‘alltone’ must be const in order to be put into read-only section by means of ‘__attribute__((progmem))’
error: unknown type name ‘prog_char’
error: wide character array initialized from non-wide string
```
大概这3类错误。
"-Wno-deprecated-declarations -D__PROG_TYPES_COMPAT__" 加入CFLAGS 只能去掉某些警告。
重要的是 prog_char 被废弃了。必须改成
```
const char va0[] PROGMEM ="B7";
```
最终自己定义
```
+#define prog_char PROGMEM const char
+#define prog_byte PROGMEM const unsigned char
+#define prog_int PROGMEM const int
```
