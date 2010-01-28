#!/usr/bin/perl

use utf8;
@info=`mocp -i`;
%hinfo=map{split /: /} @info;

print $hinfo{Title};
$_=$hinfo{State}; print,exit if ! /PLAY/;	#不是播放状态
$_=$hinfo{File}; s/(ogg|mp3)$/lrc/; chomp;
if(! -s){print "==无歌词文件==";exit 0;}	#无歌词文件
#print "==无歌词文件==",exit if ! -s; ????? why
#print "► ";
$_=`grep -m 1 \'$hinfo{CurrentTime}\' $_`;
if (! $_)		#无新歌词，不更新输出，打印记录的行
{
open (OUT, "/tmp/mocp-last-lrc");print <OUT>;close OUT;exit 0;
}
s/\xd//; s/\[.*\]//g;
print;
open (OUT, ">/tmp/mocp-last-lrc"); print OUT; close OUT;
