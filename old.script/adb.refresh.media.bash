#!/bin/bash

adb shell am broadcast -a android.intent.action.MEDIA_MOUNTED -d file:///mnt/sdcard/DCIM
