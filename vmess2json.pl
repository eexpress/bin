#!/usr/bin/perl

use 5.010;
use MIME::Base64;
use JSON;

$_=defined $ARGV[0]?$ARGV[0]:`xclip -o`;
s'^vmess://'';
$_=decode_base64($_);
say; say "==================";
$rh=decode_json($_);
if($rh->{"add"} eq ""){say "格式无效"; exit;}

# 输出成v2ray格式的json文件
$if='/home/eexpss/bin/config/proxy.config/Simple.vmess.json.Template';
open IN,"<$if" or die $!; $eof=$/; undef $/; $_=<IN>; $/=$eof; close IN;
s/xxxadd/$rh->{add}/; s/xxxport/$rh->{port}/;
s/xxxid/$rh->{id}/; s/xxxaid/$rh->{aid}/;
$f="$ENV{HOME}/vv-$rh->{ps}.json";
open OUT,">$f"; say $f;
print OUT $_; close OUT;
