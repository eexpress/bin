#!/usr/bin/perl
use LWP;
use LWP::UserAgent;
use Encode;
my $ua = LWP::UserAgent->new();
$ua->max_size( 35 * 1024 );
$in=`echo $ARGV[0]|iconv -f utf8 -t gbk|uni2ascii -a J`;
my $reply = $ua->get("http://baike.baidu.com/list-php/dispose/searchword.php?word=".$in."&pic=0");
my $html;
if($reply->is_success){
$html = $reply->content;
$html=~/URL=(.*)'/;
my $new=$1;
if($new!~/\d+\.htm/){print "没有收录。$new。";die;}
print "实际链接：http://baike.baidu.com".$new;
my $reply = $ua->get("http://baike.baidu.com".$new);
if($reply->is_success){
$html = $reply->content;
$html=~s/^.*?<\/h\d>//is;	# 开头到</h1>删除
$html=~s/<.*?>//gis;
$html=~s/\ *//gis;
#$html=~s/&.*?;//gis;
#s/&amp;/&/g; s/&gt/>/g; s/&lt;/</g;
#s/&quot;/"/g; s/&nbsp;/ /g;

$html=~s/\x0d\x0a/\n/gis;
$html=decode("GBK", $html);
$html=encode("UTF-8", $html);
$html=~s/百度百科.*//is;
$html=~s/\xe3\x80\x80//gim;
$html=~s/^[\x00-\x80]+$//gim;	# 全英文行
$html=~s/^$//gis;

if($ARGV[1]){
$html=~s/\x0a+/ ► /gis;
}
print $html;
}
}
else {die "无法获取的地址。";}
