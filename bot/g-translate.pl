#!/usr/bin/perl

use feature 'say';
use Cwd qw(abs_path);
$0=~s/\/.*?$//; $icon=abs_path $0."/cn-en-128.png";
#$icon="$ENV{HOME}/图片/图标/国旗/cn-en-128.png";
use Getopt::Long;
GetOptions('n'=>\$notify);
my $out,$in,$str;
# 无参数时，使用剪贴板内容。
$in=join('+',@ARGV);if(!$in){$in=`xsel -o`;} if(!$in){exit;}
$in=`echo "$in"|uni2ascii -a J -s`;
$in=~s/ /+/g; $in=~s/["']//g;
chomp $in;
if($in=~/%/){$str="zh-CN%7Cen";}else{$str="en%7Czh-CN";}
$out="curl -e http://www.my-ajax-site.com 'http://ajax.googleapis.com/ajax/services/language/translate?v=1.0&q=$in&langpair=$str' 2>/dev/null";
$out=`$out`;
$out=~/translatedText":"(.*?)"/;
if($notify){
`notify-send -i '$icon' 'google翻译' "$1"`;}
else{say $1;}

