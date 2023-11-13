#!/usr/bin/perl

#~ XXX.AppImage --appimage-extract 释放出内容到 squashfs-root 目录。包含 desktop 文件和图标。

use 5.10.0;
use File::MimeInfo;	#需要安装 perl-File-MimeInfo(fedora) / libfile-mimeinfo-perl(ubuntu)
#~ use File::Find;  
use Cwd qw(abs_path getcwd);  
use File::Copy;
use File::Path qw(rmtree);
use File::chmod qw(chmod);  # perl-File-chmod
use File::Basename; 
#~ use File::Readlink; # 废弃了，找不到库了。

if(scalar @ARGV == 0 or mimetype($ARGV[0]) ne "application/vnd.appimage"){
	die '-----------------------------------------------------
指定一个 AppImage 文件，读取内部的 desktop 文件和图标。
在 ~/.local/share/applications 下建立 desktop 文件。
在 ~/.local/share/icons 下建立图标文件。
---------';
}
chdir dirname($ARGV[0]);		# 进入工作目录
my $fn = basename($ARGV[0]);
my $fullname = abs_path($fn);	# AppImage 绝对路径
#~ say getcwd(); say $fullname; exit;
my $dir = 'squashfs-root';  # 临时目录  
# 释放包的内容
chmod(0755, $ARGV[0]); # 添加执行权限
my $r = system("./$fn --appimage-extract");	# 释放内容到 squashfs-root 目录。
die "解包失败。" if $r;
die "没有 $dir 目录。" if not -d $dir;
chdir $dir;
my @list = glob( '*.desktop');
my $desktop = $list[0];	# 获取第一个文件
die "没有找到desktop文件" if ! $desktop;
die "不是desktop文件类型的文件" if mimetype($desktop) != "application/x-desktop";
open(DATA,"<$desktop") or die "无法打开文件";
@lines = map{$_=~/X-AppImage/?():$_} <DATA>;	# 过滤掉 X-AppImage 的字段
close(DATA);

# 查找图标文件
(grep{/^Icon=/} @lines)[0]=~/^Icon=/;
my $icon = $';
chomp $icon; 
say "查找图标====>$icon";
#~ say "YES";
foreach(glob("$icon*")){
	if(-l $_){		# 居然有软链接的图标
		$_ = abs_path($_);
	}
	if(mimetype($_)=~m|^image/|){
		$ficon = basename($_);
		say "图标文件：$ENV{HOME}/.local/share/icons/$ficon 。";
		copy($_, "$ENV{HOME}/.local/share/icons/");
		#~ $icon = getcwd()."/".$_;
		last;
	}
};
chdir "..";		# 不退出目录，删除不了。
rmtree($dir);		# 删除临时目录
#~ exec("rm -r $dir");
# 只修改 Exec 这一行，建立桌面文件。
open(DATA,">$ENV{HOME}/.local/share/applications/$desktop") or die "无法打开文件";
foreach(@lines){
	if(/^Exec=/){$_="Exec=$fullname\n";}
	print DATA $_;
}
close(DATA);
say "桌面文件：$ENV{HOME}/.local/share/applications/$desktop 。";

exit;
