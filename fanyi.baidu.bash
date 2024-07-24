#!/bin/bash

baidu_translate() {
	APPID="20220103001044988"  
	SECRET_KEY=$(cat $HOME/.fanyi.baidu.secret_key)
	QUERY="$1"  
	TARGET="zh"  
	SALT=$(date +%N | md5sum | head -c 10)  
	SIGN=$(echo -n "$APPID$QUERY$SALT$SECRET_KEY" | md5sum | awk '{print $1}')  

	RESPONSE=$(curl -G "https://fanyi-api.baidu.com/api/trans/vip/translate" --data-urlencode "q=$QUERY" -d "appid=$APPID" -d "salt=$SALT" -d "from=auto" -d "to=$TARGET" -d "sign=$SIGN")  

	TRANSLATED_TEXT=$(echo $RESPONSE | jq -r '.trans_result[0].dst')  
	echo "$TRANSLATED_TEXT"
}

# xclip 系统不自带，需要安装。
#result=$(trans -b -e bing :zh-CN "$(xclip -o)")
result=$(baidu_translate "$(xclip -o)")
notify-send -i edit-find "选中文本的翻译结果" "$result"

echo $result | jq >/tmp/fanyi
wl-copy $result

# 系统热键设置为 Ctrl-Alt-K，执行此脚本。
# http://api.fanyi.baidu.com/manage/developer

exit
#------------------------------------

