#!/bin/bash
set -uo pipefail

# 配置区
CUT_IMG="cut.png"
REF_FILENAME="ref-crop-530-70-700-1020.png"
SCALE_W=2000
SSIM_THRESHOLD=0.88

# 获取脚本所在目录（$0路径）
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
REF_IMG="${SCRIPT_DIR}/${REF_FILENAME}"

# 参数检查
if [[ $# -ne 1 ]]; then
    echo "用法: $0 <图片路径>"
    exit 2
fi
INPUT="$1"
if [[ ! -f "${INPUT}" ]]; then
    echo "错误：文件不存在 → ${INPUT}"
    exit 2
fi
if [[ ! -f "${REF_IMG}" ]]; then
    echo "错误：参考文件不存在 → ${REF_IMG}"
    exit 2
fi

# 从 ref-crop-A-B-C-D.png 提取 A-B-C-D，再替换为 A:B:C:D
CROP_RAW="${REF_FILENAME#ref-crop-}"
CROP_RAW="${CROP_RAW%.png}"
# 横杠替换为冒号
CROP_STR="${CROP_RAW//-/:}"

# 简单合法性校验格式 W:H:X:Y
if [[ ! "${CROP_STR}" =~ ^[0-9]+:[0-9]+:[0-9]+:[0-9]+$ ]]; then
    echo "ERROR：无法从 ${REF_FILENAME} 解析合法crop参数"
    exit 3
fi
CROP_FILTER="scale=${SCALE_W}:-1,crop=${CROP_STR}"
echo "自动加载裁剪参数：crop=${CROP_STR}"

# 读取原图宽度，只允许原图宽度≥2000，禁止放大处理小图
SRC_WIDTH=$(ffprobe -v error -select_streams v:0 -show_entries stream=width -of default=noprint_wrappers=1:nokey=1 "${INPUT}")
if [[ -z "${SRC_WIDTH}" ]]; then
    echo "ERROR：无法读取图片尺寸"
    exit 3
fi
if (( SRC_WIDTH < SCALE_W )); then
    echo "ERROR：原图宽度 ${SRC_WIDTH} 小于 ${SCALE_W}，不允许放大，跳过处理"
    exit 4
fi

ffmpeg -y -hide_banner -loglevel error \
-i "${INPUT}" \
-vf "${CROP_FILTER}" \
"${CUT_IMG}"

# 校验cut.png是否合法图片
if ! ffprobe -v error "${CUT_IMG}" >/dev/null 2>&1; then
    echo "ERROR：裁剪输出图片损坏，裁剪区域超出原图范围"
    exit 3
fi

SSIM_RAW=$(ffmpeg -y -hide_banner -loglevel error \
-i "${CUT_IMG}" -i "${REF_IMG}" \
-filter_complex "[0:v][1:v]ssim=stats_file=-" \
-f null -)

SSIM_ALL=$(echo "${SSIM_RAW}" | grep -oP 'All:\K[\d.]+')
if [[ -z "${SSIM_ALL}" ]]; then
    echo "ERROR：无法提取SSIM数值"
    exit 3
fi

echo "SSIM = ${SSIM_ALL}"
IS_MATCH=$(echo "${SSIM_ALL} >= ${SSIM_THRESHOLD}" | bc)

if [[ "${IS_MATCH}" -eq 1 ]]; then
    echo "RESULT: MATCH ✅ 存在【返回/再试一次】按钮"
    RET=0
else
    echo "RESULT: NO_MATCH ❌ 未识别按钮"
    RET=1
fi

exit ${RET}