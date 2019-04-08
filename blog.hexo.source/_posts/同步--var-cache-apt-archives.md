title: 同步 /var/cache/apt/archives
date: 2014-02-05 23:18
tags:
- apt/archives
- rsync 
---
rsync 不好简单的搞定权限问题。暴力的蛋蛋提醒了方法。
``` bash
ssh eexp@eexp-XPS-L421X.local
sudo su
chmod o+w /var/cache/apt/archives
exit
```
如果经常同步这目录，都不需要把权限改回去。
```
rsync -a /var/cache/apt/archives eexp@eexp-XPS-L421X.local:/var/cache/apt/archives
```
只认 deb 过去了就成。
