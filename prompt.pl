#!/usr/bin/perl -C0
# `perldoc perlrun` #237行。-C是位标志格式。(LSB)(1)IOEioAL(64)。a=256。
# S=IOE(STD)，D=io(stream)。A=ARGV, L=LC_ALL，a=UTF8CACHE，0=PERL_UNICODE
# 实测，I=1，a，L, 0都能全正常。
# https://perldoc.perl.org/feature
use v5.30;	# unicode_strings say which implies "use strict;"

sub colorize_dir_path {
	my ($path) = @_;
	my $colored_path = "\e[0m";
	my @color_array = (22, 237, 94, 17, 52); # 绿 灰 黄 蓝 红
	my $index = 0;
	my $fgtext = "\e[38;5;246m";
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
	$colored_path .= "\e[38;5;0m◢\e[0m";	# 0xE0B0 no unicode
	return $colored_path;
}

# my $date = `date '+%w %T'`; chomp $date;
my @week = qw/⓿ ❶ ❷ ❸ ❹ ❺ ❻/;	# 0x24FF
my @info = localtime(time());
my $time = sprintf("%02s:%02s:%02s", $info[2], $info[1], $info[0]);
my $date = $week[$info[6]]."  ".$time;
my $path = "${date}/".$ARGV[0];
$path =~ s/$ENV{HOME}/~/;
$path =~ s/~/🏠/;
# git
my $stdout = `git status --porcelain 2>/dev/null`;
$path .= $stdout ? "/✘" : "/✔" if ($? >> 8 == 0);

my $colored_path = colorize_dir_path($path);
my $psch = ($ENV{'USER'} eq "root") ? "🔴" : "⭕";
$colored_path .= "\n${psch} ";
print $colored_path;
