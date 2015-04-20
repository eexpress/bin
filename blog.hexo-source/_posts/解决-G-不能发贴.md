title: 解决 G+ 不能发贴
date: 2014-10-01 18:19:00
tags:
- dns
---

正常的ssh -D，在家里的网络就是行不通，DMZ无效，估计是ISP的问题。只好启用go*a*gent。
go*a*gent只能显示，点不开回复的框。估计pac里面漏了特定的网站，或者特定网站被禁止dns解析了。
在[dns]段修改：
```
enable = 1
listen = 127.0.0.1:7070
```
居然可以。太bt了。因为之前，拨号连接的dns已经设置到对方的53端口了。
注：使用fx的remote_dns太假了。
想不通，为啥要go*a*gent，不能直接7070。
才发现问题。低级错误。
```
firefox 2487 eexp   70u  IPv4 312229      0t0  TCP eexp-XPS-L421X.local:36606->120.0.0.1:7070 (SYN_SENT)
```
居然是120。气死。

