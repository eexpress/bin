title: "魅蓝的adb真是折腾"
date: 2015-05-09 23:11:54
tags:
- MeiZu
- adb
---
先在“设置-账号-登录-个人中心-系统权限”里面，开启root。
密码不记得，没绑定手机号码。去flyme.cn，找密码，随便用一个邮箱验证，就重置密码了。搞笑嘛。
“设置-辅助功能-开发者选项”，打开“USB调试”。好顺利？结果adb devices啥都不出来。
“设置-关于手机-存储-连接方式-内置光盘”，居然做U盘搞，内置驱动，看文章了，'/media/eexp/iAmCdRom/M1 Note USB Reference Manual/简体/M1 Note_ADB_参考说明书.txt' 里面写着步骤。明显就是破手机使用的pid-vid没在udev列表里面，设备id没在adb列表里面，当然都不认。
都做好了吧。adb shell也正常了吧。
```
▶ adb root
adbd cannot run as root in production builds
```
草。这是玩那样，你开的root是干嘛的。我只是要设置下net.hostname啊。

