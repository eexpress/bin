title: DLNA
date: 2013-05-13 23:13
tags:
- minidlna
- DLNA
- UPnP
- DAAP 
---
安装miniDLNA，仅仅修改2个目录，记得需要force-reload，而不能仅restart。手机上安装BubbleUPnP，就可以看电脑的媒体。也推荐 MirageDLNA 比较好操作。似乎比 BubbleUPnP （收费）慢点。
```
● ai minidlan
● dog /etc/minidlna.conf 
....
media_dir=P,/home/eexpss/图片
media_dir=A,/home/eexpss/音乐
media_dir=V,/home/eexpss/视频
....
▶ sudo minidlnad -R
● sudo service minidlna force-reload
 * Restarting DLNA/UPnP-AV media server minidlna                                   [ OK ]
```
当然，和Rhythmbox的Daap服务，有些不同。
/etc/minidlna.conf 似乎只认第一行 media_dir 设置。@@@@@@@@@@@@@@@@@@@@了。

-----------------------
安装 `gupnp-tools`，有图形化的 `gupnp-av-cp` 可以推送本地媒体到电视盒子。

