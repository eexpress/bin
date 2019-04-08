title: adb立刻刷新新push到手机的媒体
date: 2014-10-10 22:07:08
categories:
tags:
- adb
- android
---

adb立刻刷新新push到手机的媒体

``` bash
▶ adb shell am broadcast -a android.intent.action.MEDIA_MOUNTED -d file:///mnt/sdcard/DCIM
Broadcasting: Intent { act=android.intent.action.MEDIA_MOUNTED dat=file:///mnt/sdcard/DCIM }
Broadcast completed: result=0
```

