#!/bin/bash

# wayland的软件，很多都开在桌面窗口的外面了。需要设置WAYLAND_DISPLA。
#~ env MUTTER_DEBUG_DUMMY_MODE_SPECS=1600x1000 WAYLAND_DISPLAY=wayland-test-0 dbus-run-session gnome-shell --nested --wayland-display=wayland-test-0

env MUTTER_DEBUG_DUMMY_MODE_SPECS=1400x900 dbus-run-session gnome-shell --nested

#~ dbus-run-session gnome-shell --nested
