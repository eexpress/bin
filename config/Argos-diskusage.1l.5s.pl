#!/usr/bin/perl

$green="\e[1;32m"; $end="\e[0m"; $red="\e[1;31m"; $blue="\e[1;34m"; $lightblue="\e[1;2;36m";

sub bar{	# input: Total, Used
	$Total=shift; $Total=~s/G//;
	$Used=shift; $Used=~s/G//;
	$div=10; $div=5 if $Total < 100;
	$Total/=$div; $Used/=$div;
print "\t\t\t";
        print $red;
	for ($i=0; $i<$Total; $i++){
		print $green if $i > $Used;
		print "■";
	}
	print "$end|size=20\n";
}

print "▶  系统信息\n";
#loop 3 seconds
#print "▶  System Info\n"
print "---\n";

#if [ "$ARGOS_MENU_OPEN" == "true" ]; then
#print ":computer:  磁盘使用状况\n";

@info=`/usr/bin/df -h --output=source,fstype,size,used,pcent,target | sed '/tmpfs/d; /boot/d; s./dev/..;'`;

print $info;
foreach(@info){
	s/\n//;	print "$_ | iconName=drive-harddisk\n";
	@item=split "\ +";
	bar($item[2],$item[3]) if $item[2]=~/\d+G/ ;
}

print "------------------------\n";
#print -ne "最新接入的设备\t\t\e[38;5;6m "	#no support for 256 color?
print "最新接入的设备\t\t$lightblue";

$re=`dmesg|grep \'\\<Product:\'|tail -n 1`;
$re=~s/.*:\ //; $re=~s/\n//;
use Switch;
switch($re){
	case /Mouse/	{$DEV="input-mouse"}
	case /Webcam/	{$DEV="camera-web"}
	else 		{$DEV="computer"}
}
print "$re $end\| iconName=$DEV font='Blogger Sans Medium' size=12\n";

print "------------------------\n";
#print ":computer:  最高占用\n";

@info=`top -bn 1|head -n 11|tail -n 5`;
foreach(@info){
	$_="  $_";
	@item=split "\ +"; $item[12]=~s/\n//;
	print "$item[1]\t\t$item[9]\t$item[10]\t$item[12] | iconName=dialog-warning\n"; 
}

print "------------------------\n";
#print "网络信息\t\t\n";
@item=split "\ +",`ip route | grep -m 1 '0/24'`;
$item[8]=~s/\.(\d+)$/.$lightblue\1$end/;
print "网络设备名：$item[2]\t\t地址：$item[8] | iconName=network-wireless\n";

