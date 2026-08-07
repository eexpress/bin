#!/bin/bash
set -euo pipefail
# 使用示例
# ./img2vid.sh ref.mp4 5 frame.png
# $1=参考视频 | $2=持续秒数 | $3=静态图片
if [ $# -ne 3 ]; then
	echo "图片转视频"
    echo "用法: $0 格式参考视频 持续秒数 图片文件"
    exit 1
fi
REF_VIDEO="$1"
DURATION="$2"
SRC_IMAGE="$3"
# 改动：输出至当前工作目录
OUT="${PWD}/img2vid.mp4"
# 文件存在性检查
if [ ! -f "${REF_VIDEO}" ]; then
    echo "错误：参考视频不存在 → ${REF_VIDEO}"
    exit 1
fi
if [ ! -f "${SRC_IMAGE}" ]; then
    echo "错误：输入图片不存在 → ${SRC_IMAGE}"
    exit 1
fi
declare -A stream
while IFS='=' read -r key val; do
    stream["$key"]="$val"
done < <(
ffprobe -v error -select_streams v:0 \
-show_entries stream=width,height,pix_fmt,r_frame_rate \
-of default=noprint_wrappers=1:nokey=0 "${REF_VIDEO}"
)
W="${stream[width]}"
H="${stream[height]}"
PIX_FMT="${stream[pix_fmt]}"
FPS_FRAC="${stream[r_frame_rate]}"
echo "【制式参数】"
echo "分辨率  : ${W}×${H}"
echo "像素格式: ${PIX_FMT}"
echo "帧率    : ${FPS_FRAC}"
ffmpeg -y \
-loop 1 -r "${FPS_FRAC}" -t "${DURATION}" -i "${SRC_IMAGE}" \
-f lavfi -t "${DURATION}" -i anullsrc=r=44100:cl=stereo \
-filter:v "scale=${W}:${H},format=${PIX_FMT}" \
-c:v libx264 -crf 23 -preset medium \
-c:a aac -b:a 128k \
"${OUT}"
echo "渲染完成：${OUT}"