#!/usr/bin/perl

use 5.10.0;
use File::Type;	# libfile-type-perl
use File::Copy qw(copy cp);

if(scalar @ARGV == 0){
	die "Input binary file, picture, desktop file as parameter, to Create deb structrue directory for build deb pacake.";
}

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

for (@ARGV){
	if(! -f) {next;}
	my @info = stat($_);
	$deb{'Installed-Size'} += $info[7];
	my $file = $_;
	given (File::Type->mime_type($file)) {
		when ("application/x-executable-file") {
			push @bin, $file;
			if($deb{'Package'} eq "xxx") {$deb{'Package'} = $file;} #第一个可执行文件当作包名
		}
		when (m'^image/') {
			push @img, $file;
		}
		when ("application/octet-stream") {
			push @desktop, $file;
		}
	}
}
say "----------------------------";
my $control = '';
$deb{'Installed-Size'} = int($deb{'Installed-Size'}/1024)." KB";
foreach $key (keys %deb){
	say $key.": ".$deb{$key};
	$control .= $key.": ".$deb{$key}."\n";
}
say "----------------------------";
my $path = "/tmp/$deb{'Package'}";
mkdir $path;
mkdir "$path/DEBIAN";
mkdir "$path/usr";
mkdir "$path/usr/bin";
for(@bin){cp $_, "$path/usr/bin/";}
mkdir "$path/usr/share";
mkdir "$path/usr/share/applications";
for(@desktop){cp $_, "$path/usr/share/applications/";}
mkdir "$path/usr/share/pixmaps";
for(@img){cp $_, "$path/usr/share/pixmaps/";}
open FC, ">", "$path/DEBIAN/control";
say FC $control;
close FC;
system("xdg-open $path/DEBIAN/control");
if(scalar @desktop == 0){
	my $desktoptxt = "
[Desktop Entry]
Type=Application
Terminal=false
Name=$bin[0]
Icon=$img[0]
Exec=$bin[0]
	";
	open FC, ">", "$path/usr/share/applications/$bin[0].desktop";
	say FC $desktoptxt;
	close FC;
	system("xdg-open $path/usr/share/applications/$bin[0].desktop");
}

my $tree = `tree $path`;
say $tree;
say "==============================";
say "Confirm DEBIAN/control and usr/share/applications/$bin[0].desktop.";
say "Excute `sudo dpkg -b $path`.";
