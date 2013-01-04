#!/usr/bin/perl
use LWP;
use LWP::UserAgent;
use Encode;
my $ua = LWP::UserAgent->new();
$ua->max_size( 180 * 1024 );
#$in=`echo $ARGV[0]|iconv -f utf8 -t gbk|uni2ascii -a J`;
$in=encode("GBK",decode("UTF-8",join(' ',@ARGV)));
$in=unpack("H*",$in); $in=~s/../%$&/g;

my $reply = $ua->get("http://baike.baidu.com/list-php/dispose/searchword.php?word=".$in."&pic=0&sug=1&enc=utf8");
#http://baike.baidu.com/search/word?word=元旦&pic=1&sug=1&enc=utf8
my $html;
if($reply->is_success){
	$html = $reply->content;
	$html=~/URL=(.*)'/;
	my $new=$1;
	if($new!~/\d+\.htm/){print "没有收录。";die;}
#    print "百科查询 \e[1m\e[32m$ARGV[0]\e[0m 链接：\e[34m http://baike.baidu.com".$new." \e[0m\n";
	my $reply = $ua->get("http://baike.baidu.com".$new);
	if($reply->is_success){
		$html = $reply->content;
#        $html=~/Description.*?content=\"(.*?)\"/;
		$html=~/card-summary-content"><p>(.*?)<\/p/;
		if(!$1){
			$html=~/headline-content">(.*?)\n/;
			$html=$1;
			}else{
			$html=$1;
			}
		$html=~s/<.*?>//g; $html=~s/\r//g; $html=~s/&.*?;//g;
		$html=~s/if\s\(.*\}//;
		$html=encode("UTF-8", decode("GBK", $html));
		print $html;
	}
}
else {die "无法获取的地址。";}
