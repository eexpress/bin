#!/usr/bin/perl

use utf8;	# 文件路径才可以使用中文。
use Gtk2 -init;
use Gtk2::GladeXML;
use File::Basename qw/basename dirname/;

#fc-list : file family 可以取得字体路径
# 取得执行文件同名的界面文件
#$path=$0;
#$path=readlink $0 if -l $0;
#$path=dirname $path;
#chdir $path;
chdir dirname (-l $0?readlink $0:$0);

$app=basename $0; $app=~s/\..*//;
$glade_file=$app.".glade";
$font_log=$app.".font";
print "using:\t=>$glade_file\t=>$font_log\n";

my $gui = Gtk2::GladeXML->new("$glade_file");
$gui->signal_autoconnect_from_package('main');

my $img="$ENV{HOME}/$app.png";
$gui->get_widget('combo-3d')->set_active(0);
$gui->get_widget('combo-shade')->set_active(0);
$gui->get_widget('preview')->set_from_file($app."_logo.png");

#$gui->get_widget('color-shade')->get_color()->to_string;
if(open(LINK,"$font_log")){$font=<LINK>; $gui->get_widget('file_font')->set_filename($font); close LINK;}
%direction=("←"=>"-4+0","↑"=>"+0-4","→"=>"+4+0","↓"=>"+0+4","↖"=>"-4-4","↗"=>"+4-4","↘"=>"+4+4","↙"=>"-4+4");

Gtk2->main;

#========================子程序============================
sub on_window1_destroy{
$font=$gui->get_widget('file_font')->get_filename();
open(LINK,">$font_log"); print LINK $font; close LINK;
Gtk2->main_quit;
}

sub on_button_view_clicked{
#==============limit
my $scale;
if ($gui->get_widget('check-width')->get_active()){
$scale=$gui->get_widget('value-width')->get_text();
}
if ($gui->get_widget('check-height')->get_active()){
$scale.="x".$gui->get_widget('value-height')->get_text();
}
print "scale is $scale\n";
if (!$scale){$scale="300x100";}
if ($scale=~'\dx\d') {$scale.="!";}
#$cmd="convert $img -scale $scale $img";
#print "====> scale:\t$cmd\n"; system($cmd);

#==============base
$color_base=$gui->get_widget('color-base')->get_color()->to_string;
$font=$gui->get_widget('file_font')->get_filename(); $input=$gui->get_widget('input')->get_text();
#$size="120"; 
$cmd="convert -background none -fill \"$color_base\" -font \"$font\" -size $scale label:\"$input\" $img";
#$cmd="convert -background none -fill \"$color_base\" -font \"$font\" -pointsize $size label:\"$input\" $img";
print "------------------------\n====> base:\t$cmd\n"; system($cmd);
#==============3D
if ($gui->get_widget('check-3d')->get_active()){
$color_3d=$gui->get_widget('color-3d')->get_color()->to_string;$effect=$gui->get_widget('combo-3d')->get_active_text();
$cmd="convert $img -matte \\( +clone -channel A -separate +channel -negate -bordercolor black -border 5  -blur 0x2 -shade 120x30 -normalize -blur 0x1  -fill \"$color_3d\" -tint 100 \\) -gravity center -compose $effect -composite $img";
print "====> 3D:\t$cmd\n"; system($cmd);
}
#==============shade
if ($gui->get_widget('check-shade')->get_active()){
$color_shade=$gui->get_widget('color-shade')->get_color()->to_string;
my $dir=$direction{$gui->get_widget('combo-shade')->get_active_text()};
my $off=$gui->get_widget('value-shade')->get_text();
$dir=~s/4/$off/g;
$cmd="convert $img \\( +clone -background \"$color_shade\" -shadow 80x4$dir \\) +swap -background none  -layers merge +repage $img";
print "====> shade:\t$cmd\n"; system($cmd);
}

$gui->get_widget('preview')->set_from_file($img);
}

