#!/usr/bin/perl

use v5.10;
#~ use feature qw(say);
#~ ---------------------------------------------
sub center_align_title{	#输出定长的居中对齐的标题
	$len=60;	#定长
	$in=shift;
	$str="="x(int(($len-length($in))/2));
	say "$str$in$str";
}
#~ ---------------------------------------------
$Tracker_File="/tmp/trackers_best_ip.txt";
use File::stat;
my $stat = stat($Tracker_File);
if($stat){
	use Time::Piece;
	my $file_date = localtime($stat->mtime);
	$_ = $file_date->date;
	if ($file_date->date ne localtime->date) {
		say "Tracker_File has expired.";
		undef $stat;
		}else{
			say "Tracker_File is from today ($_).";
		}
	}
if(! $stat){
	say "Download Tracker_File....";
	system("curl -fs -o $Tracker_File --url https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_best_ip.txt") && die "Download Fail....";
	}
#~ ---------------------------------------------
center_align_title(" Transmission ");
$~="LIST";
printf "____ID__Status______%sName%s\n","_"x18,"_"x18;
for (`transmission-remote -l`){
	/ID|Sum:|Finished/ && next;	#跳过
	s/(^\s*|\s*$)//g;		#去头尾空白
	@l=split /\s+/;
	$n=@l;
	$id=$l[0]; $statu=$l[$n-2]; $name=$l[$n-1];
	write;
	#~ printf "%6s  %-10s  %18s",$id, $statu, $name;	#没有居中对齐
	}

format LIST =
@>>>>  @<<<<<<<<<<<  @||||||||||||||||||||||||||||||||||||
$id, $statu, $name
.

center_align_title("");
say "select ID number to add external trackers.\nallow format: \e[1;32mall\e[0m / \e[1;32mactive\e[0m / \e[1;32m2,3,5-9\e[0m etc.\nINPUT: ";
$input=<STDIN>; chomp $input;
#~ ---------------------------------------------
center_align_title(" Add Trackers ");
open(INFO, $Tracker_File) or die("Could not open $Tracker_File.");
for (<INFO>){
	next if ! /\w/;
	chomp;
	system("transmission-remote -t $input -td $_ 1>/dev/null 2>&1");
	if($? eq 0){printf "%40s\t\e[32mOK\e[0m\n",$_;}
	else{printf "%40s\t\e[31mExisted\e[0m\n",$_;};
	}
close INFO;
#~ ---------------------------------------------



