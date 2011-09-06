#!/usr/bin/perl

use Cairo;
use POSIX qw(mktime);
use  Gtk2 "-init";

# 每一个条目，需要一个空行结束，才会绘画。
# 背景图片设置位置任意。
#$cmd="";
$count=0;
open RC,"<$ARGV[0]"; @rc=<RC>; close RC;
for $line(@rc){
chomp $line;
my($k,$v)=split /\s*=\s*/,$line;
if($k eq ""){$count++; drawpng(); next;}
$hrc{$k}=$v;
}
#$cmd="habak -ms \'$hrc{bg}\'".$cmd;
#print "-----\n$cmd\n";
#`$cmd`;

Gtk2->init;
$screen=Gtk2::Gdk::Screen->get_default;
$window=$screen->get_root_window;
#$screen->broadcast_client_message(Gtk2::Gdk::Event->new("expose"));
#$window->signal_connect('expose_event', \&expose, $window);

$gc = Gtk2::Gdk::GC->new ($window, undef);
($real_drawable,$x_offset,$y_offset)=$window->get_internal_paint_info;
expose();
my $back_pixbuf =  Gtk2::Gdk::Pixbuf->new_from_file("/home/eexp/tt.png");
#Gtk2->main_iteration while Gtk2->events_pending;
Gtk2->main();
#Gtk2->main_iteration;

#------------------------------
sub expose {
for(keys %pics){
my $file="/tmp/countdown-$_.png";
my ($x,$y)=split ',',$pics{$_};
my $pixbuf=Gtk2::Gdk::Pixbuf->new_from_file($file);
my ($format,$width,$height)=$pixbuf->get_file_info($file);

$pixbuf->render_to_drawable($real_drawable,$gc,0,0,$x,$y,$width,$height,'normal',0,0);
}
}

sub drawpng()
{
while (my ($k,$v)=each %hrc){print "{$k}\t=> $v\n";}; print "\n";
my ($y,$m,$d)=split '-', $hrc{day};
$y-=1900;$m-=1; $epoch_day=mktime(0,0,0,$d,$m,$y);
$epoch_today=time();
$days=int(($epoch_day-$epoch_today)/86400+1);

$w0=(length($hrc{text})/3+5+2)*$hrc{size};
$w1=((length($days)+1)*2/3+1+1)*$hrc{size};
$w=$w0+$w1;
$rate=1.5;
$h=$hrc{size}*$rate;
$rate=($h+$hrc{size})/2-$hrc{size}/6;  #微调字体间隙。80点字体实际使用67点。
$surface = Cairo::ImageSurface->create ('argb32',$w,$h);
$cr = Cairo::Context->create ($surface);
$cr->set_line_width($h);
$cr->set_line_cap("round");
setcolor($hrc{cday});
$cr->move_to($h/2,$h/2);
$cr->line_to($w-$h,$h/2);
$cr->stroke;
setcolor($hrc{cend});
$cr->set_line_width($h*0.9);
$cr->move_to($w0,$h/2);
$cr->line_to($w-$h,$h/2);
$cr->stroke;

$cr->select_font_face("$hrc{font}",'normal','bold');
$cr->set_font_size($hrc{size});
$cr->set_operator("clear");
setcolor($hrc{ctext});
$cr->move_to($h/2,$rate);
$cr->show_text("距离".$hrc{text}."还有");
$cr->move_to($w0,$rate);
$cr->show_text("$days 天");

$surface->write_to_png ("/tmp/countdown-$count.png");
#$cmd.=" -mp $hrc{pos} -hi /tmp/countdown-$count.png";
$pics{$count}=$hrc{pos};
}

sub setcolor()
{
my $color=$_[0];
$color=~s/#//; my @C=map {$_/256} map {hex} $color=~/.{2}/g;
$cr->set_source_rgba($C[0],$C[1],$C[2],$C[3]);
}
