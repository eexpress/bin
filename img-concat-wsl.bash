#!/bin/bash
set -euo pipefail
# WSL环境检测
is_wsl=0
[[ -f /proc/version ]] && grep -qi microsoft /proc/version && is_wsl=1

usage() {
cat <<EOF
========
图片拼接
========
用法: $0 图片1 图片2 [图片3...] [选项]
选项
  无参数选项，默认垂直拼接，使用图片的最小宽度
  -w N    垂直拼接，指定高度
  -h [N]  水平拼接，指定高度/自动获取图片最小高度
示例 (参数位置不限)
$0 "图1.png" "图2.png" -w 1920
$0 "图1.png" "图2.png" -h 1080
$0 "图1.png" "图2.png" -h
$0 "图1.png" "图2.png"
EOF
}
mode="vert"
target_size=0
files=()
# 读取全部参数
while (( $# > 0 )); do
    arg="$1"
    shift
    case "$arg" in
    -w) mode="vert" ;;
    -h) mode="hori" ;;
    [0-9]*) target_size="$arg" ;;
    *) files+=("$arg") ;;
    esac
done
# 至少两张图
if (( ${#files[@]} < 2 )); then
    echo "❌ 至少提供两张图片"
    usage
    exit 1
fi
# 路径转换 + 校验有效文件
srcs=()
for f in "${files[@]}"; do
    fp="$f"
    # 仅WSL执行windows路径转换，原生Linux跳过
    if [[ $is_wsl -eq 1 && "$fp" =~ ^[A-Za-z]: ]]; then
        fp=$(wslpath -u "$fp" 2>/dev/null)
    fi
    [[ -f "$fp" ]] && srcs+=("$fp")
done
if (( ${#srcs[@]} < 2 )); then
    echo "❌ 有效图片不足两张"
    exit 1
fi
echo "===== 输入图片尺寸信息 ====="
# 找出所有图片最小宽度
min_w=""
for p in "${srcs[@]}"; do
    dim=$(ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 "$p")
    w=${dim%x*}
    h=${dim#*x}
    echo "[$p] 分辨率: ${w} × ${h}"
    if [[ -z "$min_w" || $w -lt $min_w ]]; then
        min_w=$w
    fi
done
echo "============================="
base_w=$min_w
(( target_size > 0 )) && base_w=$target_size
# 滤镜
filter_parts=()
for i in "${!srcs[@]}"; do
    if [[ "$mode" == "vert" ]]; then
        filter_parts+=("[$i:v]scale=${base_w}:-1[s$i]")
    else
        filter_parts+=("[$i:v]scale=-1:${base_w}[s$i]")
    fi
done
stack=""
for i in "${!srcs[@]}"; do
    stack+="[s$i]"
done
if [[ "$mode" == "vert" ]]; then
    filter_parts+=("${stack}vstack=inputs=${#srcs[@]}")
else
    filter_parts+=("${stack}hstack=inputs=${#srcs[@]}")
fi
FILTER=$(IFS=';'; echo "${filter_parts[*]}")
# 改动：取消原文件同目录，统一输出到当前工作目录
outfile="${PWD}/z_concat_${mode}.png"
ff_args=()
for s in "${srcs[@]}"; do
    ff_args+=(-i "$s")
done
# ffmpeg，屏蔽所有输出
ffmpeg -y "${ff_args[@]}" \
-filter_complex "$FILTER" \
-q:v 2 \
-hide_banner \
-frames:v 1 \
"$outfile" >/dev/null 2>&1
[[ $? -ne 0 ]] && echo "❌ ffmpeg 渲染失败" && exit 1
# 打印最终尺寸
real_size=$(ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 "$outfile")
echo "✅ 输出：$outfile | 最终尺寸：${real_size}"