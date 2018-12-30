#hexo
```bash
▶ sudo npm i hexo-cli -g
# 添加RSS订阅功能
▶ sudo npm i hexo-generator-feed

$ hexo init blog
$ cd blog
$ npm install

# 克隆主题
$ j hexo
# 需要保存的唯一配置
$ cp themes/yilia/_config.yml{,.old}
$ git clone https://github.com/litten/hexo-theme-yilia.git themes/yilia
▶ g theme _config.yml
theme: yilia

# 添加文章搜索
▶ sudo npm i hexo-generator-json-content --save
# 在/_config.yml加入如下内容
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
# 自定义css又无效了，文件都改动了。
▶ cd themes/yilia/source-src/css
▶ ln ~/bin/mkd/mkd.css .
▶ cp main.scss{,.org}
▶ echo -e '\n\n@import "mkd.css";'>>main.scss

$ hexo server
```