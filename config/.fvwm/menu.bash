#!/bin/bash

cd ~/.fvwm
#分目录的gnome菜单
#./fvwm-xdg-menu.py -f -m Root /etc/xdg/menus/applications.menu > menu
#快速，不分类目录的全部菜单，使用标准的应用程序目录。可以方便的剔出独立的常用软件菜单。
fvwm-menu-desktop --lang zh_CN --type fvwm --dir /usr/share/applications/ --name Root --enable-mini-icons --mini-icons-path /usr/share/icons/hicolor/24x24/apps/ > menu
