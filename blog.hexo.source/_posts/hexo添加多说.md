title: hexo添加多说
date: 2014-10-14 10:23:15
tags: 
- hexo
- duoshuo
---
克隆一个主题。参见
https://github.com/xiangming/landscape-plus#常见问题
去多说主页duoshuo.com，点“我要安装”。创建站点。我是使用百度帐号绑定的。
themes/landscape-plus/_config.yml 里面填写申请到的“多说域名”那个id。
如果使用 yilia 的主题，直接在/_config.yml 里面写 `duoshuo: eexpress`。
hexo d -g就可以了。速度飞快。
