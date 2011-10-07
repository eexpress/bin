r=`xrandr|grep -o '.*\*'|cut -d' ' -f 4`
echo $r
d=`dirname "$1"`
echo $d
cd "$d"
e=`basename "$1"`
#wine explorer /desktop=foo,$r "$e"
wine explorer /desktop=foo,1024x768 "$e"

