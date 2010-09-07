#!/usr/bin/perl

use utf8;
@info=`mocp -i`;
%hinfo=map{split /: /} @info;

print $hinfo{Title};
$_=$hinfo{State}; print,exit if ! /PLAY/;	#不是播放状态
chomp %hinfo;

$_=$hinfo{File}; s/(ogg|mp3)$/lrc/;	# 同目录的lrc
if(! -s){
$_="$ENV{HOME}/.lyrics/$hinfo{Artist}/$hinfo{SongTitle}.lrc";
if(! -s){print "==无歌词文件==";exit 0;}
}

$_=`grep -m 1 \'$hinfo{CurrentTime}\' $_`;
if (! $_)		#无新歌词，不更新输出，打印记录的行
{
open (OUT, "/tmp/mocp-last-lrc");print <OUT>;close OUT;exit 0;
}
s/\xd//; s/\[.*\]//g;
print;
open (OUT, ">/tmp/mocp-last-lrc"); print OUT; close OUT;
