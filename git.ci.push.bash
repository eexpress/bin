#!/bin/bash

# 格式，参数均可选：<提交说明> <独立提交的文件>

msg=${1:-`date '+%F %T'`}	# 第一个参数为空，使用日期作为提交说明。
shift
if [ $# -gt 0 ]; then	# 如果还有参数
	git add $@	# 提交工作区的文件到暂存区
	git ci -m "$msg"; git push
	exit
fi

git ci -a -m "$msg"; git push
# ci -a 自动先把工作区的文件add/rm到了暂存区，然后commit到本地仓库。
# ci -m 是提交时，附带注释字符串。
