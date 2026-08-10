#!/bin/bash
set -euo pipefail
# 使用方式: bash cut_video.sh input.mp4 "2:30+5;12:00+15;45:12+2"
if [ $# -ne 2 ];then
    echo "用法:"
    echo "  $0 源视频.mp4 \"2:30+5;12:00+15;45:12+2\""
    echo "格式规则：起始时间+持续秒数;起始时间+持续秒数"
    exit 1
fi
IN_FILE="$1"
SEG_STR="$2"
# 分割分段列表
IFS=';' read -ra SEGMENTS <<< "$SEG_STR"
idx=1
for seg in "${SEGMENTS[@]}"; do
    IFS='+' read -r start dur <<< "$seg"
    # 文件名把冒号换成横杠，防止系统报错
    safe_start="${start//:/\-}"
    safe_dur="${dur//:/\-}"
    # 改动：输出到当前工作目录
    out_name="${PWD}/cut${idx}_${safe_start}_${safe_dur}.mp4"
    echo "========================================"
    echo "[$idx] 开始: $start  时长: ${dur}s → $out_name"
    echo "ffmpeg -ss $start -t $dur -i \"$IN_FILE\" -c copy \"$out_name\""
    ffmpeg -y -ss "$start" -t "$dur" -i "$IN_FILE" -c copy "$out_name"
    idx=$((idx+1))
done
echo "全部裁剪完成"
