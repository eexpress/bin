#!/bin/bash

adb shell mirscreencast -m /run/mir_socket -n1
adb pull /tmp/mir_screencast_1080x1920_60Hz.rgba /tmp/screenshot.rgba
convert -size 1080x1920 -alpha off -depth 8 /tmp/screenshot.rgba ~/screenshot-n5.png

