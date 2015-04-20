title: hexo 增加 rss
date: 2014-11-11 09:24:05
tags:
- hexo
- rss
---
```
▶ sudo npm install hexo-generator-feed
[sudo] password for eexp: 
npm http GET https://registry.npmjs.org/hexo-generator-feed
npm http 200 https://registry.npmjs.org/hexo-generator-feed
npm http GET https://registry.npmjs.org/hexo-generator-feed/-/hexo-generator-feed-0.2.1.tgz
npm http 200 https://registry.npmjs.org/hexo-generator-feed/-/hexo-generator-feed-0.2.1.tgz
npm http GET https://registry.npmjs.org/utils-merge
npm http GET https://registry.npmjs.org/ejs
npm http 200 https://registry.npmjs.org/utils-merge
npm http 200 https://registry.npmjs.org/ejs
hexo-generator-feed@0.2.1 node_modules/hexo-generator-feed
├── utils-merge@1.0.0
└── ejs@1.0.0
```
然后在 _config.yml 里面增加
```
plugins:
- hexo-generator-sitemap
```
其他不用改，hexo d -g 后立刻生效。

