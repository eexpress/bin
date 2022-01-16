#!/usr/bin/bash

host=("global-ssl.fastly.net" "github.com" "github.global.ssl.fastly.net" "google.com" "twitter.com")

for i in "${host[@]}"; do
	dig @1.1.1.1 $i | grep -A 1 "ANSWER SECTION" | awk '{if($5) {sub(/\.$/,"",$1);printf("%s\t%s\n",$5,$1)}}'
done
#~ ---------- OUTPUT -------------
#~ 151.101.76.249	global-ssl.fastly.net
#~ 52.74.223.119	github.com
#~ 104.244.46.17	github.global.ssl.fastly.net
#~ 172.217.160.78	google.com
#~ 104.244.42.193	twitter.com
