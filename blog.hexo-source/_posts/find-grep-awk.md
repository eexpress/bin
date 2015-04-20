title: "find,grep,awk"
date: 2005-10-13 14:10:43
tags:
- bash
---

![](/img/1find.png)

最简单的写法： 
	find -name "*.jpg" 
查找目录下没扩展名的文件。不包含"."的。 
	find . -type f ! -iname "*.*" 
列出所有长度为零的文件 
	find . -empty -exec ls {} \; 

找出空目录，删除～～～～～～～～～ 
	$●  alias rm_empty_dir
	alias rm_empty_dir="find -type d -empty -exec rmdir {} \;"
grep "^[^#]" options 
显示没有注释掉的有效行。 
grep -v也是取反的意思。 
去掉注释行和空行： 
	grep -v -e ^# -e ^$ acpi-support 
	$●  alias dog
	alias dog="grep -v -E "(^$|^#)""

搜索字符串，最简单的写法：-n是显示行号。 
	grep -n RTC *.c *.h 

grep -r的写法不出来？？？？？？？？？？？？？？？要不就可以不要gnome-search-tool了。 

	grep -r include --include=*.c --include=*.h * 
麻烦哦。要这样带2级参数限制文件后缀 

	find . -name ".DirIcon" -or -name "djgame*" 
-or -o ,，都是或关系。 
-and -a 空缺，3种都是与关系，似乎没什么用。 

搜索文件并打包。laborer说+的方法。
	$●  find $PWD -name ".DirIcon" -exec tar -cPvf 目录图标.tar.gz {} + 

一次显示出ini的一个段
	awk -F[ "BEGIN{RS = ""} /Fonts]/" ~/.opera/opera6.ini
	awk -F"Section" "BEGIN{RS = ""} /\ \"Device/" /etc/X11/xorg.conf
	awk -F"Section" "BEGIN{RS = ""} /.*Mouse/" /etc/X11/xorg.conf
