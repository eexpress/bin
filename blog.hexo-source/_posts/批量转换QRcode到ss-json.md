title: "批量转换QRcode到ss.json"
date: 2015-07-04 23:27:25
tags:
- qrcode
- json
- shadowsocks
- zbar
---
脚本放在bin里面了。
```
▶ for i in *.png; do ./qrcode2ss.json.bash $i; done
```
如果密码使用：@会导致无法识别。这只是bash，不是perl。
其实可以做到摄像头扫描，生成json文件。
