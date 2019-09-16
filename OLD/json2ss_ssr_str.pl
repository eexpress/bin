#!/usr/bin/perl

#ss://base64(method:password@server:port)#remarks
#ssr://base64(server:port:protocol:method:obfs:password/?remarks=base64(remarks))

use 5.010;
use JSON;
use MIME::Base64;

open IN,"<$ARGV[0]" or die "打开文件失败。";
$json=decode_json join "\n",<IN>;
close IN;
#use Data::Dumper; printf Dumper($json)."\n"; say "============";
die "没有服务器设置。" if ! $json->{server} or ! $json->{server_port};
$m=$json->{remarks};
if(! $m){
$m=$ARGV[0]; $m=~s'.*/''; $m=~s'\..*'';
}
if($json->{protocol}){	#============SSR============
	$m=encode_base64 "$m"; $m=~s/\n//g;
	$_=join ":",$json->{server},$json->{server_port},$json->{protocol},$json->{method},$json->{obfs},$json->{password};
	$_.="/?remarks=".$m;
	$_=encode_base64 "$_"; s/\n//g;
	$_="ssr://".$_;
}else{	#============SS============
	$_=$json->{method}.":".$json->{password}."@".$json->{server}.":".$json->{server_port};
	say;
	$_=encode_base64 "$_"; s/\n//g;
	#chomp; say;
	$_="ss://".$_."#".$m;
}
say "=========================================";
say;
