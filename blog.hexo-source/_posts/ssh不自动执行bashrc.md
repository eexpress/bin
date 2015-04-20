title: ssh不自动执行bashrc
date: 2014-03-07 21:17
tags:
- profile
- bash
- ssh 
---
只一台机器这样。很奇怪。今天突发奇想，看了下.profile，居然远端没这文件。
```
▶ scp ~/.profile eexp@eexp-desktop.local:~
.profile                                                100%  675     0.7KB/s   00:00
```
再ssh过去，立马正常。
