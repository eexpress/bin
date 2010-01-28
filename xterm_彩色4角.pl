#!/usr/bin/perl

$ps=`/bin/ps -e -o command|grep xterm`;
$geometry=join ",",$ps=~/[+-]0[+-]0/gs;

@c=qw("#282828" "#181818" "#121261" black);
@g=qw(-0+0 +0+0 +0-0 -0-0);
@r=qw(\-0\+0 \+0\+0 \+0\-0 \-0\-0);
$n=-1;
for $i (0..3){
if($geometry!~/$r[$i]/){
	$n=$i;last;}
}
if($n==-1){$n=(rand 4);}
print "$n==$c[$n]==$g[$n]";
$p=join(" ",@ARGV);
`/usr/bin/xterm -bg ${c[$n]} -geometry 80x30${g[$n]} $p`;
#`XMODIFIERS="@im=SCIM" /usr/bin/xterm -bg ${c[$n]} -geometry 90x36${g[$n]} $ARGV`;
