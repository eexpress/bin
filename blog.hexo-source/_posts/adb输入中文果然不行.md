---
title: adb输入中文果然不行
date: 2016-10-26 16:20:11
tags:
- adb
---
之前测试 **unified remote**，一直不能输入中文。今天反向测试下，找到 adb 输入的命令，果然发现只能输入英文。原因是input只是向android的虚拟键盘送键码。

```
▶ adb shell input text 'input'

▶ adb shell input --help
Error: Unknown command: --help
Usage: input [<source>] <command> [<arg>...]

The sources are: 
      mouse
      keyboard
      joystick
      touchnavigation
      touchpad
      trackball
      stylus
      dpad
      gesture
      touchscreen
      gamepad

The commands and default sources are:
      text <string> (Default: touchscreen)
      keyevent [--longpress] <key code number or name> ... (Default: keyboard)
      tap <x> <y> (Default: touchscreen)
      swipe <x1> <y1> <x2> <y2> [duration(ms)] (Default: touchscreen)
      press (Default: trackball)
      roll <dx> <dy> (Default: trackball)

```

居然有人为了接收中文，写了一个apk。 [ADBKeyBoard](https://github.com/senzhk/ADBKeyBoard)

这样可以看手机的输入法。我只安装了一个讯飞。

```
▶ adb shell ime list -a
com.iflytek.inputmethod/.FlyIME:
......
```

其实我只是想用讯飞的语音输入法，在电脑上。讯飞做了一个语音录入平台，还要自己搭建，写代码，nnnnnd。
