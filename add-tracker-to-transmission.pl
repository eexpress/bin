#!/usr/bin/perl

use v5.10;
#~ use feature qw(say);
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
say "\n===============Transmission===============";
$~="LIST";
#~ print "____ID__Status________________Name____\n";
say "____ID__Status________________Name________";
#~ printf "____ID__Status%sName%s\n","_"x16,"_"x8;
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
@>>>>>  @<<<<<<<<<  @||||||||||||||||||||||||
$id, $statu, $name
.

say "==========================================";
say "select ID number to add external trackers.\nallow format: \e[1;32mall\e[0m / \e[1;32mactive\e[0m / \e[1;32m2,3,5-9\e[0m etc.\nINPUT: ";
$input=<STDIN>; chomp $input;
#~ ---------------------------------------------
say "=====================Add Trackers=====================";
open(INFO, $Tracker_File) or die("Could not open $Tracker_File.");
for (<INFO>){
	next if ! /\w/;
	chomp;
	system("transmission-remote -t $input -td $_ 1>/dev/null 2>&1");
	if($? eq 0){printf "%40s\t\e[32mOK\e[0m\n",$_;}
	else{printf "%40s\t\e[31mFail or Existed\e[0m\n",$_;};
	}
close INFO;
#~ ---------------------------------------------



