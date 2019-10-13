---
title: 又遇etqw声音问题
date: 2017-04-14 18:12:18
tags:
- sound
- etqw
---
才翻出一个老游戏，etqw，结果没声音。之前就好难解决的。今天认真看输出提示。
启动后，alt-tab切换到终端，看到提示：
```
------ Alsa Sound Initialization -----
dlopen(libasound.so.2)
asoundlib version: 1.1.1
ALSA lib dlmisc.c:254:(snd1_dlobj_cache_get) Cannot open shared library /usr/lib/alsa-lib/libasound_module_pcm_pulse.so
snd_pcm_open SND_PCM_STREAM_PLAYBACK 'default' failed: No such device or address
dlclose
WARNING: sound subsystem disabled

--------------------------------------
----------- Alsa Shutdown ------------
```
搜索 `Cannot open shared library /usr/lib/alsa-lib/libasound_module_pcm_pulse.so`。
然后猜测，alsa是启动了，可是找不到输出到pulseaudio的插件。看到有alsa-plugins-pulseaudio包，x86\_64确定已经安装了的，猜想是少了i386/i686的包。
```
▶ di alsa-plugins-pulseaudio.i686
```
搞定。以前扯的那些配置里面改oss的，都没用。

##libSDL
另外一个缺少libsdl的，也是少一个i686的包。
```
⭕ ldd etqw.x86 |g found
libSDL-1.2.so.0 => not found

▶ di SDL-1.2.15-21.fc24.i686

⭕ pi SDL.i686
  安装    : SDL-1.2.15-41.fc30.i686                  1/1 

⭕ plist SDL.i686|g libSDL-1.2.so.0
/usr/lib/libSDL-1.2.so.0
/usr/lib/libSDL-1.2.so.0.11.4
```
