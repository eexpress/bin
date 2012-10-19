#!/usr/bin/perl

#$ps=`/bin/ps -e -o command|grep xterm`;
$ps=`pgrep -fl xterm.*geometry`;
$geometry=join ",",$ps=~/[+-]0[+-]0/gs;

@c=qw(black brown4 blue4 tan4);
@g=qw(+0+0 -0+0 +0-0 -0-0);
@r=qw(\+0\+0 \-0\+0 \+0\-0 \-0\-0);
$n=-1;
for $i (0..3){
if($geometry!~/$r[$i]/){
        $n=$i;last;}
}
if($n==-1){$n=(rand 4);}
`/usr/bin/xterm -bg ${c[$n]} -geometry 90x36${g[$n]} $ARGV`;
#`XMODIFIERS="@im=SCIM" /usr/bin/xterm -bg ${c[$n]} -geometry 90x36${g[$n]} $ARGV`;

