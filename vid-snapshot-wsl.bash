#!/bin/bash
set -euo pipefail
# WSL环境检测
is_wsl=0
[[ -f /proc/version ]] && grep -qi microsoft /proc/version && is_wsl=1

usage() {
cat <<EOF
用法: $0 时间点 视频文件路径
功能：从视频指定时间点提取单帧快照
支持路径格式：
  Windows拖拽路径："D:\录屏\video.mp4"
  WSL Linux路径：/mnt/d/录屏/video.mp4
示例:
  $0 00:01:23 "D:\Nvidia截图\test.mp4"
  $0 15.5 /mnt/d/Nvidia截图/test.mp4
输出: 当前目录 output-\$安全时间.png（冒号自动替换为下划线）
EOF
}
# 参数检查
if [ $# -ne 2 ]; then
    usage
    exit 1
fi
TIME_ARG="$1"
RAW_FILEPATH="$2"
# 路径转换函数：自动识别Windows路径(D:\xxx) / WSL Linux路径
normalize_wsl_path() {
    local p="$1"
    if [[ $is_wsl -eq 1 && "$p" =~ ^[A-Za-z]:[\\/] ]]; then
        wslpath -u "$p"
    else
        echo "$p"
    fi
}
# 转换路径
SRC_VIDEO=$(normalize_wsl_path "$RAW_FILEPATH")
# 判断文件存在
if [ ! -f "$SRC_VIDEO" ]; then
    echo "错误：找不到视频文件 -> $SRC_VIDEO"
    exit 1
fi
# 时间冒号转下划线，规避Windows文件名非法字符
SAFE_TIME="${TIME_ARG//:/_}"
# 改动：取消视频目录，输出到当前工作目录
OUT_FILE="${PWD}/output-${SAFE_TIME}.png"
echo "视频源: $SRC_VIDEO"
echo "快照时间: $TIME_ARG"
echo "输出文件: $OUT_FILE"
echo "===================================="
ffmpeg -ss "$TIME_ARG" -i "$SRC_VIDEO" \
    -vframes 1 \
    -q:v 2 \
    -y \
    "$OUT_FILE"
echo "✅ 快照提取完成"