#!/usr/bin/perl

$web="http://is.gd/";
#$web="http://tinyurl.com/";
$_=shift;
use WWW::Mechanize;
my $mech = WWW::Mechanize->new();
$mech -> get($web);
$mech -> submit_form(with_fields => {"url"=>$_});
if ($mech->success()) {
	$_=$mech->content();
	/($web[0-9a-zA-Z]{3,})"/os;
	print $1;
}
