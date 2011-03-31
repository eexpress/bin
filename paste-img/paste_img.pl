#!/usr/bin/perl

use utf8;	# 文件路径才可以使用中文。
use Gtk2 -init;
use Gtk2::GladeXML;
use File::Basename qw/basename dirname/;
use Encode;
$user=`id -un`; chomp $user;
#----------------------------------
chdir dirname (-l $0?readlink $0:$0);
$app="paste_img"; $cli="pasteimg.pl";
my $gui = Gtk2::GladeXML->new("$app.glade");
$gui->signal_autoconnect_from_package('main');
#----------------------------------
#$select="imagebin";
$box2 = $gui->get_widget('vbox2');
$button = Gtk2::RadioButton->new(undef, "null");
@group = $button->get_group;
@web=`./$cli -l`;
foreach (@web){
chomp;
s/\s.*$//,$select=$_ if /\*/;
$button = Gtk2::RadioButton->new_with_label(@group, "$_");
$button->signal_connect('toggled'=>\&radio_clicked);
$button->set_active(TRUE) if /$select/;
$box2->pack_start($button, TRUE, TRUE, 0);
$button->show;
print "...$_...\n";
}
#----------------------------------
$ff=Gtk2::FileFilter->new();
$ff->add_mime_type("image/png");
$ff->add_mime_type("image/jpeg");
#$ff->add_pattern("*.png");
$gui->get_widget('filechooserbutton2')->add_filter($ff);
$gui->get_widget('filechooserbutton2')->set_filename("$app.png");
#----------------------------------
$gui->get_widget('preview')->drag_dest_set('all', ["link","ask"], {target=>'STRING', flags=>['other-app','other-widget'], info=>0});
Gtk2->main;

#========================子程序============================
sub on_preview_drag_data_received{
        my ($tolist, $context, $x, $y, $data, $info, $time, $fromlist) = @_;
	use URI::Escape;
	$_=$data->get_text(); chomp; 
	print "drag:$_\n";
	$_=uri_unescape($_); 
	s'^file://'';
	$_=decode("utf8",$_);
	print "$_\n";
	$gui->get_widget('filechooserbutton2')->set_filename($_);
	print $gui->get_widget('filechooserbutton2')->get_filename();
#nautilus' String
#file:///home/exp/%E4%B8%8B%E8%BD%BD/d70b644df40e4a68da6eaeef49dcf469.jpg
#file:///home/exp/%E4%B8%8B%E8%BD%BD/2010-09-25-15:44:34.png
#rox no String
	$context->finish(1, 0, $time);
	return 0;
}
#----------------------------------
sub radio_clicked{
$_=shift;
$select=$_->get_label;
}
#----------------------------------
sub on_mainwindow_destroy{
Gtk2->main_quit;
}
#----------------------------------
sub on_filechooserbutton2_selection_changed{
$gui->get_widget('preview')->set_from_file($gui->get_widget('filechooserbutton2')->get_filename());
}
#----------------------------------
sub on_bpaste_clicked{
my $pic=$gui->get_widget('filechooserbutton2')->get_filename();
$pic=encode("utf8",$pic);
print "./$cli -s $select -n $user $pic\n";
my @re=`./$cli -s $select -n $user $pic`;
@re=grep /Paste URL/,@re;
$_=$re[0];
$gui->get_widget('statusbar1')->push(0,"$_");
}
