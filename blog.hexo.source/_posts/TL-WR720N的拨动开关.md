title: "TL-WR720N的拨动开关"
date: 2015-05-12 15:11:56
tags:
- TL-WR720N
- GPIO
---
TL-WR720N带了3档位的拨动开关，sw1/sw2。GPIO概念混乱，找了半天，发现一个最简单读取开关状态的方法。
```
# cat /sys/kernel/debug/gpio
GPIOs 0-29, ath79:
 gpio-8   (USB power           ) out hi
 gpio-11  (reset               ) in  lo
 gpio-18  (sw1                 ) in  hi
 gpio-20  (sw2                 ) in  hi
 gpio-27  (tp-link:blue:system ) out lo
```
在 /etc/hotplug.d/button/button 居然有操作。应该附加上这样的判断就可以做事了。
```
if [ x"${BUTTON}" = x"BTN_0" ] || [ x"${BUTTON}" = x"BTN_1" ]; then
```
