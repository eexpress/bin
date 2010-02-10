#!/usr/bin/perl

use Cwd qw(abs_path);
use Getopt::Long;
$workpath="$ENV{HOME}/bin/desktop.pic/";

GetOptions('o' => \$old_pic);
# 无图片参数时，使用缺省的桌面文件（链接）●
my $desk=abs_path($ARGV[0]?$ARGV[0]:"$ENV{HOME}/bin/default.pic");
goto PASTE if $old_pic;

$picpath="$ENV{HOME}/媒体/";	#图片的目录●
chdir $picpath;
$num=int 4+rand(2);	#随机取得4-8张照片。png格式。
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

#修改时间是当天的，不重复执行。
chdir $workpath;
#`$ENV{HOME}/bin/cal.pl` if (! -e "cal.png"|-M "cal.png">1);
#`$ENV{HOME}/bin/weather.pl -p` if (! -e "weather.png"|-M "cal.png">1);
#`$ENV{HOME}/bin/opera/todo.pl` if (! -e "todo.png"|-M "cal.png">1);
my %excute=(
	"cal"=>"","weather"=>"","todo"=>"opera/",
);
my ($sec,$min,$hour,$day,$mon,$year,$wan)=localtime(time);
$today="$year-$mon-$day";
foreach (keys %excute){
my ($sec,$min,$hour,$day,$mon,$year,$wan)=localtime((stat "$_.png")[9]);
$fileday="$year-$mon-$day";
`$ENV{HOME}/bin/$_.pl` if($fileday ne $today);
}

PASTE:
chdir $workpath;
my @files = glob "d-*.png";
#my @files = glob "d-*.png todo.png weather.png";
my $cmd="habak ".$desk;
foreach(@files){
my $x=int 300+rand(1280-500);		# 屏幕位置范围
my $y=int 100+rand(800-400);
$cmd=$cmd." -mp $x,$y $_";
}
#$ttf='/usr/share/fonts/truetype/arphic/ukai.ttf';
#$cmd=$cmd." -mf \"$ttf\" -mc 255,255,255,100 -mh 48 -mp 20,600 -ht \"$d\"";
$cmd.=" -mp 30,540 cal.png" if -e "cal.png";
$cmd.=" -mp 300,40 todo.png" if -e "todo.png";
$cmd.=" -mp 700,40 weather.png" if -e "weather.png";
print "cmd\t-> $cmd\n";
`$cmd`;
