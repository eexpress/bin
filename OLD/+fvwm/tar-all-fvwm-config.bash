#!/bin/bash

out="$HOME/.fvwm/x+gtk+fvwm.tar"
cd
rm $out
tar -chf $out \
		.Xresources .gtkrc-2.0 \
		.config/gtk-3.0/settings.ini \
		.fvwm/config .fvwm/desktop.svg \
		.fvwm/fvwm-config.png .fvwm/script/*
