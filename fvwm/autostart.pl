#!/usr/bin/perl

@cmd=(
#'habak ~/.fvwm/desktop.jpg',
#'xmodmap /home/exp/.xmodmaprc',
#'gnome-settings-daemon',
#'conky',
#'trayer --edge bottom --align left --widthtype request --heighttype request --SetDockType true --SetPartialStrut false --expand true',
'stalonetray',
'fcitx',
#'scim',
#'nm-applet',
#'~/bin/habak-w.pl',
#'~/bin/xterm',
#'~/应用/脚本/random-pic-desktop.pl -o',
#'~/应用/swap-mouse/swap-mouse.pl',
#'~/bin/cairo2png.pl -d',
#'cdn.proxy',
#'cdnproxy-论坛',
#'wbar -zoomf 2.5 -falfa 60',
);

foreach $i (@cmd){
$_=$i;
s/ .*$//;
#print; pidof can not find scim.
$r=$_;$r=~s/.*\///g;
$r=`pgrep $r`;
chomp $r;
if($r==""){
	print "===> $_\n";
	system("bash -c \'$i\' &");
	}
}
