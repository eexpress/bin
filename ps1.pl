#!/usr/bin/perl
use strict;
use warnings;

sub colorize_dir_path {
    my ($path) = $ENV{PWD};
    $path =~ s|$ENV{HOME}|~|;
    
    my @color_array = (18, 242, 22, 202);
    my $index = 0;
    my @dirs = split '/', $path;
    my $colored_path = '';

    foreach my $dir (@dirs) {
        next if $dir eq ''; # Skip empty entries
        my $color = $color_array[$index];
        $index = ($index + 1) % scalar(@color_array); # Cycle through colors
        
        # Apply color escape sequence and append directory to $colored_path
        $colored_path .= "\e[48;5;${color}m ${dir} ";
    }

    print "\e[37m$colored_path\e[0m\n"; # White foreground
}

# Example usage:
colorize_dir_path();
