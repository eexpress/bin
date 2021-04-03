#!/bin/bash

#~ -----------------------------------------------
#~ 当前目录是仓库就直接 pull，否则直接下载
#~ [ -d .git ] && git pull || wget https://iwxf.netlify.app -O index.html
#~ git pull 被封了？

#~ $orderurl = "https://iwxf.netlify.app"
orderurl="https://raw.githubusercontent.com/freefq/free/master/v2"
file="/tmp/ss-vmess.order.html"
wget $orderurl -O - | base64 -d >$file
#~ -----------------------------------------------
#~ 保存 json 文件到 “~/app/v2ray.config” 目录
cat $file | ss-vmess-QRcode-json.pl -p

#~ -----------------------------------------------
# 执行前，手机打开 kde connect
cat $file | xclip -i -selection clipboard
# 执行后，v2rayNG 中“从剪贴板导入”
