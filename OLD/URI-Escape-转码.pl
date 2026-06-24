#!/usr/bin/perl

use URI::Escape;
$_=$ARGV[0];
if(/%..?%../){		# %E7%BF%BB%E8%AD%AF%E6%AA%94
print uri_unescape($_);
}else{
print uri_escape($_);
}
