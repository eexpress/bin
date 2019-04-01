#hexo

## Fedora 29 恢复 hexo

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