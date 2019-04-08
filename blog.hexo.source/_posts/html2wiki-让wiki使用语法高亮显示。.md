title: "html2wiki:让wiki使用语法高亮显示。"
date: 2007-03-29 08:03:11
tags:
---

保留颜色语法高亮是最重要的。要不vim的html输出就没意义了。

```
:source $VIMRUNTIME/syntax/2html.vim
:write __xxx__.html
```

先建立一个html2wiki.sed

```
s/[html:a href="/%5B%5B/g
s/"]http/|http/g
s/&lt;\/a&gt;/]]/g

s/&lt;font \|&lt;\/font&gt;/@@/g
s/color="/color(/g
s/"&gt;/):/g

/&lt;pre&gt;\|&lt;\/pre&gt;/ d
/&lt;body\|&lt;\/body&gt;/ d
/&lt;html&gt;\|&lt;\/html&gt;/ d
/&lt;head&gt;\|&lt;\/head&gt;/ d
/&lt;meta/ d

s/&lt;title&gt;/!!/g
s/&lt;\/title&gt;//g

s/\/\//\/ \//g
s/&lt;b&gt;\|&lt;\/b&gt;\|&lt;B&gt;\|&lt;\/B&gt;/""/g
#&amp;amp;&amp;gt;&amp;lt;&amp;quot;
s/\t/&gt;/g
#s/^ */&gt;/g
s/ \{8\}/&gt;/g
```

然后，这样运行
`$●  sed -f html2wiki.sed fetch_web_pic.bash.html >;fetch_web_pic.bash.html.wiki`

得到的wiki文件，可以直接粘贴到tiddlywiki的编辑里面。如下图

![](http://files.myopera.com/eexpress/blog/1html2wiki.png)
