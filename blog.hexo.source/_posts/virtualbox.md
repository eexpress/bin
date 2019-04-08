title: "VirtualBox::宿主机和客户机共享数据"
date: 2007-02-12 15:02:03
tags:
---

宿主机和客户机共享的方法，还是翻pdf手册才知道，连个manpages都不给。这么简单的功能，怎么不加个图形设置界面哦。

宿主机ubuntu里面执行： 代码:
VBoxManage sharedfolder add "xp-ee" -name "media-disk" -hostpath "/home/media/"

其中xp-ee就是虚拟机的名字。VBoxManage list vms可以看到的。

客户机xp里面执行： 代码:
net use e: \\vboxsvr\media-disk

就可以马上看到一个新加的e盘了。 

和samba一个德性，不支持net播放媒体文件。需要复制到本地。

[<span class='imgright'>![](http://files.myopera.com/eexpress/albums/20932/thumbs/screenshot-2007-02-13-09-58-33.png_thumb.jpg)](/eexpress/albums/showpic.dml?album=20932&amp;picture=3047019) 