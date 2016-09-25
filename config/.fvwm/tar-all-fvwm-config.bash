#!/bin/bash

out="$HOME/.fvwm/x+gtk+fvwm.tar"
cd
rm $out
tar -cf $out \
		bin/config/.Xresources bin/config/.gtkrc-2.0 \
		bin/config/.config+gtk-3.0+settings.ini \
		.fvwm/config .fvwm/desktop.svg \
		.fvwm/fvwm-config.png .fvwm/script/* \
		bin/monitor-clip.pl \
		bin/config/ln-全部隐藏文件到家目录.bash

