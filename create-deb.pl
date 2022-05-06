#!/usr/bin/perl

use 5.10.0;
use File::MimeInfo;
use File::Copy qw(copy cp);
use File::Path qw(make_path remove_tree);
no warnings 'experimental';

if(scalar @ARGV == 0){
	die "Input binary file, picture, desktop file as parameter, to Create deb structrue directory for build deb pacake.
One none file version parameter can be v0.2 or v1.
	";
}
#~ ---------------------------------------------
my %deb = ('Package' =>'xxx', 'Version'=>'0.1', 'Priority'=> 'optional|extra',
'Section'=> 'utils|web|net|misc|x11',
'Maintainer'=> 'eexpss <eexpss@gmail.com>', 'Homepage'=>'',
'Description'=>'', 'Depends'=>'', 'Installed-Size'=>0, 'Download-Size'=>0);
my @bin, @img, @desktop;

my $arch = `dpkg --print-architecture`;
chomp $arch;
$deb{'Architecture'} = $arch;
my $user = $ENV{'USER'};
$deb{'Maintainer'} = $user." <$user\@gmail.com>";
my $git = `git remote -v`;
$git =~ m'\s(.*@.*:.*/.*)\s*\(fetch\)';
my $repo = $1;
if($repo){
	$_ = $repo;
	s':'/'; s'^git@'https://';
	$deb{'Homepage'} = $_;
}
#~ ---------------------------------------------
say "==============================================";
for (@ARGV){
	if(/^v(\d[\.\d]{0,})/){	#接受一个版本参数，v0.2 或者 v1 这样的。
		$deb{'Version'} = $1;
		next;
	}
	if(! -f) {next;}
	my @info = stat($_);
	$deb{'Installed-Size'} += $info[7];
	my $file = $_;
	given (mimetype($file)) {
		when ("application/octet-stream") {
			if(! -x $file){say "$file no excutable."; next;}
			push @bin, $file;
			if($deb{'Package'} eq "xxx") {$deb{'Package'} = $file;} #第一个可执行文件当作包名
		}
		when (m'^image/') {
			push @img, $file;
		}
		when ("application/x-desktop") {
			push @desktop, $file;
		}
		when ("inode/symlink") {
			say "$file symlink not allow.";
		}
		default {
			say "$file mimetype ($_) not use.";
		}
	}
}
$deb{'Installed-Size'} = int($deb{'Installed-Size'}/1024)." KB";
#~ ---------------------------------------------
my $path = "/tmp/$deb{'Package'}-$deb{'Version'}";
remove_tree($path);
make_path("$path/DEBIAN", "$path/usr/bin", "$path/usr/share/applications", "$path/usr/share/pixmaps");
for(@bin){cp $_, "$path/usr/bin/";}
for(@desktop){cp $_, "$path/usr/share/applications/";}
for(@img){cp $_, "$path/usr/share/pixmaps/";}
#~ ---------------------------------------------
my $control = '';
my @order = ('Package', 'Version', 'Priority', 'Section', 'Maintainer', 'Installed-Size',
'Download-Size', 'Homepage', 'Architecture', 'Depends', 'Description');
for(@order){
	$control .= "$_ : $deb{$_}\n";
}
chomp $control;
open FC, ">", "$path/DEBIAN/control";
say FC $control;
close FC;
system("xdg-open $path/DEBIAN/control");
#~ ---------------------------------------------
my $desktop_msg = "";
if(scalar @desktop == 0){
	my $dpath = "usr/share/applications/$bin[0].desktop";
	$desktop_msg = " and $dpath.";
	my $desktoptxt = "[Desktop Entry]
Type=Application
Terminal=false
Name=$bin[0]
Icon=$img[0]
Exec=$bin[0]";
	open FC, ">", "$path/$dpath";
	say FC $desktoptxt;
	close FC;
	system("xdg-open $path/$dpath");
}
#~ ---------------------------------------------
say "==============================================";
my $tree = `tree $path`;
chomp $tree;
say $tree;
say "==============================================";
say "Confirm DEBIAN/control$desktop_msg.";
say "Excute `sudo dpkg -b $path`.";
