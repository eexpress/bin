#!/bin/bash

youtube-dl --proxy socks5://localhost:1080 -q -o - $1 | mplayer -cache 8192 -
