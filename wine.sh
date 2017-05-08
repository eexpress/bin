info=`xrandr|grep primary`
o=`echo $info|cut -d ' ' -f1`
m=`echo $info|cut -d ' ' -f4|sed 's/\+.*//'`
echo "<$o>----<$m>"
n=1024x768
d=`dirname "$1"`
#echo $d
cd "$d"
e=`basename "$1"`
xrandr --output $o --mode $n
#echo change to $n
XMODIFIERS=@im=xim
wine explorer /desktop=foo,$n "$e"
#wine "$e"
xrandr --output $o --mode $m
XMODIFIERS=@im=ibus
