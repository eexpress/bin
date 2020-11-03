#!/usr/bin/perl

# 在json，ss字符串，QRCode二维码，文本字符串之间互相转换。
# 依赖 libjson-perl 包。

use 5.010;
no warnings 'experimental::smartmatch';
use MIME::Base64;
use JSON;
use utf8::all;
#~ ⭕ pi libutf8-all-perl

$savepath="$ENV{HOME}/v2ray的配置/";

#暂时禁止剪贴板操作。
#$_=$ARGV[0]//`xclip -o`;
$_=shift;
given($_){
	when (m'^--?h(elp)?$')		{help()}
	when (m'^--?s(creen)?$')	{screen()}
	when (m'^--?c(lip)?$')		{$multilines=`xclip -o`;deal_multilines();}
	when (m'^--?p(ipe)?$')		{local $/=undef;$multilines=<>;deal_multilines();}
	when (undef)				{help()}
	when (-f && /\.(png|jpg)$/)	{img()}
	when (m'^ss://')			{ss()}
	when (m'^vmess://')			{vmess()}
	when (-f && /\.json$/)		{json()}
#	default						{text()}
}

#-------------------
sub deal_multilines(){
	while($multilines=~m'^.{2,5}://.*$'mg){
		$_=$&;
		given($_){
			when (m'^ss://')			{ss()}
			when (m'^vmess://')			{vmess()}
		}
	}
}
#-------------------
sub screen(){
	die "需要安装ImageMagick才能自动截屏，识别二维码。" if ! -x "/usr/bin/import";
	`import -window root /tmp/ss.png`;
	$_="/tmp/ss.png";
	img();
}
#-------------------
sub help(){
	say "参数: ss/vmess字符串/网页明文表格文本，转换成v2ray格式的json文件。";
	say "参数: json文件，转换成对应的ss/vmess字符串。并在tty显示二维码。";
	say "---------------------------------------";
	say "支持二维码jpg/png文件识别。(需要安装zbarimg)";
	say "为了统一使用v2ray，不支持ssr字符串。";
	say "-s --screen 可以识别屏幕二维码。暂时使用import截图，需要安装ImagMagick。没添加scrot支持。";
	say "-c --clip 可以读取剪贴板的多行数据。";
	say "-p --pipe 可以读取管道的多行数据。";
}
#-------------------
sub img(){
# BifrostV 居然用(半截)明文二维码。。。算了。。
#QR-Code:ss://YWVzLTI1Ni1jZmI6VWowTW9vSVpYRWF4@139.16.19.233:54230#139.16.19.233
#QR-Code:bfv://139.16.19.233:54230/shadowsocks/1?rtype=lanina&dns=8.8.8.8&method=aes-256-cfb&pass=Uj0MooEax&ota=0&tcp=header%3Dnone%26req%3D#139.162.194.233

# 只支持ss原版的二维码
#ss://YWVzLTI1Ni1jZmI6VWowTW9vSVpYRWF4QDEzOS4xNjIuMTk0LjIzMzo1NDIzMAo=
	say "----\t\Uimg\t----";
	die "需要安装zbarimg才能识别二维码。" if ! -x "/usr/bin/zbarimg";
	$_=`zbarimg "$_"`;
	s'QR-Code:''; chomp;
	say; say "==================";
	given($_){
		when (m'^ss://')			{ss()}
		when (m'^vmess://')			{vmess()}
		default						{say "不可转换的二维码。"; exit;}
	}
}
#-------------------
sub ss(){
#ss://base64(method:password@server:port)#remarks
	say "----\t\Uss\t----";
	s'^ss://'';			#去头
	s/#(?<mark>.*)//;	#去尾。缺省贪婪匹配
	$remark=$+{mark};
	$_=decode_base64($_);
	s/\@/:/; ($method,$password,$add,$port)=split ':';
	$remark||=$add;
	savess();
}
#-------------------
#sub text(){
##157.245.48.12 	17975 	isx-30216959 	aes-256-cfb
#	say "----\t\Utext\t----";
#	@_=split /\s+/;
#	if($#_ ne 3){say "数据必须4个，格式无效"; exit;}
#	for(@_){
#		when(/^$/) {}	#网页表格鼠标选择后，夹杂空格和制表符。split导致空字符串，影响default的赋值。所以需要跳过。
#		when(/\d{1,3}(\.\d{1,3}){3}/)	{$add=$_}
#		when(/[\w-]+(\.[\w-]+){2}/)		{$add=$_}
#		when(/^\d{3,5}$/)				{$port=$_}
#		when(/^[ac]\w+(-\w+){0,2}/)		{$method=$_}
#		default		{$password=$_}
#	}
#	$remark=$add;
#	if(! $port || ! $password || ! $method){say "缺少必要数据，格式无效"; exit;}
#	savess();
#}
#-------------------
sub savess(){
	say "$method \t$password \t$add \t$port\t$remark";
	say "==================";
	if($add eq ""){say "无地址，格式无效"; exit;}

	# v2ray不认ss格式的json文件
	# 输出成v2ray格式的json文件
	$if='/home/eexpss/bin/config/proxy.config/v2rayNG.ss.json.Template';
	open IN,"<$if" or die $!; $eof=$/; undef $/; $_=<IN>; $/=$eof; close IN;
	s/xxxadd/$add/; s/xxxport/$port/;
	s/xxxmethod/$method/; s/xxxpassword/$password/;
#    $f="$ENV{HOME}/vss-$remark.json";
	$remark=~s'.*/''g;
	$f=$savepath."vss-$remark.json";
	open OUT,">$f"; say $f;
	print OUT $_; close OUT;
}
#-------------------
sub vmess(){
	say "----\t\Uvmess\t----";
	s'^vmess://'';
	$_=decode_base64($_);
	say; say "==================";
	$rh=decode_json($_);
	if($rh->{"add"} eq ""){say "格式无效"; exit;}

	# 输出成v2ray格式的json文件
	$if='/home/eexpss/bin/config/proxy.config/v2rayNG.vmess.json.Template';
	open IN,"<$if" or die $!; $eof=$/; undef $/; $_=<IN>; $/=$eof; close IN;
	s/xxxadd/$rh->{add}/; s/xxxport/$rh->{port}/;
	s/xxxid/$rh->{id}/; s/xxxaid/$rh->{aid}/;
	s/xxxnet/$rh->{net}/; s/xxxtls/$rh->{tls}/;
	s/xxxpath/$rh->{path}/;
	s/xxxhost/$rh->{host}/g;
	$tmp=$rh->{ps}; $tmp=~s/\[.*\]//;
	$tmp=~s'.*/''g;
	$f=$savepath."vv-$tmp.json";
	open OUT,">$f"; say $f;
	print OUT $_; close OUT;
}
#-------------------
sub json(){
	say "----\t\Ujson\t----";
	open IN,"<$_" or die "打开文件失败。";
	$_=join "\n",<IN>; close IN;
	s'//.+$''mg; $json=decode_json $_;
#    use Data::Dumper; printf Dumper($json)."\n"; say "============";
	given($json->{outbounds}[0]->{protocol}){
		when ("shadowsocks"){
			$add=$json->{outbounds}[0]->{settings}->{servers}[0]->{address};
			$port=$json->{outbounds}[0]->{settings}->{servers}[0]->{port};
			$method=$json->{outbounds}[0]->{settings}->{servers}[0]->{method};
			$password=$json->{outbounds}[0]->{settings}->{servers}[0]->{password};
			$_="$method:$password\@$add:$port";
			say; say "============";
			$_="ss://".encode_base64($_);
			chomp; qrcode(); say;
			}
		when ("vmess"){
			$add=$json->{outbounds}[0]->{settings}->{vnext}[0]->{address};
			$port=$json->{outbounds}[0]->{settings}->{vnext}[0]->{port};
			$id=$json->{outbounds}[0]->{settings}->{vnext}[0]->{users}[0]->{id};
			$aid=$json->{outbounds}[0]->{settings}->{vnext}[0]->{users}[0]->{alterId};
			$_="{\"add\":\"$add\",\"aid\":\"$aid\",\"id\":\"$id\",\"port\":\"$port\",\"ps\":\"$add\"}";
			say; say "============";
			$_="vmess://".encode_base64($_);
			s/\n//sg;
			chomp; qrcode(); say;
		}
		default		{say "无效的协议格式。"}
	}
}
#-------------------
sub qrcode(){
	# 让外部命令的显示，输出到父进程。
	if (! -x "/usr/bin/qrencode"){say "可以安装qrencode显示二维码。";return;}
	open(PROCS,"qrencode -t ANSI256 \'$_\'|");
	@_=<PROCS>; pop; pop; pop; shift; shift; shift;		#去掉上下三行
	for(@_){s"^([^ ]+)\ {4}"\1"; s"\ {4}([^ ]+)$"\1";}	#左右去掉四列
	print @_;
	close(PROCS);
}
#-------------------
