---
title: 批量整理Heist的高级武器图片列表
date: 2017-12-21 12:54:35
tags:
- crop
- convert
- imagemaick
---
```
▶ cd ~/图片
▶ rename.bash 's/\ /_/g;s/_的屏幕截图//g' 2017-12-21*.png
▶ for i in 2017-12-21*.png; do convert $i -crop 40%x45%+480+50 ~/$i; done
▶ montage -tile 3 -geometry 500 -background none 2017-12-21* 稀有武器列表.png
```
明明记得geometry的偏移量也可以写成百分比的形式的，加一个什么前缀，一时真想不起来了。

![](/img/稀有武器列表.png)

