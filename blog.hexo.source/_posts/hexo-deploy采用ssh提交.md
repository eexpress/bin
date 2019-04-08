title: hexo deploy采用ssh提交
date: 2014-10-13 14:18:35
tags:
- hexo
---
如果使用http方式，每次问帐号密码。
_config.yml里面，采用标准的ssh方式。
```
repository: git@github.com:eexpress/eexpress.github.com.git
```
写法可以在以前的git目录里面，用 git remote -v 看到的。

新安装的hexo，部署的时候，会出这个。删除当前的git目录。

> fatal: Not a git repository (or any parent up to mount point /home)
> Stopping at filesystem boundary (GIT_DISCOVERY_ACROSS_FILESYSTEM not set).
```
rm -r .deploy_git/
```
