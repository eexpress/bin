title: "FrameBuffer::zhcon,mplayer,grub,vga"
date: 2007-01-09 00:01:11
tags:
---

FrameBuffer(tty下面的直接写屏)
Created 星期一 2007-01-08

=====================================================
grub的vga参数表，启用framebuffer
写法：vga=xxx 
这个xxx请参考下面的表 
depth -- 640x480 - 800x600 - 1024x768 - 1280x1024 
8bit -- 769 - 771 - 773 - 775 
15bit -- 784 - 787 - 790 - 793 
16bit -- 785 - 788 - 791 - 794 
24bit -- 786 - 789 - 792 - 795

=====================================================
zhcon需要framebuffer
zhcon --utf8。运行才识别utf8的local系统。

=====================================================
mplayer在tty下面的运行

mplayer -vo的参数测试：
yuv4mpeg
只有声音。

aa/caca
竟然都可以播放。只是大概分不清谁是谁了。字符模式，鬼才认到人。看个大概形状而已。

ggi
卡，而且不断出错就没正常视频了。 

fbdev/fbdev2
正常。

gif89a/tga/png/pnm
这些图片格式的，当然没视频输出了。声音还是有的。后来看目录，都转图片文件了，一堆一堆的。 

md5sum/null
没敢测试。 

其他的都没连接。

=====================================================
mplayer的强制全屏显示
mplayer -vo fbdev2 -zoom -fs -x 1024 -y 768 test.rmvb 