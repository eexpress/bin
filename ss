#!/bin/bash

sudo sslocal -c ~/bin/config/shadowsocks.json -d start

# ▶ pg sslocal
# 24957 /usr/bin/python3 /bin/sslocal -c ~/bin/config/shadowsocks.json -d start

gsettings set org.gnome.system.proxy autoconfig-url "file://$HOME/bin/config/.proxy.pac"
gsettings set org.gnome.system.proxy mode 'auto'
