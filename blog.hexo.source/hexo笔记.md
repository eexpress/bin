#hexo
---
## Fedora 29 恢复 hexo
---
## 安装必要环境
```
# dnf install libuv
> 让root自动安装所需软件
# npm
# npm i hexo-cli -g
```
## 新建hexo目录
```
▶ mkdir hexo; cd hexo
▶ hexo init
▶ rm -r source/
▶ ln -sf ~/bin/blog.hexo-source/ source
▶ cp source/hexo._config.yml _config.yml
▶ git clone https://github.com/litten/hexo-theme-yilia.git themes/yilia
▶ cp source/yilia._config.yml themes/yilia/_config.yml 
▶ hexo s
▶ hexo d -g
> ERROR Deployer not found: git
▶ npm i hexo-deployer-git --save
> 添加RSS订阅功能
> INFO  Generated: atom.xml
▶ npm i hexo-generator-feed --save
> 添加文章搜索
> INFO  Generated: content.json
▶ npm i hexo-generator-json-content --save
▶ hexo d -g
```
## ...old... 展示不操作

## 在/_config.yml加入如下内容
```
jsonContent:
    meta: false
    pages: false
    posts:
      title: true
      date: true
      path: true
      text: false
      raw: false
      content: false
      slug: false
      updated: false
      comments: false
      link: false
      permalink: false
      excerpt: false
      categories: false
      tags: true
```
## 自定义css又无效了，文件都改动了。
```
▶ cd themes/yilia/source-src/css
▶ ln ~/bin/mkd/mkd.css .
▶ cp main.scss{,.org}
▶ echo -e '\n\n@import "mkd.css";'>>main.scss

```
---
## 完全卸载hexo和npm
---

```
⭕ cd hexo
⭕ npm uninstall hexo-deployer-git hexo-generator-feed hexo-generator-json-content hexo-cli
⭕ sudo npm uninstall hexo-cli -g
⭕ npm list -g --depth 0         <-- 全局 -g
/usr/lib
├── hexo@3.8.0
└── npm@6.4.1
⭕ sudo npm uninstall -g hexo
⭕ npm list --depth 0            <--本地安装太多，一把删除目录
hexo-site@0.0.0 /home/eexpss/文档/hexo
├── hexo@3.8.0
├── hexo-generator-archive@0.1.5
├── hexo-generator-category@0.1.3
├── hexo-generator-index@0.2.1
├── hexo-generator-tag@0.2.0
├── hexo-renderer-ejs@0.3.1
├── hexo-renderer-marked@0.3.2
├── hexo-renderer-stylus@0.3.3
└── hexo-server@0.3.3

npm ERR! missing: mkdirp@0.5.1, required by node-pre-gyp@0.10.3
⭕ cd ..
⭕ sudo rm -r hexo/
⭕ dr npm libuv nodejs
将会释放空间：45 M

```