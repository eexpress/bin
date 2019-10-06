#!/bin/bash

font=yuanti.ttf
#font="@Vera Sans YuanTi Bold (TrueType)"
file="/home/eexpss/.local/share/fonts/园体.ttf"

cp $file ~/.wine/drive_c/windows/Fonts/$font
#perl -i.bakkkk -lane 'if(/MS\ Shell\ Dlg/){s/=".*"/="'$font'"/;};print;' ~/.wine/system.reg

#cat>>~/.wine/drive_c/windows/win.ini<<EOF
#[Desktop]
#menufontsize=13
#messagefontsize=13
#statusfontsize=13
#IconTitleSize=13
#EOF

cat>~/.wine/zh-font.reg<<EOF
REGEDIT4
[HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\FontLink\SystemLink]
"Lucida Sans Unicode"="$font"
"Microsoft Sans Serif"="$font"
"Microsoft YaHei"="$font"
"MS Sans Serif"="$font"
"Tahoma"="$font" 
"Tahoma Bold"="$font"
"SimSun"="$font"
"Arial"="$font"
"Arial Black"="$font"
"MS Shell Dlg"="$font"
"MS Shell Dlg 2"="$font"
EOF

wine regedit ~/.wine/zh-font.reg 
