#!/usr/bin/perl -w

use utf8;
use strict;
use WWW::Mechanize;
use Net::DBus;
binmode STDOUT, ':utf8';

my $black="\e[30m";my $red="\e[31m";my $green="\e[32m";
my $yellow="\e[33m";my $blue="\e[34m";my $pink="\e[35m";
my $cyan="\e[36m";my $white="\e[37m";my $normal="\e[0m";
my $bold="\e[1m";my $reverse="\e[7m";

my $dir="$ENV{HOME}/视频/";
-d $dir && chdir $dir;

$_=$ARGV[0];
s/^http:\/([a-z0-9])/http:\/\/$1/;
chomp; s/\//%2F/g; s/:/%3A/g;
$_="http://www.flvcd.com/parse.php?flag=&format=high&kw=$_&sbt=%BF%AA%CA%BCGO%21";

my $bus = Net::DBus->session->get_service('org.freedesktop.Notifications')->get_object('/org/freedesktop/Notifications','org.freedesktop.Notifications');
my $mech = WWW::Mechanize->new(agent=>'Opera/9.80 (X11; Linux i686; U; en) Presto/2.6.30 Version/10.60');
#my $mech = WWW::Mechanize->new();
$mech -> get($_);
if ($mech->success()) {
	$_=$mech->content();
	if(/当前解析视频.*?<font/s){
	$_=$&; 
	s/^.*?>//;s/<.*$//s;s/\s*//g;
	print "$red$bold".$_."$normal==================\n";
	mkdir "$_"; chdir "$_";
	my $name="$_";
	my @link=$mech->find_all_links(text_regex => qr/http:\/\/.*[0-9a-fA-F]*/,);
	my $size=@link;
	$bus->Notify("flash", 0, "sunny", "$name", "共获取 $size 个地址。", [], { }, -1);
	print "\e]2;flash-down.pl_下载_$name\a";
	print map "=> $green".$_->url()."$normal\n",@link;
	open(LINK,">link.log"); print LINK map $_->url()."\n",@link; close LINK;
	my $cnt=1; my $proc="▭"x$size;
	foreach(@link){
		my $add=$_->url();
		print "$red 下载$normal => $green$add$normal\n";
		my $file=sprintf "%02d.flv",$cnt;
#                `wget -c --tries=5 --user-agent='Opera/9.80 (X11; Linux i686; U; en) Presto/2.6.30 Version/10.60' "$add" -O $file`;
		$mech->get($add);
		$mech->save_content($file);
		$_=$mech->success()?"■":"□";$proc=~s/▭/$_/;
#                $_=$?==0?"■":"□";$proc=~s/▭/$_/; 
		$bus->Notify("flash", 0, ($?==0?"sunny":"error"), "$name", "已经完成下载 $cnt / $size ，返回：$? 。\n进度：$proc", [], { }, -1);
		print "$red$bold$name 已经完成下载 $cnt / $size$normal ，返回：$? 。进度：$red$bold$proc$normal\n";
		print "\e]2;$name $proc\a";
		$cnt++;
	}
#---------------------	
	if($ENV{flv2avi}){
	`paplay "/usr/share/sounds/ubuntu/stereo/service-login.ogg"`;
	$name=~s/ /-/g;
	print "\e]2;$name 使用mencoder压缩中。。。\a";
	$bus->Notify("flash", 0, "sunny", "flash 视频转换成 avi", "$dir/$name.avi", [], { }, -1);
	`/usr/bin/mencoder -profile c430 *.flv -o $dir/$name.avi 2>&1`;
	}
#---------------------	
	$bus->Notify("flash", 0, "sunny", "$name 已经完成下载", "$dir/$name.avi", [], { }, -1);
	chdir '..';
	`echo "$ARGV[0]\t《$_》\t结果：$proc">>flash-down.log`;
	`paplay "/usr/share/sounds/ubuntu/stereo/service-login.ogg"`;
	} else {
	/提示：.*/; $_=$&; s/<br\/>.*$//; 
	$bus->Notify("flash", 0, "error", "flash 解析失败", "$_\n:(", [], { }, -1);
	}
} else {
	$bus->Notify("flash", 0, "gtk-cancel", '网页无效', ':(', [], { }, -1);
}
#======================
