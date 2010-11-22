#!/usr/bin/perl -w

use utf8;
use strict;
use WWW::Mechanize;
use Net::DBus;

my $dir="$ENV{HOME}/下载/视频下载";
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
	if(/当前解析视频.*/){
	$_=$&; s/^.*?strong>//; s/<strong.*//; s/<font.*>//g;
	print "\e[31m\e[1m".$_."\e[0m==================\n";
#        s/ .*//; 
	mkdir "$_"; chdir "$_";
	my $name="$_";
	my @link=$mech->find_all_links(text_regex => qr/http:\/\/.*[0-9a-fA-F]*/,);
	my $size=@link;
	$bus->Notify("flash", 0, "sunny", "$name", "共获取 $size 个地址。", [], { }, -1);
#        `xtermcontrol --title "flash-down.pl_下载_$name"`;
	print "\e]2;flash-down.pl_下载_$name\a";
	print map "=> \e[32m".$_->url()."\e[0m\n",@link;
	open(LINK,">link.log"); print LINK map $_->url()."\n",@link; close LINK;
	my $cnt=1; my $proc="▭"x$size;
	foreach(@link){
		my $add=$_->url();
		print "\e[31m下载\e[0m => \e[32m$add\e[0m\n";
		my $file=sprintf "%02d.flv",$cnt;
#                `wget -c --tries=5 --user-agent='Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.3) Gecko/2008092416 Firefox/3.0.3' $add -O $file`;
		`wget -c --tries=5 --user-agent='Opera/9.80 (X11; Linux i686; U; en) Presto/2.6.30 Version/10.60' "$add" -O $file`;
#                `wget -c --user-agent='Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.3) Gecko/2008092416 Firefox/3.0.3' $add -O $file 2>/dev/null`;
		$_=$?==0?"■":"□";$proc=~s/▭/$_/; 
#                $bus->Notify("flash", 0, ($?==0?"sunny":"error"), "$name", "已经完成下载 $cnt / $size ，wget返回：$? 。\n进度：$proc", [], { }, -1);
		print "\e[31m\e[1m$name 已经完成下载 $cnt / $size\e[0m ，wget返回：$? 。进度：\e[31m\e[1m$proc\e[0m\n";
		print "\e]2;$name 下载进度 $proc\a";
		$cnt++;
	}
#---------------------	
	if($ENV{flv2avi}){
	`play "$ENV{HOME}/bin/resources/sound/skill_up.wav"`;
	$name=~s/ /-/g;
	print "\e]2;$name 使用mencoder压缩中。。。\a";
	$bus->Notify("flash", 0, "sunny", "flash 视频转换成 avi", "$dir/$name.avi", [], { }, -1);
	`/usr/bin/mencoder -profile c430 *.flv -o $dir/$name.avi 2>&1`;
	}
#---------------------	
	chdir '..';
	`echo "$ARGV[0]\t《$_》\t结果：$proc">>flash-down.log`;
	`play "$ENV{HOME}/bin/resources/sound/I-need-ammo.wav"`;
	} else {
	/提示：.*/; $_=$&; s/<br\/>.*$//; 
	$bus->Notify("flash", 0, "error", "flash 解析失败", "$_\n:(", [], { }, -1);
	}
} else {
	$bus->Notify("flash", 0, "gtk-cancel", '网页无效', ':(', [], { }, -1);
}
#======================
