#!/usr/bin/perl

#----------------------------------
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
#----------------------------------
sub web_translate{
	$in=shift;
	$in=~s/["']//g;
	if($in=~/[\x80-\xFF]{2,4}/){$str="#zh/en";}else{$str="#en/zh";}
	chomp $in;
	$out="http://fanyi.baidu.com/$str/$in";
	`xdg-open \'$out\'`;
}
#----------------------------------
sub videoplay{
	$in=shift;
	print $in;
	chomp $in;
	$dl='/home/eexpss/bin/you-get/you-get';
	$out=`$dl -i $in`;

	@format=$out=~/--format=\K\S+/g;
	$out=join " ",@format;
	if($out=~/hd2/){$out="--format=hd2";}	#youku
	elsif($out=~/mp4/){$out="--format=mp4";}
	elsif($out=~/TD/){$out="--format=TD";}	#iqiyi
	elsif($out=~/HD/){$out="--format=HD";}
	else{$out="";}

	`$dl $out -p mplayer $in 2>/dev/null`;
}
#----------------------------------
sub exec_regex{
	$_=shift;
#百度盘的地址，下载。终端里执行和面板点击都有效，就是热键失效？！！
	if(/^https*.+baidupcs.com\/.+/){sound();chomp;`gnome-terminal -x axel -n 60 -a '$_'`;return;}
#视频网站，直接播放。
	if($_=~m!^https*://(v.youku.com|tv.sohu.com|video.tudou.com|v.qq.com|www.iqiyi.com|www.bilibili.com|www.acfun.cn)!){sound();videoplay($_);return;}
#/和~开头的存在的文件，打开
	if(/^~?\/.../){s/^~/$ENV{HOME}/;s/\n.*//;if(-e){sound();`xdg-open \"$_\"`;return;}}
#终端选择的视频文件(文件名可以不完整)，定位并播放
	if(/\.(avi|mkv|mp4|wmv|ogg)\'*$/){sound();$_=`locate -e -n 1 $_`;chomp;`mplayer "$_"`;return;}
#ip格式的数字，域名，查询
	if(/\d+\.\d+\.\d+\.\d+/){sound();ip_138($&);return;}
	if(/(\w+\.){1,3}[A-Za-z]{2,3}$/ && !/:/){sound();ip_138($&);return;}
#全英文句子或单词，有本地翻译软件就直接翻译，否则网页翻译
# 可显示ascii字符，全英文句子。“.xxx”像文件名的，不执行。
	if(/^[\x20-\x7e]+$/ && /\w{3,}/ && !/\.\w+$/){sound();web_translate($_);return;}
#番号下载
	if(/\w{2,4}-\d{3,4}/){`/home/eexp/bin/bt.pl $&`;return;}
}
#----------------------------------
sub sound{
	$sound='/usr/share/sounds/gnome/default/alerts/glass.ogg';
	if(-f $sound){
		$in=`pacmd list-sinks`;
		$in=~/\s*(\d*)%.*dB/;
		$oldv=$1;
		`pactl set-sink-volume 0 40%`;
		`paplay $sound &`;
		`pactl set-sink-volume 0 $oldv%`;
	}
}
#==================================
#parse mode <- any para here
if($ARGV[0]){
	$_=`xclip -o`;
	exec_regex($_);
	exit;
}

#monitor mode
$oldclip=`xclip -o`;
while(true){
	sleep 3;
	$clip=`xclip -o`;
	if($clip ne $oldclip){
		$oldclip=$clip;
		print "\e[1;31mnew clip:\e[0m\t$clip\n";
		exec_regex($clip);
	}
}
#==================================
