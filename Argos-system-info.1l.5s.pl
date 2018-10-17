#!/usr/bin/perl

$green="\e[1;32m"; $end="\e[0m"; $red="\e[1;31m"; $blue="\e[1;34m"; $lightblue="\e[1;2;36m";

sub bar{	# input: Total, Used
	$Total=shift; $Total=~s/G//;
	$Used=shift; $Used=~s/G//;
	$div=10; $div=5 if $Total < 100;
	$Total/=$div; $Used/=$div;
print "\t\t\t" if ! $tty;
        print $red;
	for ($i=0; $i<$Total; $i++){
		print $green if $i > $Used;
		print "■";
	}
	print "$end".($tty?"":"|size=20")."\n";
}

$tty=true, $format="" if (-t STDOUT);

print "▶  系统信息\n";
#loop 3 seconds
#print "▶  System Info\n"
print "---\n";

#if [ "$ARGOS_MENU_OPEN" == "true" ]; then
#print ":computer:  磁盘使用状况\n";

#@info=`/usr/bin/df -h --output=source,fstype,size,used,pcent,target | sed '/tmpfs/d; /boot/d; s./dev/..;'`;
@info=`/usr/bin/df -h -t ext4|sed "s./dev/..; s.     容量.容量."`;

$format="| iconName=drive-harddisk" if ! $tty;
print $info;
foreach(@info){
	s/\n//;	print "$_$format\n";
	@item=split /\ +/;
	bar($item[1],$item[2]) if $item[1]=~/\d+G/ ;
}

print "------------------------\n";
#print -ne "最新接入的设备\t\t\e[38;5;6m "	#no support for 256 color?
print "最新接入的设备\t\t$lightblue";
$format="\| iconName=$DEV font='Blogger Sans Medium'" if ! $tty;
$re=`dmesg|grep \'\\<Product:\'|tail -n 1`;
$re=~s/.*:\ //; $re=~s/\n//;
use Switch;
switch($re){
	case /Mouse/	{$DEV="input-mouse"}
	case /Webcam/	{$DEV="camera-web"}
	else 		{$DEV="computer"}
}
print "$re $end$format\n";

print "------------------------\n";
#print ":computer:  最高占用\n";

$format="\| iconName=dialog-warning" if ! $tty;
@info=`top -bn 1|head`; 	# head only for short array
foreach(@info[6..9]){
#        $_="  $_";	# avoid for long pid: ^22035
#        @item=split "\ +"; $item[12]=~s/\n//;
($pid,undef,undef,undef,undef,undef,undef,undef,$cpu,$mem,undef,$command)=split;
#($pid,$user,$pr,$ni,$virt,$res,$shr,$s,$cpu,$mem,$time,$command)=split;
#        ($pid,,,,,,,,$cpu,$mem,,$command)=split;
	print "$pid\t\t$cpu\t$mem\t$command$format\n"; 
#        print "$item[1]\t\t$item[9]\t$item[10]\t$item[12] | iconName=dialog-warning\n"; 
}
#▶ top -bn 1|perl -ne 'print if /TIME+/ .. /kthreadd/' # range operator

print "------------------------\n";
$format="\| iconName=network-wireless" if ! $tty;
#print "网络信息\t\t\n";
@item=split /\ +/, (grep m'0/24', `ip route`)[0];
#@item=split "\ +",`ip route | grep -m 1 '0/24'`;
#$item[8]=~s/\.(\d+)$/.$lightblue\1$end/;
#print "网络设备名：$item[2]\t\t地址：$item[8]$format\n";
@ip=split /\./, $item[8];
print "网络设备名：$item[2]\t\t地址：$ip[0].$ip[1].$green$ip[2].$lightblue$ip[3]$end$format\n";


