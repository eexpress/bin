---
title: 箭头PS1
date: 2018-04-10 14:34:41
tags:
- PS1
- bash
---
昨天看到有人执着的想要zsh的箭头提示符，在字符表中搜索了下arrow和triangle的字符，找到一个简单就可以实现的。
```
#-------PS1 COLOR----------------------------------
	darkgreen="0x16"	#dark green
	gray="0xee"	#light gray
	green_gray=`tput setaf 2; tput setab $gray;`
	allgray=`tput setaf $gray; tput setab $gray;`
	gray_green=`tput setaf 0xfa; tput setab $darkgreen;`
	allgreen=`tput setaf $darkgreen; tput setab $darkgreen;`
	setbold=`tput bold;`
	setnone=`tput sgr0`
	PS1="$setbold$gray_green \D{%Y-%m-%d %a} \t$allgreen🡺$green_gray  \H $allgray🡺$gray_green  \w$allgreen🡺$setnone \n▶ "
```
效果如下

![](/img/PS1_arrow_prompt.png)