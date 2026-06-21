#!/bin/bash

ROOT="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/"
E0="${ROOT}custom0/";E1="${ROOT}custom1/"
cat <<EOF | dconf load "$ROOT"
[custom0]
name='测试1'
command='notify-send 1'
binding='<Control>F10'
[custom1]
name='测试2'
command='notify-send 2'
binding='<Control>F11'
EOF
# 数组填入两条完整实例路径
dconf write "${ROOT%/}" "['$E0','$E1']"
