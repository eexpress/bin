#!/usr/bin/perl

use Encode qw(encode decode);

$in=`xclip -o`;
if($ARGV[0]){$in=$ARGV[0];}

$icon='/usr/share/icons/gnome/48x48/actions/system-search.png';
$url="http://www.ip138.com/ips138.asp?ip=".$in;
use LWP::Simple; $_=get($url); $_=encode("utf8",decode("gbk",$_));
/本站数据：([^<]*)/;
$_=$1;
print;
`notify-send -i $icon "IP地址查询 $in" "$_"`;

