#!/bin/bash

[ -z "$1" ] && url=`xclip -o` || url=$1
youtube-dl --proxy socks5://localhost:1080 -q -o - $url | mplayer -cache 8192 -
