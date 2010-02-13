#!/usr/bin/perl

use utf8;
use Getopt::Long;
use Gtk2;
use Encode;
use File::Basename qw/basename dirname/;
chdir dirname $0;

$input="cairo2png.rc";
$output="cairo2png.png";
GetOptions('input=s'=>\$input,'output=i'=>\$output,'help'=>\$help);

sub help{
print "
\e[32m\e[1m参数：\e[0m
-h, --help	此帮助
-i \e[31mfile\e[0m, --input \e[31mfile\e[0m, --input=\e[31mfile\e[0m	后接文件名，指定配置文件。
-o \e[31mfile\e[0m, --output \e[31mfile\e[0m, --output=\e[31mfile\e[0m	后接指定输出的图片文件。
\e[32m缺省的输入配置文件是 cairo2png.rc。输出图片是 cairo2png.png。\e[0m

\e[32m\e[1m配置文件格式说明：\e[0m
命令以“=>”起始。“//”起始的行为注释行。
=> \e[31mbackground\e[0m 路径或者一个或多个图片文件名。
\e[32m当指定图片为多个或者目录(多文件用空格分割)的时候，将使用随机的方式，选取一个图片作背景。多个background行，均可混合支持。目前，cairo仅仅支持png图片。\e[0m

=> \e[31mpango\e[0m 尺寸坐标 [脚本和文本文件名]
此行到下一个命令间的，直接解析为pango语法的内容。
\e[32m如果指定了脚本或文本文件，脚本输出或者文件内容，将附加在其后，一并解析。
尺寸坐标的格式为：WxH+X+Y\e[0m

=> \e[31mfont\e[0m 字体名[ 尺寸]
\e[32m切换缺省的字体设置。格式如：方正粗宋简 22。\e[0m

=> \e[31malias\e[0m 假名=内容 \e[31m暂时没支持，等以后需要吧。\e[0m
\e[32m替换pango的语法标记格式<...>内部的缩写。写法如：
\e[36malias fsong=font='FZCuSong\-B09S 16'
alias cred=color='#957966'
\e[1mpango语法，可参考 http://library.gnome.org/devel/pango/stable/PangoMarkupFormat.html。
cairo的说明，可参考 http://www.cairographics.org/manual/。\e[0m
";
}

#----------------------------------------------------
if($help){help;exit;}
print "$input => $output\n";
open (IN, $input) || die ("配置文件无效。");
@line=<IN>; close IN;
@line=grep !m"^//",@line;
#@line=grep /^[^#]/,@line;

#预先处理背景图片设置行
@bg=map /=>\s*background\s+(.*)/,@line;
#print "~~~~bg : @bg\n";	# print 的输入，如果包括中文，则$_会乱码。
print map "==$_\n",@bg;
@bg=map {split /\s+/} @bg;
#目录判断后，不能再push非匹配的其他文件。
@bg1=map {-d && glob "$_/*.png"} @bg;
#@bg1=map {-d && glob "$_/*.png" || print} @bg;
@bg=(@bg,@bg1);
@bg=grep {-f && /\.png$/} @bg;

print "\n----------\n";
print map "$_\n",@bg;
$_=$bg[int rand(@bg)];
print "select:$_\n";
die "指定的背景图片不存在。" if ! -f;

@line=grep !/background/,@line;
use Cairo; 
$surface = Cairo::ImageSurface->create_from_png ("$_"); 
$PI=3.1415926/180; $r=100;
foreach (@line){
	#shift;
	if(/^=>/){
		draw_pango();
		if(/\s*pango\s*/){
		@pango=""; @append="";
		($c,$s)=split / /,$';	#坐标，脚本或文本
		chomp $c; ($x,$y)=split /,/,$c;
		chomp $s; print "script or text: $s.\n";
		if(-x $s){@append=`$s  2>/dev/null`;}
#                else{@append=`cat $s`;}
		}
		if(/\s*font\s*/){
			$font=$'; chomp $font;
		
		}
	}
	else{	#pango内容
		push @pango,$_;
	}
}
draw_pango();
$surface->write_to_png ($output);

#----------------------------------------------------
sub draw_pango{
if(@pango||@append){
@pango=(@pango,@append);
print "\n-------draw pango at $x,$y--------\n";
print @pango;

my $cr = Cairo::Context->create ($surface); 
my $pango_layout = Gtk2::Pango::Cairo::create_layout ($cr); 
if($font){
my $font_desc = Gtk2::Pango::FontDescription->from_string("$font"); 
$pango_layout->set_font_description($font_desc); 
}
$pango_layout->set_markup (decode("utf-8", "@pango"));

#my ($w, $h) = $pango_layout->get_size;	#巨大的数据？246784 x 188416
#print "====> $w x $h";
#$cr->rectangle($x,$y,300,30);$cr->set_source_rgba(0,0,0,0.2); $cr->fill;
$cr->arc($x,$y,$r,0,90*$PI);$cr->set_source_rgba(1,0,0,0.2); $cr->fill;
$cr->arc($x+$r,$y+$r,$r,180*$PI,270*$PI);$cr->set_source_rgba(0,1,0,0.2); $cr->fill;

$cr->set_source_rgba(1,1,1,0.3);	#缺省白色字体
$cr->move_to($x,$y);
Gtk2::Pango::Cairo::show_layout ($cr, $pango_layout); 
$cr->show_page ();}
@pango=""; @append="";
}


