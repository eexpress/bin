#!/usr/bin/perl

#ss://base64(method:password@server:port)#remarks
use 5.010;
use JSON;
use MIME::Base64;

open IN,"<$ARGV[0]" or die "打开文件失败。";
$json=decode_json join "\n",<IN>;
close IN;
#use Data::Dumper; printf Dumper($json)."\n"; say "============";
die "没有服务器设置。" if ! $json->{server} or ! $json->{server_port};
$_=$json->{method}.":".$json->{password}."@".$json->{server}.":".$json->{server_port};
say;
$_=encode_base64 "$_";
s/\n//g;
#chomp; say;
$m=$json->{remarks};
if(! $m){
$m=$ARGV[0]; $m=~s'.*/''; $m=~s'\..*'';
}
$_="ss://".$_."#".$m;
say "=========================================";
say;
