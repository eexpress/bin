#!/usr/bin/perl

use Gtk2 "-init"; 
use Encode;
$SIG{CHLD} = 'IGNORE';
$last="";
my $clip = Gtk2::Clipboard -> get(Gtk2::Gdk::Atom -> intern("PRIMARY", 0));
$clip -> signal_connect("owner-change" => \&deal);

Gtk2 -> main;
exit 0;

#----------------------------------
sub deal{
$_= $clip -> wait_for_text,"primary";
@url=m"http://[^\s]*"g;
if($#url<0){print "none url
";return 1;}
foreach(@url){
my $t;
s/\W+$//;
next if $last eq $_;
$last=$_;
#----------------------------------
if(/v.youku.com/ || /tudou.com\/playlist/ || /v.ku6.com/ || /6.cn\/watch/ || /tv.sohu.com/){
   $t="下载flash资源";
   if(fork()==0){`xterm -e ~/bin/flash-down.pl $_`;exit;}
}
if(m"http://u.115.com/file/\w+"){
   $t="下载115资源";
   if(fork()==0){`xterm -e ~/bin/115_client $&`;exit;}
}
if(/rapidshare.com/ || /hotfile.com.*html/){
   $t="保存slimrat资源";
   if(fork()==0){`xterm -e ~/bin/slimrat $_`;exit;}
}
#----------------------------------
if($t){
print "$t ===> $_
";
$t=decode("utf8",$t);
`$ENV{HOME}/bin/msg elvis.png  $t $&`;
} else {print "unrecognized url
"; return 1;}
}
}

