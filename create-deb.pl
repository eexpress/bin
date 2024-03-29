#!/usr/bin/perl

# fedora 下需要 `sudo dnf install dpkg perl-File-MimeInfo`
# ubuntu 下需要 `sudo apt install libfile-mimeinfo-perl`
use 5.10.0;
use File::MimeInfo;	#需要安装 perl-File-MimeInfo(fedora) / libfile-mimeinfo-perl(ubuntu)
use File::Copy qw(copy cp);
use File::Path qw(make_path remove_tree);
no warnings 'experimental';

if(scalar @ARGV == 0){
	die '----------------------------
Input binary / picture / [desktop] file as parameter,
Version parameter can be "v0.2" or "v1".
Create deb structrue directory for build deb pacake.
Auto create "control" file, auto fill some fields.
If no desktop file, auto create and fill one.
----------------------------';
}
#~ ---------------------------------------------
my %deb = ('Priority'=> 'optional|extra (<===== select only one)', 'Section'=> 'utils|web|net|misc|x11 (<===== select only one)',
 'Depends'=>'<===== xxxx,xxxx','Description'=>"<===== xxxx\n  <====xxxxxxxxxxxxxxx", 'Version'=>"1.0");
#~ Priority	软件对于系统的重要程度	required, standard, optional, extra等；
#~ Section	软件类别	utils, net, mail, text, x11
my @bin, @img, @desktop;

my $arch = `dpkg --print-architecture`;	# 自动获取系统架构。
chomp $arch;
$deb{'Architecture'} = $arch;
my $user = $ENV{'USER'};	# 自动填充维护者信息。
$deb{'Maintainer'} = $user." <$user\@gmail.com>";
my $git = `git remote -v`;	# 自动填写主页，需在 git 目录下。
$git =~ m'\s(.*@.*:.*/.*)\s*\(fetch\)';
my $repo = $1;
if($repo){
	$_ = $repo;
	s':'/'; s'^git@'https://';
	$deb{'Homepage'} = $_;
}
#~ ---------------------------------------------
my $version = "-1.0";
for (@ARGV){
	if(/^v(\d[\.\d]{0,})/){	# 接受一个版本参数，v0.2 或者 v1 这样的。
		$deb{'Version'} = $1;
		$version = "-$1";	# 版本号会附加到路径。
		next;
	}
	if(! -f) {next;}	# 其他参数只能是文件。
	#~ my @info = stat($_);	# 获取文件大小。
	#~ $deb{'Installed-Size'} += $info[7];	# 累加到安装尺寸。
	my $file = $_;
	given (mimetype($file)) {	# 按文件类型放到对应目录
		when ("application/octet-stream") {	# 二进制文件。
			if(! -x $file){say "$file no excutable."; next;} # 可执行，才放入 bin 目录。
			push @bin, $file;
			if(! $deb{'Package'}) {$deb{'Package'} = $file;} #第一个可执行文件当作包名。
		}
		when (m'^image/') {		# 图片文件。
			push @img, $file;
		}
		when ("application/x-desktop") {	# 桌面文件。
			push @desktop, $file;
		}
		when ("inode/symlink") {	# 不接受链接。
			say "$file symlink not allow.";
		}
		default {	# 无效类型。
			say "$file mimetype ($_) not use.";
		}
	}
}
#~ $deb{'Installed-Size'} = int($deb{'Installed-Size'}/1024)." KB";	# 计算安装尺寸。
#~ ---------------------------------------------
if ($#bin < 0) {die "Need at last one binary excute file.";}
if ($#img < 0) {die "Need at last one image file.";}
my $path = "/tmp/$deb{'Package'}$version";
remove_tree($path);
make_path("$path/DEBIAN", "$path/usr/bin", "$path/usr/share/applications", "$path/usr/share/pixmaps");
for(@bin){cp $_, "$path/usr/bin/";}
for(@desktop){cp $_, "$path/usr/share/applications/";}
for(@img){cp $_, "$path/usr/share/pixmaps/";}
#~ ---------------------------------------------
my $desktop_msg = "";
if($#desktop < 0){	# 如果没有桌面文件，自动新建一个。
	my $dpath = "usr/share/applications/$bin[0].desktop";
	$desktop_msg = " and $bin[0].desktop";
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
save_control();
$_ = `du -sh $path`; s/\s+.*$//; chomp;	# du的第一个结果数据。
$deb{'Installed-Size'} = $_;
`tar -Jcf tmp.xz $path 2>/dev/null`;
$_ = `du -sh tmp.xz`; s/\s+.*$//; chomp;	# du的第一个结果数据。
$deb{'Download-Size'} = $_;
save_control();
#~ ---------------------------------------------
system("xdg-open $path/DEBIAN/control");
#~ ---------------------------------------------
say "==============================================";
my $tree = `tree $path`;
chomp $tree;
say $tree;
say "==============================================";
say "Please confirm DEBIAN/control$desktop_msg. ";
say "==============================================";
say "After comfirm, you can excute `sudo dpkg -b $path` will create deb file:\n==>\t$path.deb";
`chmod +x $path/usr/bin/*`;	# 奇怪，cp过去，没执行属性了。

sub save_control{
	my $control = '';	# 新建 control 文件。
	my @order = ('Package', 'Version', 'Priority', 'Section', 'Maintainer', 'Installed-Size',
	'Download-Size', 'Homepage', 'Architecture', 'Depends', 'Description');
	for(@order){
		$field = sprintf("%-14s", $_);
		$control .= "$field : $deb{$_}\n";
	}
	chomp $control;
	open FC, ">", "$path/DEBIAN/control";
	say FC $control;
	close FC;
}
