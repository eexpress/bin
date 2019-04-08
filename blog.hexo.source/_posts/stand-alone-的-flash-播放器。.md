title: stand alone 的 flash 播放器。
date: 2005-12-16 06:12:11
tags:
---

以前一直以为源的swfplayer可以，下了才知道不行。 
找了一个[http://download.enet.com.cn/speed/toftp.php?fname=282492004050801](http://download.enet.com.cn/speed/toftp.php?fname=282492004050801) 
需要libstdc++-libc6.2-2.so.3库，又找了半天，才找到这个。 
$ sudo apt-get install libstdc++2.10-glibc2.2 
其实好像就已经建立了链接。 

如果没有，最多自己链接一下。 
$ cd /usr/lib/ 
$ ln -s libstdc++-3-libc6.2-2-2.10.0.so libstdc++-libc6.2-2.so.3 
$ ll libstdc++-libc* 
lrwxrwxrwx 1 root root 31 2005-12-12 00:40 libstdc++-libc6.2-2.so.3 -&gt; libstdc++-3-libc6.2-2-2.10.0.so 

然后计划把flash的时钟swallow到FvwmButtons里面去。 

flash时钟在： 
[http://www.fengzhuju.com/page-00s/wzgg/clocks.htm](http://www.fengzhuju.com/page-00s/wzgg/clocks.htm)