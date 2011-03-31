#!/usr/bin/perl

$logf="$ENV{HOME}/bin/resources/weather.log";
$conkyf="$ENV{HOME}/bin/conky/weather.txt";
$term_color_cmd='s/^>/\e[1;33m/;s/^ /\e[0m/;s/^-/\e[32m/;';
$conky_cmd='s/°C\t.*/°C/g; s/20..-//g; s/^>\t/\${color1}/; s/^\ \t/\${color}/; s/^-\t/\${color3}/; s/\t(?=\d)/\${alignr}/;';
if(open(REC,$logf)){
@_=<REC>; close REC;
	@conky=@_;
	for (@_){ eval $term_color_cmd; print; }
	open RECC,">$conkyf";
	for (@conky){ eval $conky_cmd; print RECC; } close RECC;
}

