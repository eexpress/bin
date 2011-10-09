r=`xrandr|grep -o '.*\*'|cut -d' ' -f 4`
echo $r
#n=640x480
n=1024x768
#n=1152x864
d=`dirname "$1"`
echo $d
cd "$d"
e=`basename "$1"`
#wine explorer /desktop=foo,$r "$e"
xrandr --output default --mode $n --rate 60
echo change to $n
#wine "$e"
wine explorer /desktop=foo,$n "$e"
xrandr --output default --mode $r

