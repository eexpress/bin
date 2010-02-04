#!/usr/bin/perl

use Cwd qw(abs_path);
# 无图片参数时，使用缺省的桌面文件（链接）●
my $desk=abs_path($ARGV[0]?$ARGV[0]:"$ENV{HOME}/bin/default.pic");

$picpath='/home/exp/媒体/';	#图片的目录●
chdir $picpath;
$num=int 4+rand(2);	#随机取得4-8张照片。png格式。
print "total\t-> $num\n";
my @files = glob "*.png *.jpg";
unlink glob "/tmp/d-*.png";
my @do;

for(1..$num){
$in=$files[int rand(@files)];
$out="/tmp/d-$in.png";
if(grep /$in/,@do){redo;}	# 确保不重复使用文件
push @do,$in;

my $size=int 100+rand(80);	# 缩放100-180之间
`convert \"$in\" -scale \"$size>\" \"$out\"`;

my $mess=rand(10);		# 不同效果处理
if($mess < 5){
print "mess\t-> $in\n";
`convert \"$out\" \\( +clone -threshold -1 -virtual-pixel black -spread 30 -blur 0x3 -threshold 40% -spread 2 -blur 10x.7 \\) +matte -compose Copy_Opacity -composite \"$out\"`;
} else {
print "frame\t-> $in\n";
`convert \"$out\" -bordercolor "#C2C2C2" -border 5 -bordercolor "#323232" -border 1 \"$out\"`;
}

`convert \"$out\" -background  black \\( +clone -shadow 60x4+4+4 \\) +swap -background none -flatten \"$out\"`;	# 阴影

my $rot=int rand(90)-45;		# 旋转选择正负45度
`convert \"$out\" -background none -rotate $rot \"$out\"`;
}

chdir '/tmp/';
my @files = glob "d-*.png";
my $cmd="habak ".$desk;
foreach(@files){
my $x=int 300+rand(1280-500);		# 屏幕位置范围
my $y=int rand(800-300);
$cmd=$cmd." -mp $x,$y $_";
}
#use POSIX qw(strftime);
#my $d=strftime("%A",localtime(time));
#my $d=strftime("%A %Y年 %m月 %d日",localtime(time));
#$ttf='/home/exp/安装/备份/字体/中文字体/华康娃娃体-WaWaW5.ttf';
#$ttf='/home/exp/安装/备份/字体/中文字体/方正粗宋简体.ttf';
#$ttf='/usr/share/fonts/truetype/arphic/ukai.ttf';
#$cmd=$cmd." -mf \"$ttf\" -mc 255,255,255,100 -mh 48 -mp 20,600 -ht \"$d\"";
`$ENV{HOME}/bin/cal.pl`;
$cmd.=" -mp 30,540 /tmp/pango.png";
print "cmd\t-> $cmd\n";
`$cmd`;
