#!/usr/bin/perl

# fedora 下需要 `sudo dnf install rpmdevtools perl-File-MimeInfo`
# ubuntu 下需要 `sudo apt install rpm libfile-mimeinfo-perl`
use 5.10.0;
use File::MimeInfo;	#需要安装 perl-File-MimeInfo(fedora) / libfile-mimeinfo-perl(ubuntu)
use File::Copy qw(copy cp);
use File::Path qw(make_path remove_tree);
no warnings 'experimental';

if(scalar @ARGV == 0){
	die '----------------------------
Input binary / picture / [desktop] file as parameter,
Version parameter can be "v0.2" or "v1".
Create rpm structrue directory for build rpm pacake.
Auto create ".spec" file, auto fill some fields.
If no desktop file, auto create and fill one.
----------------------------';
}
#~ ---------------------------------------------
my %rpm = ('BuildArch'=>'noarch', 'Release'=>'1%{?dist}', 'License'=>'GPLv3+', 'Source0'=>'%{name}-%{version}.tar.xz',
 'Requires'=>'<===== xxxx,xxxx','Summary'=>"<===== xxxxxxxxxxxxxxx", 'Version'=>"1.0");
#~ Group	软件类别	utils, net, mail, text, x11
my @bin, @img, @desktop;

my $arch = `arch`;	# 自动获取系统架构。
chomp $arch;
$rpm{'BuildArch'} = $arch;
#~ my $user = $ENV{'USER'};	# 自动填充维护者信息。
#~ $rpm{'Maintainer'} = $user." <$user\@gmail.com>";
my $git = `git remote -v`;	# 自动填写主页，需在 git 目录下。
$git =~ m'\s(.*@.*:.*/.*)\s*\(fetch\)';
my $repo = $1;
if($repo){
	$_ = $repo;
	s':'/'; s'^git@'https://';
	$rpm{'URL'} = $_;
}
#~ ---------------------------------------------
my $version = "-1.0";
for (@ARGV){
	if(/^v(\d[\.\d]{0,})/){	# 接受一个版本参数，v0.2 或者 v1 这样的。
		$rpm{'Version'} = $1;
		$version = "-$1";	# 版本号会附加到路径。
		next;
	}
	if(! -f) {next;}	# 其他参数只能是文件。
	my $file = $_;
	given (mimetype($file)) {	# 按文件类型放到对应目录
		when ("application/octet-stream") {	# 二进制文件。
			if(! -x $file){say "$file no excutable."; next;} # 可执行，才放入 bin 目录。
			push @bin, $file;
			if(! $rpm{'Name'}) {$rpm{'Name'} = $file;} #第一个可执行文件当作包名。
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
			if(! -x $file){say "$file mimetype ($_) not use."; next;}
			push @bin, $file;		# python 执行文件判断不出。
		}
	}
}
#~ $rpm{'Installed-Size'} = int($rpm{'Installed-Size'}/1024)." KB";	# 计算安装尺寸。
#~ ---------------------------------------------
if ($#bin < 0) {die "Need at last one binary excute file.";}
if ($#img < 0) {die "Need at last one image file.";}
my $path0 = "$ENV{HOME}/rpmbuild";
remove_tree($path0);
`rpmdev-setuptree`;	# 遵照 ~/.rpmmacros 设置，产生 rpmbuild 目录。
$path = "$path0/SOURCES";
make_path("$path/usr/bin", "$path/usr/share/applications", "$path/usr/share/pixmaps");
my $filelist = '';
for(@bin){cp $_, "$path/usr/bin/"; $filelist .= "%{_bindir}/$_\n";}
for(@desktop){cp $_, "$path/usr/share/applications/"; $filelist .= "%{_datadir}/applications/$_\n";}
for(@img){cp $_, "$path/usr/share/pixmaps/"; $filelist .= "%{_datadir}/pixmaps/$_\n";}
#~ ---------------------------------------------
my $desktop_msg = "";
if($#desktop < 0){	# 如果没有桌面文件，自动新建一个。
	my $dpath = "usr/share/applications/$bin[0].desktop";
	$desktop_msg = " and SOURCES/.../$bin[0].desktop";
	my $desktoptxt = "[Desktop Entry]
Type=Application
Terminal=false
Name=$bin[0]
Icon=$img[0]
Exec=$bin[0]";
	open FC, ">", "$path/$dpath";
	say FC $desktoptxt;
	close FC;
	$filelist .= "%{_datadir}/applications/$bin[0].desktop\n";
	system("xdg-open $path/$dpath");
}
#~ ---------------------------------------------
my $specfile = "$path0/SPECS/$rpm{'Name'}.spec";
save_spec();
system("xdg-open $specfile");
#~ ---------------------------------------------
say "==============================================";
my $tree = `tree $path0`;
chomp $tree;
say $tree;
say "==============================================";
say "Please confirm SPECS/$rpm{'Name'}.spec$desktop_msg. ";
say "==============================================";
say "After comfirm, you can excute `rpmbuild -bb ~/rpmbuild/SPECS/$rpm{'Name'}.spec ` will create rpm file:\n==>\t~/rpmbuild/RPMS/$arch/$rpm{'Name'}-$rpm{'Version'}-$rpm{'Release'}.rpm";

sub save_spec{
	my $control = '';	# 新建 control 文件。
	my @order = ('Name', 'Version',  'Release', 'Summary', 'BuildArch', 'License', 'URL', 'Source0', 'Requires', );
	for(@order){
		$field = sprintf("%-16s", "$_:");
		$control .= "$field $rpm{$_}\n";
	}
	chomp $control;
	my $other = "
%description
<===========xxxxxxxxxxxxx

%define _binaries_in_noarch_packages_terminate_build   0

%install
cd %{_sourcedir}
cp -ar * %{buildroot}/

%files
$filelist

	";
	open FC, ">", $specfile;
	say FC $control;
	say FC $other;
	close FC;
}
