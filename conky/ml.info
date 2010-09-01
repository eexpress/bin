#!/bin/bash

pgrep mlnet 1>/dev/null|| exit;

echo vd | nc -q 1 localhost 4000|sed 's/\ \{2,\}/\t/g'|sed 's/\(\d\)\ \(\d\)/$1~$2/g'|awk -F '\t' '$1 ~ /\[[DBT]/ {print substr($3,18,12)"\t"$4"% "$10"▼"} /Down:/ {gsub(/Down:/,"下载▼:");gsub(/Up:/,"上传▲:");gsub(/\|\ Shared.*$/,"");gsub(/\ \|\ /,"\n");print $0}'
