#!/usr/bin/perl

@_=map {chomp; "\'$_\'";} <>;
$_=join " ",@_;
print ;
`feh -t $_`;

