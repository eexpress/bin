#!/usr/bin/perl -C0
use strict;
use warnings;
use v5.30;
use File::Basename;
use Cwd qw/getcwd/;

my @files_with_plus;	# orginal_file -> git_file
# ----------------------------------------------------
sub create_link {	# 参数：msg, restore(bool)
	exit if !@files_with_plus;
	say ('-'x80);
	say shift;
	my $key = <STDIN>; chomp($key);
	if (lc($key) ne 'y'){exit;}
	say ('-'x80);
	my $restore = shift;
	foreach (@files_with_plus) {
		my @s = split / -> /, $_;
		$s[0] =~ s/^~/$ENV{'HOME'}/;	# 文件操作不认~号。
		if($restore){
			unlink $s[0] or die "unlink error $s[0]";
		} else {
			rename($s[0], $s[1]) or die "rename error $s[0]";
		}
		symlink(getcwd()."/".$s[1], $s[0]) or die "symlink error";
		$_ = `ls -l --color=always $s[0]`;	# 用 ls -l 验证结果
		s/.*:...//,s|$ENV{'HOME'}|~|g; print;
	}
	say ('='x80); exit;
}
# ----------------------------------------------------
chdir(dirname($0)) or die "chdir error";	# 进入脚本所在的目录
say ('='x80);
# ====================恢复到家目录====================
if (@ARGV == 0) {
	opendir(my $dh, ".") or die "opendir error";

	while (readdir($dh)) {
		next if /^[^+]/;
		my $git_file = $_;
	    s|^\+|~/.|, s|\+|/|g, s|=|\\ |g;
	    push @files_with_plus, $_." -> ".$git_file;
	    say $_." -> ".$git_file;
	}
	closedir($dh);
	create_link("将家目录的配置文件，强制软链接到当前目录的这些备份文件？按 y 确认。", 1);
}
# ====================备份到git目录====================
foreach (@ARGV) {
	next if m|^[^/]|;		# 参数只认绝对路径，shell会扩展~为绝对路径。
	if (-e $_ && ! -l $_){	# 跳过链接文件
		my $file = $_;
		$file =~ s|^$ENV{'HOME'}|~|;
		s|^$ENV{'HOME'}/.|+|; s|/|+|g; s|\ |=|g;
		push @files_with_plus, $file." -> ".$_;
		say $file." -> ".$_;
	}
}
create_link("将家目录的配置文件，备份到当前目录，并在原位置创建软链接？按 y 确认。", 0);
# ========================================================
