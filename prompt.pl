#!/usr/bin/perl
use strict;
use warnings;
use Encode qw/decode/;		# @ARGV
use utf8;					# unicode in script
binmode STDOUT, ":utf8";	# Wide character in print

sub colorize_dir_path {
	my ($path) = @_;
	my $colored_path = "\e[0m";
	my @color_array = (22, 94, 18, 238, 52); # 绿 橙 蓝 灰 红
	my $index = 0;
	my $fgtext = "\e[38;5;255m";
	my $color = "";
	my @parts = split('/', $path);
	foreach my $i (@parts) {
		next if $i eq '';
		$color = $color_array[$index];
		$color = 22 if ($i eq "✔");	# 绿
		$color = 52 if ($i eq "✘");	# 红
		$index = ($index + 1) % scalar(@color_array);
		# 前景循环色+ ◢+ 背景循环色+ 前景灰色+ 一段路径文字
		$colored_path .= "\e[38;5;${color}m◢\e[48;5;${color}m${fgtext} $i ";
	}
	# 无颜色+ 前景最后循环色+ 箭头+ 无色
	$colored_path .= "\e[0m\e[38;5;${color}m\e[0m";
	return $colored_path;
}

my $date = `date '+%a %T'`;
chomp $date;
my $path = "${date}/".decode('UTF-8', $ARGV[0]);
$path =~ s/$ENV{HOME}/~/;
# git
my $stdout = `git status --porcelain 2>/dev/null`;
$path .= $stdout ? "/✘" : "/✔" if ($? >> 8 == 0);

my $colored_path = colorize_dir_path($path);
my $psch = ($ENV{'USER'} eq "root") ? "🔴" : "⭕";
$colored_path .= "\n${psch} ";
print $colored_path;
