#!/usr/bin/perl

use X11::Aosd ':all';
use Glib qw/TRUE FALSE/;

my $fonth=150;
my $step=10;
my $cnt=0;
$font="Vera Sans YuanTi";
my $margin=30;
my $str=$ARGV[0];
my $color="200,200,200,250";
my $colorbg="200,100,0,80";
my $delay=3000;
#my $w=length($str)*$fonth/3+$margin*3;
#my $h=$fonth*1.5;
my $w=100;
my $h=100;

my $aosd = X11::Aosd->new;
$aosd->set_transparency(TRANSPARENCY_COMPOSITE);
$aosd->set_position_with_offset(
COORDINATE_CENTER,
COORDINATE_CENTER,
$w, $h, 0, 0
);
#---------------------------------------
print "==$w x $h\n";
$aosd->set_renderer(sub{
my ($cr) = @_;
$cr->select_font_face("$font",'normal','bold');
$cr->set_font_size($fonth);
$extents=$cr->text_extents($str);
$w=$extents->{width}+2*$margin;$h=$extents->{height}+2*$margin;
print $extents->{width}."x".$extents->{height}."\n";
});
$aosd->show;
$aosd->set_position_with_offset(
COORDINATE_CENTER,
COORDINATE_CENTER,
$w, $h, 0, 0
);
print "===$w x $h\n";
#---------------------------------------
my $loop = Glib::MainLoop->new;
Glib::Timeout->add (50, \&on_timeout);
$loop->run;

$aosd->loop_for($delay);
#$aosd->flash(0, $delay, $1000);
print "END\n";

sub draw{
$aosd->set_renderer(sub {
my ($cr) = @_;
my ($R,$G,$B,$A)=split ',',$colorbg;
$cr->set_source_rgba($R/256,$G/256,$B/256,$A/256);
#$cr->set_source_rgba (1, 0.5, 0, 0.5);
$cr->rectangle (0,0,$w*$cnt/$step, $h*$cnt/$step);
$cr->fill;
if($cnt<$step){return;}
$cr->select_font_face("$font",'normal','bold');
$cr->set_font_size($fonth);
$extents=$cr->text_extents($str);
print $extents->{width}."x".$extents->{height}."\n";
$cr->set_source_rgba(0,0,0,1);
$cr->move_to($margin+1,$h/2+$margin+1);
$cr->show_text("$str");
($R,$G,$B,$A)=split ',',$color;
$cr->set_source_rgba($R/256,$G/256,$B/256,$A/256);
$cr->move_to($margin,$h/2+$margin);
$cr->show_text("$str");
});
$aosd->show;
}

sub on_timeout{
draw();
$aosd->update;
$cnt++;
if ($cnt<=$step){TRUE;}else{FALSE;$loop->quit;}
}
