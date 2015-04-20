title: adb查看手机型号
date: 2013-07-26 15:03
tags:
- adb 
---
```
● adb shell cat /system/build.prop | grep "product.model"
ro.product.model=HTC T528t
ro.product.model=HTC CP2DTG
```
