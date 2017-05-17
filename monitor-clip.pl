#!/usr/bin/perl

sub ip_138{
use LWP::Simple;
use Encode qw(encode decode);
$in=shift;
$icon='/usr/share/icons/HighContrast/48x48/actions/system-search.png';
$url="http://www.ip138.com/ips138.asp?ip=".$in;
$_=get($url); $_=encode("utf8",decode("gbk",$_));
/本站数据：([^<]*)/;
$_=$1;
print;
`notify-send -i $icon "IP地址查询 $in" "$_"`;
}

sub sdcv{
$in=shift; $out="";
@_=`locate stardict.png`; $icon=$_[0]; chomp $icon;
open(SDCV,"sdcv -n $in|");
while(<SDCV>){
	if (! ((1 .. /^$/) || (/相关/||/^$/ .. eof))){ $out.=" ► $_\\n"; }
}
close(SDCV);
`notify-send -i $icon "sdcv翻译 $in" "$out"`;
}

sub web_translate{
$in=shift;
$in=~s/["']//g;
if($in=~/[\x80-\xFF]{2,4}/){$str="#zh/en";}else{$str="#en/zh";}
chomp $in;
$out="http://fanyi.baidu.com/$str/$in";
print $out;
`xdg-open \'$out\'`;
}

sub videoplay{
$in=shift;
print $in;
chomp $in;
$dl='/home/eexpss/bin/you-get/you-get';
$out=`$dl -i $in`;
print $out;

@format=$out=~/--format=\K\S+/g;
$out=join " ",@format;
if($out=~/hd2/){$out="--format=hd2";}	#youku
elsif($out=~/mp4/){$out="--format=mp4";}
elsif($out=~/TD/){$out="--format=TD";}	#iqiyi
elsif($out=~/HD/){$out="--format=HD";}
else{$out="";}

print "$dl $out -p mplayer $in";
`$dl $out -p mplayer $in`;
}
#----------------------------------
$sound='/usr/share/sounds/ubuntu/notifications/Mallet.ogg';
$sound='';
if(-f $sound){
$_=`pacmd list-sinks`;
/\s*(\d*)%.*dB/;
$oldv=$1;
`pactl set-sink-volume 0 40%`;
`paplay $sound &`;
`pactl set-sink-volume 0 $oldv%`;
}
#----------------------------------
$_=`xclip -o`;
if($ARGV[0]){$_=$ARGV[0];}
#百度盘的地址，下载。终端里执行和面板点击都有效，就是热键失效？！！
if(/^https*.+baidupcs.com\/.+/){chomp;`gnome-terminal -x axel -n 60 -a '$_'`;exit;}
#视频网站，直接播放。
if($_=~m!^https*://(v.youku.com|tv.sohu.com|video.tudou.com|v.qq.com|www.iqiyi.com|www.bilibili.com|www.acfun.cn)!){videoplay($_);exit;}
#/和~开头的存在的文件，打开
if(/^~?\/.../){s/^~/$ENV{HOME}/;s/\n.*//;if(-e){`xdg-open \"$_\"`;exit;}}
#终端选择的文件名，视频
if(/\.(avi|mkv|mp4|wmv|ogg)$/){$_=`locate -e -n 1 $_`;chomp;`mplayer "$_"`;exit;}
#ip格式的数字，域名，查询
if(/\d+\.\d+\.\d+\.\d+/){ip_138($&);exit;}
if(/(\w+\.){1,3}[A-Za-z]{2,3}$/ && !/:/){ip_138($&);exit;}
#单词，有本地翻译软件就直接翻译
if(/^\w+$/ && -x '/usr/bin/sdcv'){sdcv($&); exit;}
#番号下载
if(/\w{2,4}-\d{3,4}/){`/home/eexp/bin/bt.pl $&`;exit;}
#其他没://的，网页翻译
if(! /:\/\//){web_translate($_);exit;}
#----------------------------------
