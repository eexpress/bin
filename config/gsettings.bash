#!/bin/bash

gsettings set org.gnome.desktop.wm.preferences action-middle-click-titlebar 'lower'
gsettings set org.gnome.desktop.wm.preferences action-right-click-titlebar 'minimize'

gsettings set org.gnome.desktop.interface show-battery-percentage true
gsettings set org.gnome.desktop.interface clock-show-date true

gsettings set org.gnome.desktop.interface cursor-theme 'Qetzal'

gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true
gsettings set org.gnome.desktop.peripherals.touchpad two-finger-scrolling-enabled true

gsettings set org.gnome.desktop.interface monospace-font-name 'Fira Mono 12'
gsettings set org.gnome.desktop.interface font-name 'Fira Mono 12'
gsettings set org.gnome.desktop.interface document-font-name 'Fira Mono 12'
