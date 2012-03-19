#!/usr/bin/perl

@cmd=(
#'xmodmap /home/exp/.xmodmaprc',
#'gnome-settings-daemon',
#'conky',
#'trayer --edge bottom --ali gn left --widthtype request --heighttype request --SetDockType true --SetPartialStrut false --expand true',
'stalonetray --geometry +0-0 -t',
'nm-applet',
'fvwm-root -r ~/.fvwm/desktop.png',
'xmodmap -e "pointer = 3 2 1"',
'xcompmgr -C',
'cairo-weather.pl',
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
