#!/bin/bash

cd ${HOME}/eexpss.hugo

if [ ! -f config.toml ]; then
	echo "Not in Hugo directory"
	exit
fi
hugo
cd public
pwd

git add .

msg=${*:-`date '+%F %T'`}
git ci -a -m "$msg"; git push
# ci -a 自动先把工作区的文件add/rm到了暂存区，然后commit到本地仓库。
# ci -m 是提交时，附带注释字符串。

