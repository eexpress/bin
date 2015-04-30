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
# rm /usr/bin/scp /usr/bin/ssh
# opkg update
# opkg install openssh-client autossh openssh-keygen
# ssh-keygen

▶ scp root@192.168.8.1:/root/.ssh/id_rsa.pub /tmp/
▶ ssh-copy-id -i /tmp/id_rsa.pub -p 26489 root@45.62.xxx.xxx
/usr/bin/ssh-copy-id: ERROR: failed to open ID file '/tmp/id_rsa': No such file
>> -i 过不去。手动复制到远程的authorized_keys里面。

# opkg remove openssh-keygen
# df -h|grep rootfs
rootfs                    2.6M    596.0K      2.0M  23% /
# vi /etc/config/autossh
# grep 7070 /etc/config/autossh
	option ssh	'-i /root/.ssh/id_rsa -N -T -D 0.0.0.0:7070 eexp@128.199.xxx.xxx'
>> 这货的ssh，必须指定本机或者全0的ip，不能使用127.0.0.1，真奇怪。
# ssh -qTfnN -D 0.0.0.0:7070 eexp@128.199.xxx.xxx
>> 前期验证下登录。
# /etc/init.d/autossh enable
# /etc/init.d/autossh start
# for i in vnstat samba ddns vsftpd telnet xunlei mjpg-streamer watchcat wifidog nodogsplash; do /etc/init.d/$i disable; /etc/init.d/$i stop; done
>> 关闭一堆无用的服务。
# /etc/init.d/minidlna enable
# /etc/init.d/minidlna start
```

至此，本本上只需要设置全局的pac了，不再需要用脚本启用7070端口。
```
function FindProxyForURL(url, host) {
	var autosocks = 'SOCKS5 192.168.8.1:7070';
.......
```

当然pac可以放到路由器自动分发，只是WPAD协议，不是所有设备都支持的。
```
▶ scp /home/eexp/.proxy.pac root@192.168.8.1:/www/
# cat /etc/config/dhcp
config dnsmasq
...
        option resolvfile '/tmp/resolv.conf.auto'
        list dhcp_option '252,http://192.168.8.1/.proxy.pac' 
                 
config dhcp 'lan'             
...
▶ dnsmasq --help dhcp
Known DHCP options:
...
>> 其实没看到252的说明。
```
---------------------------------
