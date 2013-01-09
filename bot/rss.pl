#!/usr/bin/perl

sub cv {
	open(CV, "|/usr/bin/enconv|ascii2uni -a D -q|tr '\n' ' '") or die("没有命令：enconv。\n");
	print CV $_[0];
	close CV;
}
#http://forum.^ubuntu.org.cn/feed.php
@RSS=qw(
http://^hsyyf.me/feed/
http://cn.^engadget.com/rss.xml
http://^linuxtoy.org/feed/
http://feed.feedsky.com/^ldcn
http://www.^cnbeta.com/backend.php
http://^solidot.org/index.rss
http://feed.feedsky.com/^lerosua
http://^imtx.cn/feed/latest/
http://feeds2.feedburner.com/^jandan
http://www.^ibm.com/developerworks/cn/views/rss/customrssatom.jsp?zone_type=AllZones&zone_by=Linux&content_type=select_zones&type_by=%E6%8A%80%E6%9C%AF%E6%96%87%E7%AB%A0&search_by=&day=1&month=01&year=2008&max_entries=10&feed_by=rss&ibm-submit=%E6%8F%90%E4%BA%A4
);

if(!$ARGV[0]){
print "如果没有直接指定rss地址。可输入单词，在全部rss地址列表里，按照次序匹配：";
foreach(@RSS){
s/http.*\^//g;s/\..*$//g;
print " ► ".$_;
}
#my $_=join(" ►  ",@RSS);
#s/http:\/\///g;
#print "全部rss地址列表，按照次序匹配：".$_;
#print "全部rss地址列表，按照次序匹配：".join(" ►  ",@RSS);
exit;
}

use LWP::UserAgent;
my $url=shift;
if($url!~/^http/){
foreach(@RSS){
if($_=~/$url/) {s/\^//g;$url=$_; goto FOUND;}
}
die "列表中找不到此URL。\n";
}
FOUND:

my $ua=new LWP::UserAgent(agent=>"rss.pl");
my $re= $ua->get($url);
die if (!$re->is_success);
my $html= $re->content;

$n=8;
print "RSS新闻：";
#得到页面中所有RSS标题和链接
while($html=~m{<title>(.*?)</title>.*?<link>(.*?)</link>}gsi){
#cv "► $1 --> $2 ";
$_="► $1 --> $2 ";
s/&amp;/&/g; s/&gt;/>/g; s/&lt;/</g; s/&quot;/"/g; s/&nbsp;/ /g;
s/<!\[CDATA\[//g; s/]]>//g; s/&p=[0-9#p]*//g;
cv $_;
#print;
$n--; last if ($n==0);
if($n==4){print "\n";};
}

