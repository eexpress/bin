title: ssh key 冲突
date: 2013-10-19 11:32
tags:
- ssh 
---
今天开2台机器，nautilus查看另外一台，一直超时。
手动测试下：
```
● ssh eexp-XPS-L421X.local
Warning: the ECDSA host key for 'eexp-xps-l421x.local' differs from the key for the IP address '192.168.1.102'
Offending key for IP in /home/eexp/.ssh/known_hosts:17
Matching host key in /home/eexp/.ssh/known_hosts:26
Are you sure you want to continue connecting (yes/no)?
```
居然是多了key。（违反 - Offending）
删除 ~/.ssh/known_hosts 的17行，恢复正常。

