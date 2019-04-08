title: 利用图片名称，自动产生fvwm的button设置。
date: 2006-05-10 14:05:00
tags:
---

建立一个auto-button.bash。
#!/bin/bash

cd $fvwm/auto-png/
for j in S*.png
do
#图片名就是执行命令。去掉头部的S和尾部的.png后缀，以取得命令。
#echo -------------------------------
	i=${j#S}; i=${i%.png}
#---------------------------------
#如果有指定程序，就检查图片尺寸。
	if [ -e "/usr/bin/identify" ]; then
		s=`identify "$j"`; s=${s#*PNG\ }; s=${s:0:2};
	else
		s="47"
		#没有检测软件，就假定尺寸为47。
	fi
#---------------------------------
	if [ $s -gt 24 ]; then
#48x48的占用2x2的空间，而且需要附加的图片，以指定动态图标。
		s="2x2"
	else
#24x24的占用1x1的空间
		s="1x1";
	fi
	echo -n "*DockButtons: ($s,Icon \"$j\""
#---------------------------------
#如果存在D开头的，后更相同序号的图片，设置为动态图片。
	d=`echo $i|cut -d "|" -f1`
	[ -e "D${d}.png" ] &amp;&amp; echo -n ", ActiveIcon D${d}.png"
	[ -e "D${d}.PNG" ] &amp;&amp; echo -n ", ActiveIcon D${d}.PNG"
#分解命令。次序为左，右，上，下，4个鼠标操作。需要让awk不输入换行！！
	echo $i|awk -F"|" "$2!="" {print ", Action(Mouse 1) Exec "$2" \\"}"
	echo $i|awk -F"|" "$3!="" {print ", Action(Mouse 3) Exec "$3" \\"}"
	echo $i|awk -F"|" "$4!="" {print ", Action(Mouse 4) Exec "$4" \\"}"
	echo $i|awk -F"|" "$5!="" {print ", Action(Mouse 5) Exec "$5" \\"}"
	echo ")"
#---------------------------------
done


在指定目录里面使用这样的图片名字。S\d\d表示有效的图片，后面由|分割鼠标的4个动作，D\d\d的图片表示对应的序号的动态图片。
> D1.png
> S1|gnome-terminal.png
> S2|opera.png
> S3|gaim.png
> S4|gedit|sudo gedit.png
> S5|nautilus|rox.png
> S70|rhythmbox||amixer set PCM 10%+|amixer set PCM 10%-.png
> S71|alsamixergui.png
> S72|gnome-screenshot --delay=5|gnome-screen --window.png
> S76|gqview.png
> S78|totem.png
> S79|gimp.png

在button的配置文件中，相应位置，使用此行调用bash。
PipeRead `bash $[fvwm]/auto-png/auto-button.bash`

bash将图片文件名分解成命令，自动产生如下结果，插入配置文件的当前位置。相当于你自己在这里写一堆配置。
$ ./auto-button.bash
*DockButtons: (2x2,Icon "S1|gnome-terminal.png", ActiveIcon D1.png, Action(Mouse 1) Exec gnome-terminal \
)
*DockButtons: (2x2,Icon "S2|opera.png", Action(Mouse 1) Exec opera \
)
*DockButtons: (2x2,Icon "S3|gaim.png", Action(Mouse 1) Exec gaim \
)
*DockButtons: (2x2,Icon "S4|gedit|sudo gedit.png", Action(Mouse 1) Exec gedit \
, Action(Mouse 3) Exec sudo gedit \
)
*DockButtons: (2x2,Icon "S5|nautilus|rox.png", Action(Mouse 1) Exec nautilus \
, Action(Mouse 3) Exec rox \
)
*DockButtons: (2x2,Icon "S70|rhythmbox||amixer set PCM 10%+|amixer set PCM 10%-.png", Action(Mouse 1) Exec rhythmbox \
, Action(Mouse 4) Exec amixer set PCM 10%+ \
, Action(Mouse 5) Exec amixer set PCM 10%- \
)
*DockButtons: (2x2,Icon "S71|alsamixergui.png", Action(Mouse 1) Exec alsamixergui \
)
*DockButtons: (2x2,Icon "S72|gnome-screenshot --delay=5|gnome-screen --window.png", Action(Mouse 1) Exec gnome-screenshot --delay=5 \
, Action(Mouse 3) Exec gnome-screen --window \
)
*DockButtons: (2x2,Icon "S76|gqview.png", Action(Mouse 1) Exec gqview \
)
*DockButtons: (2x2,Icon "S78|totem.png", Action(Mouse 1) Exec totem \
)
*DockButtons: (2x2,Icon "S79|gimp.png", Action(Mouse 1) Exec gimp \
)


![](/img/screenshot-2006-07-10-02-05-46.png)