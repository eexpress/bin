#!/usr/bin/perl

# 无参数时，使用剪贴板内容。
$in=join('+',@ARGV);if(!$in){$in=`xsel -o`;} if(!$in){exit;}
$in=~s/ /+/g; $in=~s/["']//g;
if($in=~/[\x80-\xFF]{2,4}/){$str="zh-CN|en";}else{$str="en|zh-CN";}
$in=`echo "$in"|uni2ascii -a J -s`;
chomp $in;
$out="http://translate.google.cn/?hl=en#$str|$in";
print $out;
`gnome-open \'$out\'`;

