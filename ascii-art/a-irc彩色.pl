#!/usr/bin/perl

use Encode qw(_utf8_on _utf8_off);
use utf8;
use Getopt::Long;
GetOptions('forum'=>\$forum);

@c=qw(red blue green grey yellow bisque brown cyan gold khaki maroon lightcoral tomato orange navy seagreen firebrick);

$s='=';
srand();
if($ARGV[0]){
$_=join ' ',@ARGV;
}else{
$_=`xsel -o`;
}
_utf8_on($_);
s/[()]//g;
#s/(?=[\x80-\xff]+)/$s/g; s/(?=[\x00-\x7f，。]+)/$s/g;
#s/(?=[\x80-\xff]+)/$s/g; s/(?=[_A-Za-z0-9]+)/$s/g;
s/[_A-Za-z0-9]+/$s$&$s/g; s/(，|。|,|\.)/$&$s/g; s/$s\s*$s/$s/g; s/($s.)$s/$1/g; s/^=//; s/=$//;
print "$_\n";
@_=split /$s/,$_;
#@_=/.{0,2}/g;
foreach(@_){
$r=int rand(15);
#print "\.$_";
#_utf8_off($_);
if($forum){
#-----forum color-----
	$out.="\[color=$c[$r]\]$_\[/color\]";
}else{
#-----irc color-----
	if($r==0){$out.=sprintf "\x030,1$_\x0f";
	}elsif($r==1){$out.=sprintf "\x031,0$_\x0f";
	}else{$out.=sprintf "\x03$r$_";
	}
}
#2种花字
#$out.=int rand(2)?"\xd2\x89":"\xd2\x88";
}
#ctrl序列可以用xev看，粗体^B
if($forum){$out="\[b\]$out\[/b\]";}else{$out="\x02$out";}
#英文倒字
#use utf8;
#$out=~y/a-z/ɐqɔpǝɟƃɥᴉḷʞȷɯuodbɹsʇnʌʍxʎz/;
print "$out\n";
`echo $out|xsel -i`;
