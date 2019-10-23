#!/usr/bin/perl

use 5.010;

$url="http://icanhazip.com/";
#$url="http://ifconfig.me/ip";

#-------------------
print "LWP::Simple:\t\t";
use LWP::Simple;
$content = get($url);
if(defined $content){say $content;}else{say "failure.";}
#-------------------
print "LWP::UserAgent:\t\t";
use LWP::UserAgent;
$ua = LWP::UserAgent->new( agent => 'Mozilla/5.0 (X11; Fedora; Linux x86_64; rv:69.0) Gecko/20100101 Firefox/69.0', timeout => 20,);
$response = $ua->get($url);
if ($response->is_success){say $response->decoded_content;}else{say "failure.";}
