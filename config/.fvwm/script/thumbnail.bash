#!/bin/bash

# $[w.id] $[w.resource]
echo $*>>/tmp/id+resource
id=$1
name=${2%-server}
ficon="$HOME/.fvwm/icon/$name.png"
fthumb="/tmp/thumb.$id.png"
fout="/tmp/show.$id.png"

xwd -silent -id $id | convert -scale 100 xwd:- png:$fthumb

if [ ! -f "$ficon" ]; then
	floc=`locate -AweLi -n 1 48x48 $name.png`
	if [ -f "$floc" ]; then
		echo $floc>>/tmp/id+resource
		cp "$floc" $ficon
	else
		floc=`locate -AweLi -n 1 64x64 $name.png`
		if [ -f "$floc" ]; then
			echo $floc>>/tmp/id+resource
			convert -scale 48 $floc $ficon
		fi
	fi
fi

if [ -f "$ficon" ]; then
	composite -geometry +50+6 $ficon $fthumb $fout
else
	cp $fthumb $fout
fi

echo WindowStyle IconOverride, Icon $fout || echo Nop
