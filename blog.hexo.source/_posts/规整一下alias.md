title: 规整一下alias
date: 2006-08-02 15:08:15
tags:
---

#-----软件包管理命令----- 
alias ai="sudo aptitude install" 
alias ar="sudo aptitude remove" 
alias au="sudo aptitude update" 
alias ag="sudo aptitude upgrade" 
alias as="aptitude search" 
alias aw="aptitude show" 

#-----系统常用操作命令----- 
alias ll="ls -lFh" 
alias la="ls -AF" 
alias l="ls -CF" 

alias cl="crontab -l"
alias ce="crontab -e"

alias pg="pgrep -l" 
alias sk="sudo killall" 

alias rm_empty_dir="find -type d -empty -exec rmdir {} \;"	# 删除空目录
alias dog="grep -v -E "(^$|^#)""	# 显示有效内容，剔出空行和#号注释行
# 相同操作 grep -v -e ^# -e ^$ acpi-support
# grep "^[^#]" options

alias sv="sudo vi"
alias se="sudo mousepad"
alias e="mousepad"
alias h="Hypersrc.pl "

#-----中英文环境变量设置----- 
alias cn="export LC_ALL=zh_CN.UTF-8"
alias en="export LC_ALL=C"
alias cman="man -M /usr/share/man/zh_CN"

#-----网络常用操作命令----- 
alias 0u="sudo ifup eth0"
alias 0d="sudo ifdown eth0"
alias 1u="sudo ifup eth1"
alias 1d="sudo ifdown eth1"
alias ip3322="w3m -no-cookie -dump "[http://eexpress:189965@members.3322.org/dyndns/update?system=dyndns&amp;hostname=eexpress.3322.org](http://eexpress:189965@members.3322.org/dyndns/update?system=dyndns&amp;hostname=eexpress.3322.org)""
alias getip="w3m -no-cookie -dump www.ip138.com|grep -o "[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}""

alias p="ping www.163.com -c 5"
alias adsl="pon dsl-provider" 
alias down3322="sudo /etc/init.d/apache stop"

#-----tar常用命令，后跟压缩包名，和带全路径的操作的文件名----- 
alias t.d="tar --delete -f "
alias t.x="tar xPvf "
alias t.l="tar tf "
alias t.u="tar uPvf "

#alias tar_delete="tar --delete -f " 
#alias tar_extract="tar xPvf " 
#alias tar_list="tar tf " 
#alias tar_update="tar uPvf "