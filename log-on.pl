#!/usr/bin/perl

$log='/var/log/kern.log';
$re='proc\b';

open IN,$log; @_=grep /$re/,<IN>; close IN;

if(@_<3){
	$log.=".1";
	open IN,$log; @_=grep /$re/,<IN>; close IN;
}
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
	($h,$m,$s)=split /:/,`date -d "\@$_" +%H:%M:%S`;
	$h-=8;
	return "$h:$m:$s";
}
