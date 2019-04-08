title: "flash-down.pl "
date: 2010-05-30 11:05:48
tags:
---

● cat bin/flash-down.pl 
#!/usr/bin/perl -w

use utf8;
use strict;
use WWW::Mechanize;
use Net::DBus;

my $dir="$ENV{HOME}/flv-download";
-d $dir &amp;&amp; chdir $dir;

$_=$ARGV[0];
s/^http:\/([a-z0-9])/http:\/\/$1/;
chomp; s/\//%2F/g; s/:/%3A/g;
$_="http://www.flvcd.com/parse.php?flag=&amp;format=&amp;kw=$_&amp;sbt=%BF%AA%CA%BCGO%21";

my $bus = Net::DBus-&gt;session-&gt;get_service("org.freedesktop.Notifications")-&gt;get_object("/org/freedesktop/Notifications","org.freedesktop.Notifications");
my $mech = WWW::Mechanize-&gt;new();
$mech -&gt; get($_);
if ($mech-&gt;success()) {
	$_=$mech-&gt;content();
	if(/当前解析视频.*/){
	$_=$&amp;; s/^.*?strong&gt;//; s/&lt;strong.*//;
	print "\e[31m\e[1m".$_."\e[0m==================\n";
	s/ .*//; 
	mkdir "$_"; chdir "$_";
	my $name="$_";
	my @link=$mech-&gt;find_all_links(text_regex =&gt; qr/http:\/\/.*[0-9a-fA-F]*/,);
	my $size=@link;
	$bus-&gt;Notify("flash", 0, "sunny", "$name", "共获取 $size 个地址。", [], { }, -1);
	`xtermcontrol --title "flash-down.pl_下载_$name"`;
	print map "=&gt; \e[32m".$_-&gt;url()."\e[0m\n",@link;
	open(LINK,"&gt;link.log"); print LINK map $_-&gt;url()."\n",@link; close LINK;
	my $cnt=1; my $proc="▭"x$size;
	foreach(@link){
		my $add=$_-&gt;url();
		print "\e[31m下载\e[0m =&gt; \e[32m$add\e[0m\n";
		my $file=sprintf "%02d.flv",$cnt;
		`wget -c --user-agent="Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.3) Gecko/2008092416 Firefox/3.0.3" $add -O $file 2&gt;/dev/null`;
		$_=$?==0?"■":"□";$proc=~s/▭/$_/; 
#                $bus-&gt;Notify("flash", 0, ($?==0?"sunny":"error"), "$name", "已经完成下载 $cnt / $size ，wget返回：$? 。\n进度：$proc", [], { }, -1);
		print "\e[31m\e[1m$name 已经完成下载 $cnt / $size\e[0m ，wget返回：$? 。进度：\e[31m\e[1m$proc\e[0m\n";
		$cnt++;
	}
	chdir "..";
	`echo "$ARGV[0]\t《$_》 已经执行下载。结果：$proc"&gt;&gt;flash-down.log`;
	`aplay "/home/exp/媒体/事件声音-et/I-need-ammo.wav"`;
	} else {
	/提示：.*/; $_=$&amp;; s/&lt;br\/&gt;.*$//; 
	$bus-&gt;Notify("flash", 0, "error", "flash 解析失败", "$_\n:(", [], { }, -1);
	}
} else {
	$bus-&gt;Notify("flash", 0, "gtk-cancel", "网页无效", ":(", [], { }, -1);
}
#======================


● g flash ~/.opera/menu/exp.menu.ini 
Item, 使用flash-download.pl下载=Execute program,"xterm -e /home/exp/bin/flash-down.pl","%l"
Item, "解析flash地址"=New page &amp; Go to page, "http://www.flvcd.com/parse.php?format=high&amp;kw=%l"