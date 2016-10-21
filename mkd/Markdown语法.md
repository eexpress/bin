<head>
<title>markdown 模板</title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<link href="mkd.css" rel="stylesheet" type="text/css">
</head>

#Markdown 语法

说明|示例|说明|示例
---|---|---|---
Setext 标题<br>(2级)|1号标题<br>=============<br>２号标题<br>-------------|Atx 标题<br>(6级)|# 1号标题<br>## 2号标题<br>###### 6号标题
区块引用|> This is a **blockquote**.<br>Second Line.<br>Third Line.|引用嵌套|> This is the first level of quoting<br>>> This is nested blockquote<br>> Back to the first level
无序列表|* Red<br>+ Green<br>- Blue|有序列表|1.  Bird<br>1.  McHale
列表可以包含多个段落|行首4个空格或是1个制表符|避免误判使用转义\符号|1986\. What a great season.
代码区块(4 个空格或是 1 个制表符)(使用```包括)|\```<br>exit if /md/;<br>\```<br>```exit if /md/;```|行内代码|\`code\`<br>`code`
分隔线(至少3个字符)|***<br>---<br>___|表格|这个文档就是一个`MarkDown`表格
链接|\[an example](http://example.com/ "Title")<br>[an example](http://example.com/ "Title")|参考链接|[an example] [id]<br>[id]: http://example.com/  "Optional Title Here"<br>隐式链接直接使用id<br>[Google][]
粗体|\*\*b\*\* \_\_b\_\_<br>**strong.blod**|斜体|\*b\* \_b\_<br>*em.italic*
图片|\!\[Alt text](/path/to/img.jpg "Optional title")<br>![Alt text](/path/to/img.jpg "Optional title")|自动链接|<http\://example.com><br><address@example.com\><br><address@example.com>


