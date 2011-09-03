#!/usr/bin/perl

use Cairo;
use POSIX qw(mktime);

open RC,"<$ARGV[0]"; @rc=grep ! /^\s*#/ && ! /^\s*$/,<RC>; close RC;
%hrc=map{split /\s*=/} @rc;
chomp %hrc;
while (my ($k,$v)=each %hrc){print "{$k}\t=> $v\n";}

my ($y,$m,$d)=split '-', $hrc{day};
$y-=1900;$m-=1; $epoch_day=mktime(0,0,0,$d,$m,$y);
$epoch_today=time();
$days=int(($epoch_day-$epoch_today)/86400+1);

$w=(length($hrc{text})/3*2+6+length($days))*$hrc{size};
$h=$hrc{size}*1.6;
$surface = Cairo::ImageSurface->create ('argb32',$w,$h);
$cr = Cairo::Context->create ($surface);
$cr->set_line_width($h);
$cr->set_line_cap("round");
setcolor($hrc{cday});
$cr->move_to($h/2,$h/2);
$cr->line_to($w-$h*0.5,$h/2);
$cr->stroke;
setcolor($hrc{cend});
$cr->set_line_width($h*0.9);
$cr->move_to($w-$h*3,$h/2);
$cr->line_to($w-$h*0.5,$h/2);
$cr->stroke;

$cr->select_font_face("$hrc{font}",'normal','bold');
$cr->set_font_size($hrc{size});
$cr->set_operator("clear");
setcolor($hrc{ctext});
$cr->move_to($h/2,$h*0.7);
$cr->show_text("距离".$hrc{text}."还有");
$cr->move_to($w-$h*2.6,$h*0.7);
$cr->show_text("$days 天");

$surface->write_to_png ("/tmp/countdown.png");

`habak -ms '/home/eexp/图片/壁纸/木纹ubuntu.jpg' -mp $hrc{pos} -hi /tmp/countdown.png`;

sub setcolor()
{
my $color=$_[0];
$color=~s/#//; my @C=map {$_/256} map {hex} $color=~/.{2}/g;
$cr->set_source_rgba($C[0],$C[1],$C[2],$C[3]);
}
