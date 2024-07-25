#!/usr/bin/perl
use strict;
use warnings;
use utf8;

sub colorize_dir_path {
    my ($path) = @_;
    my $colored_path = "\e[0m";
    my @color_array = (27, 130, 28, 133);
    my $index = 0;
    my $fgtext = "\e[38;5;255m";
	my $color = "";
    my @parts = split('/', $path);
    foreach my $i (@parts) {
        next if $i eq '';

        $color = $color_array[$index];
        $index = ($index + 1) % scalar(@color_array);
# 前景循环色+ ◢+ 背景循环色+ 前景灰色+ 一段路径文字
        $colored_path .= "\e[38;5;${color}m\x{25E2}\e[48;5;${color}m${fgtext} $i ";
    }
# 无颜色+ 前景最后循环色+ 箭头+ 无色
    $colored_path .= "\e[0m\e[38;5;${color}m\x{E0B0}\e[0m";
    return $colored_path;
}

my $path = $ARGV[0];
# git
my ($stdout, $stderr, $exit_code) = system('git status --porcelain');
if ($exit_code == 0) {
	if ($stdout eq '') {
	    $path .= "/✔";
	} else {
	    $path .= "/✗";
	}
}

my $colored_path = colorize_dir_path($path);
my $psch = "⭕";
if ($ENV{'USER'} eq "root") {$psch = "🔴";}
$colored_path .= "\n${psch} ";
print $colored_path;
