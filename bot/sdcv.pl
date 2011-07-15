#!/usr/bin/perl

# 使用脚本目录的图标
use Cwd qw(abs_path);
$0=~s/\/.*?$//; $icon=abs_path $0."/stardict.png";

use Getopt::Long;
# 参数：单行输出选择。屏幕提示输出选择。
GetOptions('1' => \$oneline, 'n'=>\$notify);

my $out,$in;
# 无参数时，使用剪贴板内容。
$in=$ARGV[0]; if(!$in){$in=`xsel -o`;} if(!$in){exit;}
open(SDCV,"sdcv -n $in|");
#my $r;
while(<SDCV>){
if (! ((1 .. /^$/) || (/相关/||/^$/ .. eof))){
chomp if($oneline);
$out.=" ► $_";
}
}
close(SDCV);
if($notify){`notify-send -u critical -i $icon 'sdcv翻译：$in' "$out"`;} else{print $out;}

#while($l=<SDCV>){
#if($l!~/^$/){$r=$l;chomp($r);$r=~s/-->//;}
#else{$out="$r --> ";last;}
#}
#while($l=<SDCV>){
#if($l=~/相关|^$/){
#close(SDCV);
#if($notify){`notify-send -u critical -i '/home/exp/媒体/图标●/128软件png/pidgin.png' 'sdcv翻译' "$out"`;}
#else{print $out;}
#exit;
#}
#chomp($l) if($oneline);
#$out.=" ► $l";
#}


