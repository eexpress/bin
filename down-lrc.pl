#!/usr/bin/perl -w

use WWW::Mechanize;
use Encode;

#参数为mp3歌曲名，转到当前目录，按照"(歌手-)歌名.mp3"的格式读取信息。
use File::Basename qw/basename dirname/;

chdir dirname $ARGV[0];
$file=basename $ARGV[0];
$file=~s/\.mp3//;
print $file;
die "无此mp3文件。" if ! -f "$file.mp3";
if($file=~/-/){($ar,$ti)=split /-/,$file;}else{$ar="";$ti=$file;}
print "$file =...$ar...$ti...\n";
$ar=`echo $ar|iconv -f utf8 -t gbk|uni2ascii -a J`;
$ti=`echo $ti|iconv -f utf8 -t gbk|uni2ascii -a J`;
chomp $ar; chomp $ti;
#======================
my $mech = WWW::Mechanize->new();
$mech -> get("http://lrc.aspxp.net/?ar=$ar&ti=$ti");
if ($mech->success()) {
	print $mech->uri();
#        print $mech->content();
	$mech->content(format =>'text');
	$mech->follow_link(text_regex=>qr/^LRC/, n=>1);
	print "\nlrc=>".$mech->uri()."\n";
#        print $mech->content();
#        my $link=$mech->find_link(text_regex=>qr/^LRC/, n =>2);
#        print $link->text();
#        print $link->url_abs();
#        print $link->URL();
#        mech->find_link(text_regex=>qr/^LRC/, n =>2)->url_abs();
#        print $mech->{content};
	$_=$mech->content();
	/\[ti:.*$/m; $_=$&; s/<.*?>/\n/g; print;
	open OUT,">$file.lrc"; print OUT; close OUT;
#        $l=decode("GBK",$l);
#        $l=encode("UTF-8",$l);
#        print $l;
#        @l=$mech->{content};
#        print encode("UTF-8",decode("GBK",@l));
#        $mech->save_content("/tmp/lrc");
}
#======================
#open TMP,"/tmp/lrc";
#open OUT,">$file.lrc";
#while (<TMP>){print OUT encode("UTF-8",decode("GBK",$_));}
#close TMP; close OUT;
#$file=decode("UTF-8",$file);$file=encode("GBK",$file);
#/home/exp/媒体/音乐●/其他歌手/李克勤-红日.mp3
#http://lrc.aspxp.net/?ar=%C0%EE%BF%CB%C7%DA&al=&ti=%BA%EC%C8%D5&x=27&y=6
#● echo '%C0%EE%BF%CB%C7%DA'|ascii2uni -a J|iconv -f GBK -t utf8
#6 tokens converted
#李克勤
#nocode:
#http://lrc.aspxp.net/?ar=%C3%A6%C2%9D%C2%8E%C3%A5%C2%85%C2%8B%C3%A5%C2%8B%C2%A4&al=&ti=%C3%A7%C2%BA%C2%A2%C3%A6%C2%97%C2%A5
#code:
#http://lrc.aspxp.net/?ar=%C3%80%C3%AE%C2%BF%C3%8B%C3%87%C3%9A&al=&ti=%C2%BA%C3%AC%C3%88%C3%95
#baike.pl
#$in=`echo $ARGV[0]|iconv -f utf8 -t gbk|uni2ascii -a J`;

#agent = WWW::Mechanize.new 
#data = agent.get_file('http://www.test.com/top.gif') 
#open('top.gif', 'wb'){|f| f.write(data)}
#$mech->get( $uri, ':content_file' => $tempfile );

