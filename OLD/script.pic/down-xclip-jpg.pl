#!/usr/bin/perl

$_="$ENV{HOME}/下载/xclip-pic";
mkdir "$_" if ! -f; 
chdir "$_";

@l=`xclip -o`;
@l=map {/http:\/\/.*\.jpg/; $_=$&} @l;
foreach (@l){
print "\e[31m\e[1m=>\t".$_."\e[0m\n";
`wget -c "$_"`;
#`axel "$_"`;
}

