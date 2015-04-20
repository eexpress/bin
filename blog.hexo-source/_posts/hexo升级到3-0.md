title: "hexo升级到3.0"
date: 2015-04-04 23:51:03
tags:
- hexo
---
hexo这家伙，默默的升级到3.0.0。在老目录从2.8.3直接升级，各种问题。npm list一堆事情。强制 npm install hexo@2.8.3，list也是出各种问题。只好干脆新建。
``` bash
mkdir blog.hexo-3.0.0
cd blog.hexo-3.0.0/
#清除之前的各种操作遗留文件和系统目录下安装的文件
sudo rm -r *
sudo rm /usr/local/bin/hexo /usr/local/lib/node_modules/hexo-cli -r
#从头安装
sudo npm install hexo-cli -g
hexo init
#本地目录node_modules安装依赖的一些包，不sudo还出错
sudo npm install
#这版本需要额外安装git发布包
npm install hexo-deployer-git --save
#修改新版本的配置文件
vim _config.yml
```
nnnnd，复制老的source目录到这边，hexo d -g后，等于重新上传一次git仓库，真费劲。

