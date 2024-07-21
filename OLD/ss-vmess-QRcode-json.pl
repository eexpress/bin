#!/usr/bin/perl

# 在json，ss字符串，QRCode二维码，文本字符串之间互相转换。
# 依赖 libjson-perl 包。

use 5.010;
no warnings 'experimental::smartmatch';
use MIME::Base64;
use JSON;
use utf8::all;
#~ ⭕ pi libutf8-all-perl
use Encode;

use File::Basename;
use Cwd qw(abs_path getcwd);
$scriptpath=dirname(abs_path($0));
#~ $scriptpath="/home/eexpss/app/v2ray/";
$save_path="$scriptpath/Json/";
$template_path="$scriptpath/Template/";

$_=shift;
given($_){
	when (m'^--?s(creen)?$')	{screen()}
#剪贴板，从手机v2rayNG"导出全部配置至剪贴板"
	when (m'^--?c(lip)?$')		{$mline=`xclip -o -selection clip`;处理多行输入();}
#鼠标选择
	when (m'^-x$')			{$mline=`xclip -o -selection primary`;处理多行输入();}
	when (m'^--?p(ipe)?$')		{local $/=undef;$mline=<>;处理多行输入();}
#图片文件或者json配置文件
	when (-f && /\.(png|jpg)$/)	{img()}
	when (-f && /\.json$/)		{json()}
#字符串
	when (m'^ss://')		{ss()}
	when (m'^vmess://')		{vmess()}
	default				{help()}
}

#-------------------
sub 处理多行输入(){
	#~ while($mline=~m'^.{2,5}://.*$'mg){
		#~ $_=$&;
	for (split /^/m, $mline){
		given($_){
			when (m'^ss://')		{ss()}
			when (m'^vmess://')		{vmess()}
			#~ when (-f && /\.json$/)		{json()}	# 奇怪，不能使用 -f。
		#~ ⭕ l Json/*.json | ./ss-vmess-QRcode-json.pl -p
			when (/\.json$/)		{json(-1)}
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
	say "参数: ss/vmess字符串/二维码图片(需要安装zbarimg)，转换成v2ray格式的json文件。";
	say "参数: json文件，转换成对应的ss/vmess字符串，并在tty显示二维码。";
	say "---------------------------------------";
	say "-s --screen 识别屏幕二维码。使用import截图(需要安装ImagMagick)。";
	say "-c --clip 读取剪贴板的多行数据。适合于从手机v2rayNG\"导出全部配置至剪贴板\"，通过gsconnect共享。";
	say "-x 读取鼠标选中的多行数据。-p --pipe 读取管道的多行数据。可用于多行字符串或者多行文件导出到手机，过gsconnect共享。";
#~ ⭕ l Json/*.json | ./ss-vmess-QRcode-json.pl -p
}
#-------------------
sub img(){
# BifrostV 居然用(半截)明文二维码。。。算了。。
# 只支持ss原版的二维码
#ss://YWVzLTI1Ni1jZmI6VWowTW9vSVpYRWF4QDEzOS4xNjIuMTk0LjIzMzo1NDIzMAo=
	say "----\t\Uimg\t----";
	die "需要安装zbarimg才能识别二维码。" if ! -x "/usr/bin/zbarimg";
	$_=`zbarimg "$_"`;
	s'QR-Code:''; chomp;
	say; say "==================";
	given($_){
		when (m'^ss://')	{ss()}
		when (m'^vmess://')	{vmess()}
		default			{say "不可转换的二维码。"; exit;}
	}
}
#-------------------
sub ss(){
#ss://base64(method:password@server:port)#remarks
#ss://base64(method:password)@server:port#remarks 最近又搞成这样？
	say "----\t\Uss\t----";
	s'^ss://'';			#去头
	s/#(?<mark>.*)//;	#去尾。缺省贪婪匹配
	$remark=$+{mark};
	if(/\@/){
		($code,$ip)=split '\@';
		($add,$port)=split ':', $ip;
		($method,$password)=split ':', decode_base64($code);
	}
	else{
		$_=decode_base64($_);
		s/\@/:/; ($method,$password,$add,$port)=split ':';
	}
	$remark||=$add;
	$remark=`./URI-Escape-转码.pl $remark`;

	say "$method \t$password \t$add \t$port\t$remark";
	say "==================";
	if($add eq ""){say "无地址，格式无效"; exit;}

	# v2ray不认ss格式的json文件
	# 输出成v2ray格式的json文件
	$if="$template_path/v2rayNG.ss.json.Template";
	open IN,"<$if" or die $!; $eof=$/; undef $/; $_=<IN>; $/=$eof; close IN;
	s/xxxadd/$add/; s/xxxport/$port/;
	s/xxxmethod/$method/; s/xxxpassword/$password/;
#    $f="$ENV{HOME}/ss-$remark.json";
	$remark=~s'.*/''g;
	$f=$save_path."ss-$remark.json";
	$f=~s/\ //g;
	open OUT,">$f"; say $f; say ""; print OUT $_; close OUT;
}
#-------------------
sub vmess(){
	say "----\t\Uvmess\t----";
	s'^vmess://'';
	$_=decode_base64($_);	#decode_base64解码后的中文，无utf8标识，会乱码输出。
	$tmp=$_; Encode::_utf8_on($tmp);
	say $tmp; say "==================";
	$rh=decode_json($_);	#decode_json可以正常识别utf8。
	if($rh->{"add"} eq ""){say "格式无效"; exit;}

	# 输出成v2ray格式的json文件
	$if="$template_path/v2rayNG.vmess.json.Template";
	open IN,"<$if" or die $!; $eof=$/; undef $/; $_=<IN>; $/=$eof; close IN;
	s/xxxadd/$rh->{add}/; s/xxxport/$rh->{port}/;
	s/xxxid/$rh->{id}/; s/xxxaid/$rh->{aid}/;
	s/xxxnet/$rh->{net}/; s/xxxtls/$rh->{tls}/;
	s/xxxpath/$rh->{path}/;
	s/xxxhost/$rh->{host}/g;
	$tmp=$rh->{ps}; $tmp=~s/\[.*\]//;
	$tmp=~s'.*/''g;	#ps里面可能带有斜杆。
	$f=$save_path."vv-$tmp.json";
	$f=~s/\ //g;
	open OUT,">$f"; say $f; say ""; print OUT $_; close OUT;
}
#-------------------
sub json(){
	$silent=shift;
	open IN,"<$_" or die "打开文件失败。";
	$ps=$_; $ps=~s".*/""; $ps=~s/.{2,5}-//; $ps=~s/\.json$//;
	#~ say $ps;
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
			outputstr("ss");
			#~ if(! $silent){say; say "============";}
			#~ $_="ss://".encode_base64($_);
			#~ chomp; qrcode() if ! $silent; say;
			}
		when ("vmess"){
			$add=$json->{outbounds}[0]->{settings}->{vnext}[0]->{address};
			$port=$json->{outbounds}[0]->{settings}->{vnext}[0]->{port};
			$id=$json->{outbounds}[0]->{settings}->{vnext}[0]->{users}[0]->{id};
			$aid=$json->{outbounds}[0]->{settings}->{vnext}[0]->{users}[0]->{alterId};
			$net=$json->{outbounds}[0]->{streamSettings}->{network};
			$tls=$json->{outbounds}[0]->{streamSettings}->{security};
			$host=$json->{outbounds}[0]->{streamSettings}->{wsSettings}->{headers}->{Host};
			$path=$json->{outbounds}[0]->{streamSettings}->{wsSettings}->{path};
			$_="{
\"add\":\"$add\",\"aid\":\"$aid\",\"host\":\"$host\",\"id\":\"$id\",
\"net\":\"$net\",\"path\":\"$path\",\"port\":\"$port\",
\"ps\":\"$ps\",\"tls\":\"$tls\",\"type\":\"none\",\"v\":\"2\"
			}";
# 手机上的v2rayNG，扫描vmess二维码，或者读入剪贴板，会把 host 和 path 搞乱。奇怪的bug。????????
# 必须加上 type 和 v 字段，才正确。
			outputstr("vmess");
			#~ if(! $silent){say; say "============";}
			#~ $_="vmess://".encode_base64(encode('utf8',$_));	#ps里面经常有emoji字符。这个base64模块居然不认。
			#~ s/\n//sg;
			#~ chomp; qrcode() if ! $silent; say;
		}
		default		{say "无效的协议格式。"}
	}
}
#-------------------
sub outputstr(){	# 函数放在调用之前，居然显示 Too many arguments
	$prefix=shift;
	if(! $silent){say "----\t\Ujson\t----"; say; say "============";}
	$_=$prefix."://".encode_base64(encode('utf8',$_));	#ps里面经常有emoji字符。这个base64模块居然不认。
	s/\n//sg;
	chomp;
	if($prefix == "ss"){$ps=`./URI-Escape-转码.pl $ps`; $_=$_."#$ps";}
	qrcode() if ! $silent; say;
	}
#-------------------
sub qrcode(){
	# 让外部命令的显示，输出到父进程。
	if (! -x "/usr/bin/qrencode"){say "可以安装qrencode显示二维码。";return;}
	#~ open(PROCS,"qrencode -t ANSI256 \'$_\'|");
	open(PROCS,"qrencode -t ANSIUTF8 \'$_\'|");
	@_=<PROCS>;
	#~ pop; pop; pop; shift; shift; shift;		#去掉上下三行
	#~ for(@_){s"^([^ ]+)\ {4}"\1"; s"\ {4}([^ ]+)$"\1";}	#左右去掉四列
	print @_;
	close(PROCS);
}
#-------------------
