#!/usr/bin/perl -w

use utf8;
use strict;
use WWW::Mechanize;
use Net::DBus;

$_=$ARGV[0];
s/^http:\/([a-z0-9])/http:\/\/$1/;
chomp; s/\//%2F/g; s/:/%3A/g;
$_="http://www.flvcd.com/parse.php?flag=&format=&kw=$_&sbt=%BF%AA%CA%BCGO%21";

my $bus = Net::DBus->session->get_service('org.freedesktop.Notifications')->get_object('/org/freedesktop/Notifications','org.freedesktop.Notifications');
my $mech = WWW::Mechanize->new();
$mech -> get($_);
if ($mech->success()) {
	$_=$mech->content();
	if(/当前解析视频.*/){
	$_=$&; s/^.*?strong>//; s/<strong.*//;
	print "\e[31m\e[1m".$_."\e[0m==================\n";
	s/ .*//; 
	mkdir $_; chdir	$_;
	my $name=$_;
	my @link=$mech->find_all_links(text_regex => qr/http:\/\/.*[0-9a-fA-F]*/,);
	my $size=@link;
	$bus->Notify("flash", 0, "sunny", "$name", "共获取 $size 个地址。", [], { }, -1);
	print map "=> \e[32m".$_->url()."\e[0m\n",@link;
	open(LINK,">link.log"); print LINK map $_->url()."\n",@link; close LINK;
	my $cnt=1; my $proc="▭"x$size;
	foreach(@link){
		my $add=$_->url();
		print "\e[31m下载\e[0m => \e[32m$add\e[0m\n";
		`wget -nc --user-agent='Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.3) Gecko/2008092416 Firefox/3.0.3' $add -O $cnt.mp4`;
		$_=$?==0?"■":"□";$proc=~s/▭/$_/; 
		$bus->Notify("flash", 0, ($?==0?"sunny":"error"), "$name", "已经完成下载 $cnt / $size ，wget返回：$? 。\n进度：$proc", [], { }, -1);
		print "\e[31m\e[1m已经完成下载 $cnt / $size\e[0m ，wget返回：$? 。进度：\e[31m\e[1m$proc\e[0m\n";
		$cnt++;
	}
	`echo "$ARGV[0]\t《$_》 已经执行下载。结果：$proc">>$ENV{HOME}/flash-down.log`;
	chdir '..';
	`aplay '/home/exp/媒体/事件声音-et/I-need-ammo.wav'`;
	} else {
	/提示：.*/; $_=$&; s/<br\/>.*$//; 
	$bus->Notify("flash", 0, "error", "flash 解析失败", "$_\n:(", [], { }, -1);
	}
} else {
	$bus->Notify("flash", 0, "gtk-cancel", '网页无效', ':(', [], { }, -1);
}
#======================
