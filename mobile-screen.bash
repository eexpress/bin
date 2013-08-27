#!/bin/bash

adb shell screencap -p | perl -pe 's/\x0D\x0A/\x0A/g' > ~/android-screen-`date +%Y-%m-%d-%H-%M-%S`.png

