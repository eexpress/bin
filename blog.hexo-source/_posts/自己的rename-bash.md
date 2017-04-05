---
title: 自己的rename.bash
date: 2017-04-05 13:51:50
tags:
- rename
- bash
---

Fedora 25 下面没有rename.pl，不想使用cpan，搞一堆库在～下。源里面的猪式 pyrenamer 没正则支持，metamorphose2 太老，居然需要 wxpython。干脆自己写一个，比pl版本更灵活。

```
#!/bin/bash

regex=$1
shift
echo "----------Preview-------------"
cnt=1
for i in """$@"""; do s[$cnt]=$i; d[$cnt]=`echo $i|perl -pe "$regex"`; echo -e "${s[$cnt]}\t->\t${d[$cnt]}...."; ((cnt++)); done

echo "----------Rename?-------------"
echo "Comfirm: press SPACE/ENTER. Other keys Cancel."
read -s -n 1 y
if [[ $y == '' ]]; then
    echo "Start Rename..."
    for (( i=1; i<$cnt; i++ )) ; do
    echo "mv ${s[$i]} ${d[$i]}"
    mv "${s[$i]}" "${d[$i]}"
    done
else echo "Cancel."; fi
```

参数1是完整的perl写法，可以一直续写的。

```
▶ rename.bash 's/(20..)(..)(..)_(..)(..)/$1-$2-$3_$4-$5-/' IMG*
----------Preview-------------
IMG_20170115_160301.jpg ->  IMG_2017-01-15_16-03-01.jpg....
IMG_20170116_192936.jpg ->  IMG_2017-01-16_19-29-36.jpg....
IMG_20170121_191014.jpg ->  IMG_2017-01-21_19-10-14.jpg....
IMG_20170123_165833.jpg ->  IMG_2017-01-23_16-58-33.jpg....
IMG_20170128_151437.jpg ->  IMG_2017-01-28_15-14-37.jpg....
IMG_20170131_223222.jpg ->  IMG_2017-01-31_22-32-22.jpg....

----------Rename?-------------
Comfirm: press SPACE/ENTER. Other keys Cancel.
Start Rename...
mv IMG_20170115_160301.jpg IMG_2017-01-15_16-03-01.jpg
mv IMG_20170116_192936.jpg IMG_2017-01-16_19-29-36.jpg
mv IMG_20170121_191014.jpg IMG_2017-01-21_19-10-14.jpg
mv IMG_20170123_165833.jpg IMG_2017-01-23_16-58-33.jpg
mv IMG_20170128_151437.jpg IMG_2017-01-28_15-14-37.jpg
mv IMG_20170131_223222.jpg IMG_2017-01-31_22-32-22.jpg

```
