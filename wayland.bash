#!/bin/bash

env MUTTER_DEBUG_DUMMY_MODE_SPECS=1600x1000 WAYLAND_DISPLAY=wayland-test-0 dbus-run-session gnome-shell --nested --wayland-display=wayland-test-0
