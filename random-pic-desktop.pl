#!/usr/bin/perl

use Cwd qw(abs_path);
use Getopt::Long;
$workpath="/tmp/";

GetOptions('o' => \$old_pic);
# 无图片参数时，使用缺省的桌面文件（链接）●
my $desk=abs_path($ARGV[0]?$ARGV[0]:"$ENV{HOME}/bin/cairo2png/cairo2png.png");
goto PASTE if $old_pic;

$picpath="$ENV{HOME}/媒体/";	#图片的目录●
chdir $picpath;
$num=int 4+rand(4);	#随机取得4-8张照片。png格式。
print "total\t-> $num\n";
my @files = glob "*.png *.jpg";
unlink glob $workpath."d-*.png";
my @do;

for(1..$num){
$in=$files[int rand(@files)];
$out=$workpath."d-$in.png";
if(grep /$in/,@do){redo;}	# 确保不重复使用文件
push @do,$in;

my $size=int 100+rand(80);	# 缩放100-180之间
`convert \"$in\" -scale \"$size>\" \"$out\"`;

my $mess=int rand(7);		# 不同效果处理
if($mess == 0){
print "mess\t-> $in\n";
`convert \"$out\" \\( +clone -threshold -1 -virtual-pixel black -spread 30 -blur 0x3 -threshold 40% -spread 2 -blur 10x.7 \\) -compose Copy_Opacity -composite \"$out\"`;
}
if($mess == 1) {
print "frame\t-> $in\n";
`convert \"$out\" -bordercolor "#C2C2C2" -border 5 -bordercolor "#323232" -border 1 \"$out\"`;
}
if($mess == 2) {
print "edge\t-> $in\n";
`convert \"$out\" -colorspace Gray  -edge 1 -negate \"$out\"`;
}
if($mess == 3) {
print "distort\t-> $in\n";
`convert \"$out\" -matte -virtual-pixel transparent -distort Perspective '0,0,0,0  0,90,0,90  90,0,90,25  90,90,90,65' \"$out\"`;
}
if($mess == 4) {
print "distort\t-> $in\n";
`convert \"$out\" -matte -virtual-pixel transparent -distort Barrel "0.0 -0.2 0.0 1.3" \"$out\"`;
}
if($mess == 5) {
print "spherical\t-> $in\n";
`convert \"$out\" spherical_unified.png \\( +clone  -channel B -separate +channel \\) \\( -clone 0,1    -fx 'p{ v.r*w, v.g*h }' -clone 2   -compose HardLight -composite -clone 1  -alpha on  -compose DstIn -composite \\) -delete 0--2 \"$out\"`;
}
if($mess == 6) {
print "wave\t-> $in\n";
`composite wave_gradient.png \"$out\" -displace 5x5 \"$out\"`;
}
#http://www.imagemagick.org/Usage/mapping/

`convert \"$out\" -background  black \\( +clone -shadow 60x4+4+4 \\) +swap -background none -flatten \"$out\"`;	# 阴影

my $rot=int rand(90)-45;		# 旋转选择正负45度
`convert \"$out\" -background none -rotate $rot \"$out\"`;
}

PASTE:
chdir $workpath;
my @files = glob "d-*.png";
my $cmd="habak ".$desk;
foreach(@files){
my $x=int 300+rand(1280-500);		# 屏幕位置范围
my $y=int 100+rand(800-400);
$cmd=$cmd." -mp $x,$y $_";
}
print "cmd\t-> $cmd\n";
`$cmd`;
