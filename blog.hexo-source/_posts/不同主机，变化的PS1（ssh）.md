title: 不同主机，变化的PS1（ssh）
date: 2014-03-07 21:30
tags:
- ssh
- PS1 
---
![](/img/ps1.png)
```
thiscolor=`expr $(printf "%d" "'$(hostname|cut -b 6)") % 7 + 1`
PS1="\[\e[3$thiscolor;40m\]\D{%Y-%m-%d %a} \t \H \w \[\e[m\] \n● "
```
当然还可以根据星期变化。
```
thiscolor=`date +%u`
```
