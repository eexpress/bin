title: "mencoder::超强截取视频的CLI"
date: 2007-03-03 06:03:43
tags:
---

$●  mencoder "/home/exp/媒体/电影/●动画/[2006.12.31]加菲猫2双猫记( 大陆公映上译配音)[2006年美国动画]（帝国出品）/影视帝国(bbs.cnxp.com).加菲猫2双猫记(上译配音国语无字).Garfield.II.2006.rmvb" [B]-ss 01:05:00 -endpos 62[/B] -ovc lavc -lavcopts vcodec=mpeg4:vhq:vbitrate=1200 -oac mp3lame -o 加菲猫－片段.mpeg4


粗体是设置起始和结束的参数。容易理解吧。我设置的这段时间，是双猫记中最经典的那段哦，帅帅最喜欢看的那段。执行的时候，一顿猛扫，CPU占了一半，还算飞快的就搞好了。

$●  ll 加菲猫－片段.mpeg4
-rw-r--r-- 1 exp exp 9.9M 2007-03-03 13:28 加菲猫－片段.mpeg4


![](http://files.myopera.com/eexpress/blog/%E5%8A%A0%E8%8F%B2%E7%8C%AB%EF%BC%8D%E7%89%87%E6%AE%B5.png)