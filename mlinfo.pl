#!/usr/bin/perl

use Encode qw(_utf8_on _utf8_off);

$_=`pgrep mlnet`; 
if($_){
@_=`echo vd | nc -q 1 localhost 4000`;
$out="";
for(@_){
if(/Down:/){s/Down/下载/;s/ Up/上传/;s/ Shared.*//;
s/\|/ /g;$out.=$_;}
if(/\[[DBT]/){
s/.*mldonkey //; s/\ {2,}/\t/g; s/\ /-/g; s/^\[.*?\]//g;
@i=split /\t/;
_utf8_on($i[0]);
$n=substr($i[0],0,16);
_utf8_off($n);
$n=sprintf "%-22s",$n;
$out.="$n\t\t$i[1]%\n";
}
}
}else{$out="server not run..."}
print $out;
`notify-send -i /usr/share/pixmaps/mlnet.xpm 'MlDonkey Info:' '$out'`;
