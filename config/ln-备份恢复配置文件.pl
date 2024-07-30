#!/usr/bin/perl
use strict;
use warnings;
use v5.30;
use File::Basename;
use Cwd qw/getcwd/;

# 获取当前脚本所在的目录
chdir(dirname($0)) or die "chdir error";
if (@ARGV == 0) {
	opendir(my $dh, ".") or die "opendir error";
	my @files_with_plus;

	while (readdir($dh)) {
		next if /^[^+]/;
		my $file = $_;
	    s|^\+|~/.|, s|\+|/|g, s|=|\\ |g;
	    push @files_with_plus, $_." -> ".$file;
	}
	closedir($dh);

	say ('='x70);
	foreach (@files_with_plus) { say; }
	say ('-'x70);
	say "将家目录的这些文件强制链接到备份文件？按y确认。";
	my $key = <STDIN>; chomp($key);
	if (lc($key) eq 'y'){
		say ('-'x70);
		foreach (@files_with_plus) {
			my @s = split / -> /, $_;
			$s[0] =~ s/^~/$ENV{'HOME'}/;
			unlink $s[0] or die "unlink error $s[0]";
			symlink(getcwd()."/".$s[1], $s[0]) or die "symlink error";
			$_ = `ls -l --color=always $s[0]`;
			s/.*:...//,s|$ENV{'HOME'}|~|g;
			print;
		}
		say ('='x70);
		exit;
	}
}
