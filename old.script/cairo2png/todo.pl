#!/usr/bin/perl

#导出opera的todo列表
open(REC,"$ENV{HOME}/.opera/notes.adr");
while(<REC>){last if /todo/;}
close REC;
chomp;
s/\x02+/\n/g; s/NAME=.*//; s/\x09\n//g; s/^\s*$//g;
s:(\n|^)\*(.*):$1<span color='#4746D8'>$2</span>:g;
print;

