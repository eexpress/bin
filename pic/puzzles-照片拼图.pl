#!/usr/bin/perl

#输入带路径的*.jpg，自动输出当前目录的p-带日期的拼图文件。
#在rox里面选择图片，在xterm粘贴。按照次序调整粘贴，可改变结果的排列。
use File::Basename qw/basename dirname/;
chdir dirname $ARGV[0];

$_=`exif -m -t 0x9003 \'$ARGV[0]\'`; chomp;
if($? || /0000/){
use POSIX qw(strftime);
$f=strftime "noexif_%Y-%m-%d_%H:%M:%S", localtime;
}
else{
($_,$t)=split /\s/; s/:/-/g;
$f="$_"._."$t";
}

$_=`identify -format "%wx%h" \'$ARGV[0]\'`;
($x,$y)=split /x/;
#$x=`exif -m -t 0xa002 \'$ARGV[0]\'`;
#$y=`exif -m -t 0xa003 \'$ARGV[0]\'`;
#chomp $x; chomp $y;
print "$ARGV[0] - $x -$y\n";
if($x > $y){$p=0.99;$s=400}else{$p=1.5;$s=300};

print "output: $f\tscale: $s\tadjust with sqrt: $p\n";
#exit;

$a="\'".join("\' \'",@ARGV)."\'";
`rm /tmp/4in1*; convert -scale $s $a /tmp/4in1`;

$tile=int(sqrt(@ARGV)+$p);
`montage -tile $tile -geometry +0+0 -background none /tmp/4in1* p-$f.jpg`;

`rm $a`;
