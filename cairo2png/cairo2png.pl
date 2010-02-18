#!/usr/bin/perl

use Getopt::Long;
use Gtk2;
use Encode;
use File::Basename qw/basename dirname/;
chdir dirname (-l $0?readlink $0:$0);

$input="cairo2png.rc";
$output="cairo2png.png";
GetOptions('input=s'=>\$input,'output=i'=>\$output,
	'help'=>\$help,'desktop'=>\$desktop);

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
\e[32m如果指定了脚本或文本文件，脚本输出或者文件内容，将附加在其后，一并解析。支持相对路径的写法。
尺寸坐标的格式为：WxH+X+Y\e[0m

=> \e[31mfont\e[0m 字体名[ 尺寸]
\e[32m切换缺省的字体设置。格式如：方正粗宋简 22。\e[0m

=> \e[31malias\e[0m 假名=内容 \e[31m暂时没支持，等以后需要吧。\e[0m
\e[32m替换pango的语法标记格式<...>内部的缩写。写法如：
\e[36malias fsong=font='FZCuSong\-B09S 16'
alias cred=color='#957966'
\e[1mpango语法，可参考 http://library.gnome.org/devel/pango/stable/PangoMarkupFormat.html。
cairo的说明，可参考 http://www.cairographics.org/manual/ http://cairographics.org/documentation。man Cairo 其实更好。\e[0m
";
}

#----------------------------------------------------
if($help){help;exit;}
print "$input => $output\n";
open (IN, $input) || die ("配置文件无效。");
@line=<IN>; close IN;
@line=grep !m"^//",@line;		# 去掉注释的行

#预先处理背景图片设置行
@bg=map /=>\s*background\s+(.*)/,@line;
print "\n===> find background lines\n"; print map "$_\n",@bg;
@bg=map {split /\s+/} @bg;		# 拆分多文件的行
@bg=map {-d $_?glob "$_/*.png":$_} @bg;	# 扩展目录成可用图片文件
@bg=grep {-f && /\.png$/} @bg;		# 选择有效的png文件
print "\n===> expand all background files\n"; print map "$_\n",@bg;
$_=$bg[int rand(@bg)];
print "\n===> select:$_\n";
die "指定的背景图片不存在。" if ! -f;

@line=grep !/background/,@line;		# 去掉背景设置的行
use Cairo; 
$surface = Cairo::ImageSurface->create_from_png ("$_"); 
$PI=3.1415926/180; $r=100;
foreach (@line){
	if(/^=>/){	# 遇到命令行，先画完前一个。
		draw_pango();
	if(/\s*pango\s*/){
		@pango=""; @append="";
		($c,$s)=split / /,$';	#坐标，脚本或文本
		chomp $c; ($x,$y)=split /,/,$c;
		chomp $s;
		if($s!~m"^/"){$s="./".$s;}	#非全路径，使用相对路径
		print "\n===> excute script or text: $s.\n";
		if(-x $s){@append=`$s  2>/dev/null`;}
		else{
		#文本文件，去掉空行。最宽输出100字符，最多输出8行。
			if(-T $s)
			{@append=grep !/^\s*$/,`cat $s`;
			@append=map /^(.{1,60})/s,@append;
			splice(@append,7);}	# 截断到最长7行
		}
		}
	if(/\s*font\s*/){$font=$'; chomp $font;}
	}
	else{	# 非命令行，为pango内容
		push @pango,$_;
	}
}
draw_pango();
$surface->write_to_png ($output);
if($desktop){print "\n===>random desktop\n";`/home/exp/bin/random-pic-desktop.pl -o`;}

#----------------------------------------------------
sub draw_pango{
if(!($x&&(@pango||@append))){return;}
@pango=(@pango,@append);
print "-------draw pango at $x,$y--------\n";
print @pango;

my $cr = Cairo::Context->create ($surface); 
my $pango_layout = Gtk2::Pango::Cairo::create_layout ($cr); 
if($font){		# 如果设置了字体
my $font_desc = Gtk2::Pango::FontDescription->from_string("$font"); 
$pango_layout->set_font_description($font_desc); 
}
$pango_layout->set_markup (decode("utf-8", "@pango"));

$cr->arc($x,$y,$r,0,90*$PI);$cr->set_source_rgba(1,0,0,0.2); $cr->fill;
$cr->arc($x+$r,$y+$r,$r,180*$PI,270*$PI);$cr->set_source_rgba(0,1,0,0.2); $cr->fill;

$cr->set_source_rgba(1,1,1,0.3);	#缺省白色字体
$cr->move_to($x,$y);
Gtk2::Pango::Cairo::show_layout ($cr, $pango_layout); 
$cr->show_page ();
@pango=""; @append="";
}


