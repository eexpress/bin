#!/usr/bin/perl

#----------------------
my $select="tinyurl";
my %web=(
	"to"=>{"url"=>"http://to/","cmd"=>'/value=".*?"/;$_=$&; s/value="//; s/"//;'},
	"tinyurl"=>{"url"=>"http://tinyurl.com/","cmd"=>'/^copy\(\'(.*)\'\);/m; $_=$1;'},
);
#----------------------
$_=$ARGV[0];
s{(?<=^http:/)(?!/)}{/};
use WWW::Mechanize;
my $mech = WWW::Mechanize->new();
$mech -> get($web{$select}{url});
$mech -> submit_form(with_fields => {"url"=>$_} );
#----------------------
if ($mech->success()) {
$_=$mech->content();
eval $web{$select}{cmd};
print "=====> \e\[31m$_\e\[0m\n";
#复制结果到鼠标中键。
`echo $_|xclip -i`;
`aplay /home/exp/媒体/事件声音-et/weapon_pkup.wav 2>/dev/null`;
}

