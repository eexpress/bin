#!/usr/bin/perl

use Encode qw(encode decode);

sub ip_138{
$i=shift;
$url="http://www.ip138.com/ips138.asp?ip=".$i;
use LWP::Simple; $_=get($url); $_=encode("utf8",decode("gbk",$_));
/本站主数据.*\<\/ul\>/m;
$_=$&; s'</li>'\\n'g; s'<.*?>''g;
print; `$ENV{HOME}/bin/msg "IP地址查询 $i" "$_"`;
}

$_=`xsel -o`;
#----------------------------------
#/和~开头的存在的文件，打开
if(/^\// || /^~\//){s/^~/$ENV{HOME}/;s/\n.*//;if(-e){`xdg-open \"$_\"`;exit;}}
#ip格式的数字，域名，查询
if(/\d+\.\d+\.\d+\.\d+/){ip_138($&);exit;}
if(/(\w+\.){1,3}\w+/ && !/:/){ip_138($&);exit;}
#单词，本地翻译
if(/^\w+$/){`$ENV{HOME}/bin/sdcv.pl -n`; exit;}
#ppa源，添加
if(/ppa:.*\/ppa/){`zenity --question --title="是否添加此PPA源" --text=$&`; `gksudo add-apt-repository $&` if ! $?; exit;}
#其他没://的，网页翻译
if(! /:\/\//){`$ENV{HOME}/bin/web-translate.pl \"$&\"`;exit;}
#----------------------------------
#url处理
@url=m"(?:http|mms|rtsp)://[^\s]*"g;
if($#url<0){print "none url\n";exit;}
$TERM='xterm -e';
foreach(@url){
my $t=""; s/\W+$//;
#----------------------------------
#特定网址和流媒体
if(/v.youku.com/ || /tudou.com\/playlist/ || /v.ku6.com/ || /6.cn\/watch/ || /tv.sohu.com/){
   $t="下载flash资源"; `$TERM ~/bin/flash-down.pl $_`;}
elsif(m"http://u.115.com/file/\w+"){
   $t="下载115资源"; `$TERM ~/bin/115_client $&`;}  
elsif(/\<rapidshare.com/ || /hotfile\.com/ || /\<filesonic\.com/){
   $t="保存下载序列"; `echo "$_" >>~/下载/queue`;}  
#   $t="保存slimrat资源"; `$TERM /usr/bin/slimrat $_`;}  
elsif(/^mms/ || /^rtsp/ || /\.asx$/){
   $t="播放网络流媒体"; `$TERM mplayer $_`;}  
#----------------------------------
if($t){
	print "$t ===> $_\n"; $t=decode("utf8",$t);
	`$ENV{HOME}/bin/msg elvis.png  $t $_`;}
else {print "unrecognized url:\t=>$_<=\n";}
}
#----------------------------------

