#!/usr/bin/perl

$_=`last|grep reboot|cut -d" " -f 8-`;
s/Aug\ */08-/g;
s/Mon/周一/g;
s/Tue/周二/g;
s/Wed/周三/g;
s/Thu/周四/g;
s/Fri/周五/g;
s/Sat/周六/g;
s/Sun/周日/g;
print $_;
exit;

$log='/var/log/kern.log';
$re='proc\b';

open IN,$log.".1"; @_=grep /$re/,<IN>; close IN;
open IN,$log; @tmp=grep /$re/,<IN>; close IN;
push @_,@tmp;

print "从 $log 读取开关机记录：\n";
#---------------------------------------
$lastday="";
$t0=0; $t1=0;
for(@_){
	/(\w+\s+\w+)\s(\S+)/;
	$day=$1; $time=$2;
	if($day ne $lastday){
		$lastday=$day;
		$localday=`date -d "$day"`; $localday=~s/\s+\d\d\:.*//; chomp $localday;
		print "\n" if $t0>0;
		print "\n=====$localday=====\n";
	}
	$epoch=`date -d "$day $time" +%s`; chomp $epoch;
	if(/start/){print "$time -> "; $t0=$epoch if $t0==0;}
	else{print "$time."; $t1=$epoch;
		if($t0!=0){
			$t=$t1-$t0;
			$t=epoch2hms($t);
			print " 运行了 $t";
		}else{print "\n";}
		$t0=0; $t1=0;
	}
}
$t=time-$t0;
$t=epoch2hms($t);
print "now. 运行了 $t";

sub epoch2hms()
{
	$_=shift;
	$h=int($_/3600);
	$m=int(($_-3600*$h)/60);
	$s=int($_-3600*$h-60*$m);
#    ($h,$m,$s)=split /:/,`date -d "\@$_" +%H:%M:%S`;
#    $h-=7;
	return "$h:$m:$s\n";
}
