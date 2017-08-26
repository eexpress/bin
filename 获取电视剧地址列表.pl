#!/usr/bin/perl

use utf8;
use LWP::Simple;
binmode STDOUT, ":utf8";

$url=shift;
#$url='http://www.iqiyi.com/a_19rrhaamkl.html?vfm=2008_aldbd';
@_=split /\n/, get($url);
#$in=shift; open IN,"$in"; @_=<IN>; close IN;
$n=0;
@i=map {/href="(.*?)" title="(.*?)"/; $n++; $_="$n $2 $1\n"} grep /class="site-piclist_pic_link" href="http.*title=/, @_;
print @i;
