---
title: 试试dnscrypt
date: 2017-05-22 22:40:24
tags:
- dns
- crypt
- proxy
---
安装`dnscrypt-proxy`。
```
▶ cat ~/bin/dnscrypt.bash 
#!/bin/bash

sudo dnscrypt-proxy -R cisco -a 127.0.0.2:53 -u `whoami`
#▶ g cisco /usr/share/dnscrypt-proxy/dnscrypt-resolvers.csv
#cisco,Cisco OpenDNS,Remove your DNS blind spot,Anycast,,https://www.opendns.com,1,no,no,no,208.67.220.220:443,2.dnscrypt-cert.opendns.com,B735:1140:206F:225D:3E2B:D822:D7FD:691E:A1C3:3CC8:D666:8D0C:BE04:BFAB:CA43:FB79,

▶ dnscrypt.bash 
[INFO] - [cisco] does not support DNS Security Extensions <- 什么鬼
[WARNING] - [cisco] logs your activity - a different provider might be better a choice if privacy is a concern
[NOTICE] Starting dnscrypt-proxy 1.6.1
[INFO] Generating a new session key pair
[INFO] Done
[INFO] Server certificate #1490391488 received
[INFO] This certificate is valid
[INFO] Chosen certificate #1490391488 is valid from [2017-03-25] to [2018-03-25]
[INFO] Server key fingerprint is E7F8:4477:BF89:1434:1ECE:23F0:D6A6:6EB9:4F45:3167:D71F:80BB:4E80:A04F:F180:F778
[NOTICE] Proxying from 127.0.0.2:53 to 208.67.220.220:443
```
其中`-R,  --resolver-name=<name>`参数，是在`/usr/share/dnscrypt-proxy/dnscrypt-resolvers.csv`里面第一列选择一个配置名。

当前网络连接，第一个dns改成127.0.0.2。

`dig`一下twitter，第一下显示Dropbox公司，吓人。新开终端，再dig，才正确。什么鬼。

