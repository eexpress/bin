#!/bin/bash

notify-send "$(date '+%Y-%m-%d %p %l:%M:%S')" "$(free -h|cut -b -43|sed 's/\ /./g')" -i clock -h string:x-canonical-private-synchronous:date
