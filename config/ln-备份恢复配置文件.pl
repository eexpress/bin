#!/usr/bin/perl -C0
use strict;
use warnings;
use v5.30;
use File::Basename;
use Cwd qw/getcwd/;

chdir(dirname($0)) or die "chdir error";	# 进入脚本所在的目录
if (@ARGV == 0) {
	say ('='x80);
	opendir(my $dh, ".") or die "opendir error";
	my @files_with_plus;

	while (readdir($dh)) {
		next if /^[^+]/;
		my $file = $_;
	    s|^\+|~/.|, s|\+|/|g, s|=|\\ |g;
	    push @files_with_plus, $_." -> ".$file;
	    say $_." -> ".$file;
	}
	closedir($dh);
	say ('-'x80);

	say "将家目录的这些配置文件，强制软链接到当前目录的这些备份文件？按 y 确认。";
	my $key = <STDIN>; chomp($key);
	if (lc($key) eq 'y'){
		say ('-'x80);
		foreach (@files_with_plus) {
			my @s = split / -> /, $_;
			$s[0] =~ s/^~/$ENV{'HOME'}/;	# 文件操作不认~号。
			unlink $s[0] or die "unlink error $s[0]";
			symlink(getcwd()."/".$s[1], $s[0]) or die "symlink error";
			$_ = `ls -l --color=always $s[0]`;
			s/.*:...//,s|$ENV{'HOME'}|~|g;
			print;
		}
		say ('='x80);
		exit;
	}
}
