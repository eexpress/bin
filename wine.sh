o=`xrandr|grep -o '.*\*'|cut -d' ' -f 4`
echo $o
n=800x600
r=76
#n=960x540
#r=68
d=`dirname "$1"`
echo $d
cd "$d"
e=`basename "$1"`
#wine explorer /desktop=foo,$r "$e"
xrandr --output default --mode $n --rate $r
echo change to $n
#wine "$e"
wine explorer /desktop=foo,$n "$e"
xrandr --output default --mode $o

