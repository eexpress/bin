#!/bin/dash
# ● 2011-05-13_14:29:48
[ ! -d "$1" ] && exit;
cd "$1"
cd fakeroot
echo $?
[ "$?" -ne 0 ] && exit;

v=`grep Version DEBIAN/control |sed 's/.*:\s//'`
echo "Version: $v."
md5sum `find usr -type f` > DEBIAN/md5sums
cd ..
dpkg -b fakeroot/ `pwd`-$v.deb

