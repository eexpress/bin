#!/usr/bin/perl -C0
use strict;
use warnings;
use v5.30;
use File::Basename qw/dirname/;
use Cwd qw/getcwd/;

my @files_with_plus;	# orginal_file -> git_file
# ----------------------------------------------------
sub create_link {	# 参数：msg, restore(bool)
	say ('-'x80);
	exit if !@files_with_plus;
	say shift;
	my $key = <STDIN>; chomp($key);
	if (lc($key) ne 'y'){exit;}
	say ('-'x80);
	my $restore = shift;
	foreach (@files_with_plus) {
		my @s = split / -> /, $_;
		$s[0] =~ s/^~/$ENV{'HOME'}/;	# 文件操作不认~号。
		if($restore){
			unlink $s[0];	# 文件不存在，也不管。
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
	foreach (glob('+*')) {
		my $git_file = $_;
	    s|^\+|~/.|, s|\+|/|g, s|=|\\ |g;
	    push @files_with_plus, $_." -> ".$git_file;
	    say $_." -> "."\e[32m".$git_file."\e[0m";
	}
	create_link("将家目录的配置文件，强制软链接到当前目录的这些备份文件？按 y 确认。", 1);
}
# ====================备份到git目录====================
foreach (@ARGV) {
	if (m|^[^/]|)	{ say "不支持相对路径：$_"; next; }
	if (-l)			{ say "源文件不能是链接：$_"; next; }
	if (! -e)		{ say "源文件不存在：$_"; next; }
	my $cfg_file = $_;
	$cfg_file =~ s|^$ENV{'HOME'}|~|;
	s|^$ENV{'HOME'}/.|+|; s|/|+|g; s|\ |=|g;
	push @files_with_plus, $cfg_file." -> ".$_;
	say "\e[32m".$cfg_file."\e[0m"." -> ".$_;
}
create_link("将家目录的配置文件，备份到当前目录，并在原位置创建软链接？按 y 确认。", 0);
# ========================================================
