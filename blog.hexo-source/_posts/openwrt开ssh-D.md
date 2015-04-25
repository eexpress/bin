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
>> 把id_rsa.pub追加到远程的authorized_keys里面。没有ssh-copy-id命令，只好手动吧。
>> 其实也可以不要openssh-keygen，直接把本本上的id_rsa传到路由的/root/.ssh就可以了。反正服务器那边authorized_keys里面早就有了pub内容。
root@OYE:~# ssh -qTfnN -D 7070 xxxx@yyy.yyy.yyy.yyy
>> 草，不出端口。直接ssh验证登录没问题。千辛万苦，才发现问题，这货的ssh，必须指定本机ip，而且还不能使用127.0.0.1，真奇怪。
root@OYE:~# cat /etc/init.d/ssh-d 
#!/bin/sh /etc/rc.common
START=99

start() {
	ssh -qTfnN -D 192.168.8.1:7070 xxxx@yyy.yyy.yyy.yyy
}

stop() {
	killall ssh
}
root@OYE:~# /etc/init.d/ssh-d enable
>> 设置成启动，LUCI界面可看到为开机启动状态。
```
至此，本本上只需要设置全局的pac了，不再需要用脚本启用7070端口。
```
function FindProxyForURL(url, host) {
	var autosocks = 'SOCKS5 192.168.8.1:7070';
.......
```
