#!/usr/bin/env bash
set -o pipefail

# 关键修复：强制终端输入密码，规避ioctl错误
export GPG_TTY=$(tty)
GPG_OPTS=(
    -c
    --cipher-algo AES256
    --s2k-digest-algo SHA512
    --pinentry-mode loopback
)

usage() {
cat <<EOF
用法：
  加密: ${0##*/} <源文件/目录> <输出.tar.gpg>
  解密: ${0##*/} <xxx.tar.gpg>

示例：
  ${0##*/} /data/secrets secret.tar.gpg
  ${0##*/} secret.tar.gpg
EOF
}

if [[ $# -eq 2 ]]; then
    # 加密模式
    SRC="$1"
    OUT="$2"
    if [[ -e "$OUT" ]]; then
        echo "错误：输出文件【$OUT】已存在，禁止覆盖！"
        exit 1
    fi
    if [[ ! -e "$SRC" ]]; then
        echo "错误：源【$SRC】不存在"
        exit 1
    fi
    echo ">>> 加密打包：$SRC → $OUT"
    tar -cf - "$SRC" | gpg "${GPG_OPTS[@]}" -o "$OUT"
    ret=$?
    if [[ $ret -eq 0 ]]; then
        echo "✅ 加密完成"
    else
        echo "❌ 加密失败"
        [[ -f "$OUT" ]] && rm -f "$OUT"
        exit $ret
    fi

elif [[ $# -eq 1 ]]; then
    # 解密模式，释放到当前目录
    ARCH="$1"
    if [[ ! -f "$ARCH" ]]; then
        echo "错误：【$ARCH】不是有效文件"
        exit 1
    fi
    echo ">>> 解密释放至目录: $(pwd)"
    gpg --pinentry-mode loopback -d "$ARCH" | tar -xf -
    ret=$?
    if [[ $ret -eq 0 ]]; then
        echo "✅ 解密解压完成"
    else
        echo "❌ 解密/解压失败"
        exit $ret
    fi

else
    usage
    exit 1
fi