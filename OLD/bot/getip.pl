#!/usr/bin/perl

use Encode;
$web="http://www.ip138.com/";
$_=shift;
use WWW::Mechanize;
my $mech = WWW::Mechanize->new();
$mech -> get($web);
$mech -> submit_form(with_fields => {"ip"=>$_});
if ($mech->success()) {
	$_=$mech->content();	#内容是字节流
	$_=encode("UTF-8", $_);
	/本站主数据：(.*?)</os;
	print $1;
}
