title: "openwrt开ssh-D"
date: 2015-04-20 22:12:15
tags:
- openwrt
- ssh
- opkg
---
破路由安装的Dropbear不能-D。安装openssh。

```
▶ ssh root@192.168.8.1
root@OYE:~# opkg update
root@OYE:~# opkg install openssh-client openssh-keygen
root@OYE:~# df -h|grep rootfs
rootfs                    2.6M    764.0K      1.8M  29% /
root@OYE:~# ssh-keygen -b 1024 -t rsa
把id_rsa.pub追加到远程的authorized_keys里面。没有ssh-copy-id命令，只好手动吧。
root@OYE:~# ssh -qTfnN -D 7070 xxxx@100.100.100.100
草，不出端口。直接ssh验证登录没问题。
```
