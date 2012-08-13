#!/usr/bin/perl

use Encode qw(decode);

$_=`xsel -o`;
#----------------------------------
if(/^\// || /^~\//){s/^~/$ENV{HOME}/;if(-e){`xdg-open $_`;exit;}}
if(/\d+\.\d+\.\d+\.\d+/){`$ENV{HOME}/bin/ip-138.bash $&`;exit;}
if(/(\w+\.){2,3}\w+/){`$ENV{HOME}/bin/ip-138.bash $_`;exit;}
if(/^\w+$/){`$ENV{HOME}/bin/bot/sdcv.pl -n`; exit;}
if(/ppa:.*\/ppa/){`zenity --question --title="是否添加此PPA源" --text=$&`; `gksudo add-apt-repository $&` if ! $?; exit;}
if(! /:\/\//){`$ENV{HOME}/bin/bot/g-translate.pl -n \"$&\"`;exit;}
#----------------------------------
@url=m"(?:http|mms|rtsp)://[^\s]*"g;
if($#url<0){print "none url\n";return 1;}
$TERM='xterm -e';
foreach(@url){
my $t=""; s/\W+$//;
#----------------------------------
if(/v.youku.com/ || /tudou.com\/playlist/ || /v.ku6.com/ || /6.cn\/watch/        || /tv.sohu.com/){
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

