#!/bin/bash
set -uo pipefail

# ===================== 配置 =====================
SRC_DIR="$HOME/nvtdshot"
DST_DIR="$HOME/tdshot"
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
CHECK_SCRIPT="${SCRIPT_DIR}/check_screenshot.bash"
OCR_SCRIPT="${SCRIPT_DIR}/ocr-online.bash"
CONCAT_SCRIPT="${SCRIPT_DIR}/img-concat-wsl.bash"
CONCAT_OUT="${SCRIPT_DIR}/z_concat_vert.png"
WIN_PREVIEW="/mnt/d/z_concat_vert.png"
MIN_WIDTH=2000
# ================================================

# 校验依赖脚本
for s in "$CHECK_SCRIPT" "$OCR_SCRIPT" "$CONCAT_SCRIPT"; do
    if [[ ! -f "$s" ]]; then
        echo "错误：缺少脚本 $s"
        exit 1
    fi
done

mkdir -p "$SRC_DIR" "$DST_DIR"

# 安全获取*.png，按修改时间新→旧，兼容空格文件名
mapfile -t RAW_PNG < <(
    shopt -s nullglob;
    for f in "${SRC_DIR}"/*.png; do
        [[ "$f" == "${SRC_DIR}/tmp.png" ]] && continue
        stat --printf "%Y %n\n" "$f"
    done | sort -k1,1nr | cut -d' ' -f2-
)

IMG_LIST=()
for f in "${RAW_PNG[@]}"; do
    w=$(ffprobe -v error -select_streams v:0 -show_entries stream=width -of default=noprint_wrappers=1:nokey=1 "$f")
    if [[ "$w" =~ ^[0-9]+$ ]] && (( w >= MIN_WIDTH )); then
        IMG_LIST+=("$f")
    fi
done

if [[ ${#IMG_LIST[@]} -lt 2 ]]; then
    echo "有效图片不足2张，当前筛选数量：${#IMG_LIST[@]}"
    exit 1
fi

FILE_LAST="${IMG_LIST[0]}"    # 最新：失败结算界面（放上方）
FILE_PREV="${IMG_LIST[1]}"    # 上一张：战斗画面（放下方）
echo "最新图(失败结算界面，在上层)：$FILE_LAST"
echo "倒数第二张(战斗画面，下层)：$FILE_PREV"

# 画面检测校验
echo -e "\n[检测最新图是否为失败弹窗]"
OUT_LAST=$("$CHECK_SCRIPT" "$FILE_LAST")
echo "$OUT_LAST"
if ! echo "$OUT_LAST" | grep -q "MATCH"; then
    echo "❌ 最新图片未识别失败界面，终止"
    exit 1
fi

echo -e "\n[检测倒数第二张不是失败弹窗]"
OUT_PREV=$("$CHECK_SCRIPT" "$FILE_PREV")
echo "$OUT_PREV"
if ! echo "$OUT_PREV" | grep -q "NO_MATCH"; then
    echo "❌ 倒数第二张是失败界面，不符合要求，终止"
    exit 1
fi

# OCR识别结算图
echo -e "\n[执行OCR识别]"
OCR_TEXT=$("$OCR_SCRIPT" "$FILE_LAST")
echo "OCR文本："
echo "$OCR_TEXT"

# 提取波次
WAVE_NUM=$(echo "$OCR_TEXT" | grep -oP '你被第\K\d+(?= 波敌人击溃了)' | head -n1)
if [[ -z "$WAVE_NUM" ]]; then
    echo "❌ OCR未能提取失败波次"
    exit 1
fi

# 遍历tdshot目录匹配角色（反转匹配逻辑）
FIX_ID=""
CHAR_NAME=""
shopt -s nullglob
for file in "${DST_DIR}"/*.png; do
    fname="${file##*/}"
    if [[ "$fname" =~ ^([0-9]+)-(.+)-[0-9]+关\.png$ ]]; then
        tid="${BASH_REMATCH[1]}"
        tname="${BASH_REMATCH[2]}"
        if echo "$OCR_TEXT" | grep -q "$tname"; then
            FIX_ID="$tid"
            CHAR_NAME="$tname"
            break
        fi
    fi
done
shopt -u nullglob

if [[ -z "$FIX_ID" || -z "$CHAR_NAME" ]]; then
    echo "❌ 在 ${DST_DIR} 匹配失败：未在OCR文本中找到任一角色名称"
    exit 1
fi
echo "识别角色：$CHAR_NAME 失败波次：${WAVE_NUM}"

TARGET_NAME="${FIX_ID}-${CHAR_NAME}-${WAVE_NUM}关.png"
TARGET_PATH="${DST_DIR}/${TARGET_NAME}"
echo -e "\n目标最终成品路径：$TARGET_PATH"

# 执行垂直拼接【失败图在前（上方），战斗图在后（下方）】
echo "开始执行图片垂直拼接..."
"$CONCAT_SCRIPT" "$FILE_LAST" "$FILE_PREV"

if [[ ! -f "$CONCAT_OUT" ]]; then
    echo "❌ 拼接输出文件不存在：${CONCAT_OUT}"
    exit 1
fi

# 移动预览文件到D盘，不污染git目录
mv -f "${CONCAT_OUT}" "${WIN_PREVIEW}"

echo -e "\n预览图片已移至D盘：/mnt/d/z_concat_vert.png"
echo "请手动打开图片核对画面内容与目标文件名："
echo "目标成品：${TARGET_PATH}"
read -rp "确认无误，执行复制保存(y/N):" confirm
if [[ "${confirm,,}" != "y" ]]; then
    echo "用户取消操作，预览文件保留在D盘：${WIN_PREVIEW}"
    exit 0
fi

# 复制D盘预览文件到最终目录
cp -v "${WIN_PREVIEW}" "${TARGET_PATH}"
echo "✅ 文件已保存至：${TARGET_PATH}"

# 清理源目录截图
read -rp "确认删除 ${SRC_DIR} 内所有png文件？(y/N)" del_ans
if [[ "${del_ans,,}" == "y" ]]; then
    rm -f "${SRC_DIR}"/*.png
    echo "已清理源目录截图"
else
    echo "保留源目录截图"
fi

echo "全部流程结束"
exit 0