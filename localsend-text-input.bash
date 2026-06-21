#!/bin/bash
FILE="$HOME/.var/app/org.localsend.localsend_app/data/localsend_app/shared_preferences.json"
TEXT=$(jq -j -r '.["flutter.ls_receive_history"] | map(fromjson) | map(select(.fileType=="text")) | first | .fileName' "$FILE")
notify-send "LocalSend最后接受到的文字" "$TEXT"
exit

# wtype 和 xdotool 都不行了。
if [[ -n "$TEXT" && "$TEXT" != "null" ]]; then
    echo -n "$TEXT" | wl-copy
    wtype -M ctrl -P v -m ctrl
else
    notify-send LocalSend "未找到文本消息"
fi

