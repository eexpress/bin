title: 安装bind9
date: 2014-10-27 12:25:16
tags:
- bind9
- ubuntu
- vps
---
本级ip: xx.xx.xx.xx
远程ip: yy.yy.yy.yy

## 远程安装bind9
```
▶ apt-get install bind9
```

## 本机测试
nm 已经设置了 dns 是 yy.yy.yy.yy，所以dig不强制server，也是默认此ip为dns服务器。
```
▶ dig @yy.yy.yy.yy www.google.com
▶ dig www.twitter.com
```

## 远程看记录
```
▶ cat /var/log/syslog
Oct 26 23:51:23 eexp named[30980]: client xx.xx.xx.xx#35944 (www.google.com): query (cache) 'www.google.com/A/IN' denied
Oct 26 23:51:47 eexp named[30980]: client xx.xx.xx.xx#39239 (www.twitter.com): query (cache) 'www.twitter.com/A/IN' denied
```
完全没设置权限。在 /etc/bind/named.conf.options 增加一句 allow-query。syslog里面增加很多错误，但是本地dig已经正常了。
```
▶ tail -n 4 named.conf.options
	listen-on-v6 { any; };
	allow-query { any; };
};
▶ sudo service bind9 restart
```

