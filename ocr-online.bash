#!/bin/bash
set -o pipefail

if [[ $# -ne 1 ]]; then
    echo "用法：ocronline 图片文件路径"
    exit 1
fi
IMG="$1"

# 先判断文件是否存在
if [[ ! -f "$IMG" ]]; then
    echo "错误：文件不存在 -> $IMG"
    exit 1
fi

# 通过mime-type校验是否为图片
MIME=$(file --mime-type -b "$IMG")
if [[ ! "$MIME" =~ ^image/ ]]; then
    echo "错误：不是图片文件，MIME类型：$MIME"
    exit 1
fi

curl -s -m 20 -X POST \
-F "apikey=helloworld" \
-F "language=chs" \
-F "OCREngine=2" \
-F "file=@${IMG}" \
https://api.ocr.space/parse/image \
| jq -r '.ParsedResults[0].ParsedText // "识别无结果"' \
| sed '/^[[:space:]]*$/d'