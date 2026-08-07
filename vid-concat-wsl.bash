#!/bin/bash
set -euo pipefail
# WSL环境检测
is_wsl=0
[[ -f /proc/version ]] && grep -qi microsoft /proc/version && is_wsl=1

usage() {
cat <<EOF
用法: $0 视频1 视频2 [视频3 ...]
功能：无损顺序拼接多个同参数MP4视频（NVIDIA录制文件适用）
直接流拷贝，不重新编码，速度快
支持路径格式：
  Windows拖拽路径："D:\录屏\a.mp4"
  WSL Linux路径：/mnt/d/录屏/a.mp4
示例：
  $0 "D:\a.mp4" "D:\b.mp4"
  $0 "/mnt/d/1.mp4" "/mnt/d/2.mp4" "/mnt/d/3.mp4"
输出文件：当前目录 merged-out.mp4
注意：所有视频必须分辨率、帧率、音视频编码完全相同！
EOF
}
VIDEO_LIST=()
# 参数收集
while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help)
            usage
            exit 0
            ;;
        *)
            VIDEO_LIST+=("$1")
            shift
            ;;
    esac
done
# 至少两个视频
if [[ ${#VIDEO_LIST[@]} -lt 2 ]]; then
    echo "错误：至少传入2个视频文件！"
    echo
    usage
    exit 1
fi
# Windows路径转换函数
norm_path() {
    local p="$1"
    if [[ $is_wsl -eq 1 && "$p" =~ ^[A-Za-z]:[\\/] ]]; then
        wslpath -u "$p"
    else
        echo "$p"
    fi
}
CONVERTED=()
for raw in "${VIDEO_LIST[@]}"; do
    fp=$(norm_path "$raw")
    if [[ ! -f "$fp" ]]; then
        echo "文件不存在：$fp"
        exit 1
    fi
    CONVERTED+=("$fp")
done
# 改动：输出至当前工作目录，移除dirname
OUT="${PWD}/merged-out.mp4"
# 生成临时concat列表，写入绝对路径！
TMP_CONCAT=$(mktemp --suffix=.txt)
for f in "${CONVERTED[@]}"; do
    echo "file '$(realpath "$f")'" >> "$TMP_CONCAT"
done
echo "待合并文件列表："
printf " -> %s\n" "${CONVERTED[@]}"
echo "输出：$OUT"
echo "========================================"
# -c copy 流复制，不转码
ffmpeg -y -f concat -safe 0 -i "$TMP_CONCAT" -c copy "$OUT"
rm -f "$TMP_CONCAT"
echo "✅ 合并完成"