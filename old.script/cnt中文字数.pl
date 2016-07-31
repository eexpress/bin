#!/usr/bin/perl

use utf8;
use Encode qw(_utf8_on);
#消除输出的"Wide character in print at ...."
binmode(STDOUT, ':encoding(utf8)');
#去掉空格和回车等。
open IN,"<$ARGV[0]"; while(<IN>){
s/\s//g;
_utf8_on($_);
$cnt+=length;
print;
}
print "\n\e[1;31m中文字数统计\e[0m\t=\t\e[1;34m$cnt\e[0m\n";
