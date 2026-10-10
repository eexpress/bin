#!/bin/bash
# usage: ./appimage-register.sh  文件A  文件B
# 次序无关，自动识别AppImage 和 png图标
# 示例: ./appimage-register.sh ~/icons/localsend.png ~/.local/bin/LocalSend.AppImage

# 接收两个参数
if [ $# -ne 2 ]; then
    echo "用法: $0 <AppImage 或 png图标> <另一个文件>"
    echo "参数顺序无所谓，脚本自动区分AppImage / PNG图片"
    echo "示例: $0 ~/.local/bin/LocalSend.AppImage ~/icons/localsend.png"
    exit 1
fi

P1=$(realpath -m "$1")
P2=$(realpath -m "$2")

APPIMG=""
ICONPATH=""

# 判断第一个文件类型
if [[ "$P1" =~ \.[Aa]ppImage$ ]]; then
    APPIMG="$P1"
elif [[ "$P1" =~ \.png$ ]]; then
    ICONPATH="$P1"
fi

# 判断第二个文件类型
if [[ "$P2" =~ \.[Aa]ppImage$ ]]; then
    APPIMG="$P2"
elif [[ "$P2" =~ \.png$ ]]; then
    ICONPATH="$P2"
fi

# 校验是否都识别成功
if [ -z "$APPIMG" ] || [ -z "$ICONPATH" ]; then
    echo "❌ 识别失败！必须一个是 *.AppImage，另一个是 *.png"
    echo "检测到："
    echo "  $P1"
    echo "  $P2"
    exit 1
fi

# 校验文件存在
if [ ! -f "$APPIMG" ]; then
    echo "错误：AppImage 文件不存在 -> $APPIMG"
    exit 1
fi
if [ ! -f "$ICONPATH" ]; then
    echo "错误：图标png不存在 -> $ICONPATH"
    exit 1
fi

# 自动添加执行权限
if [ ! -x "$APPIMG" ]; then
    echo "赋予AppImage执行权限..."
    chmod +x "$APPIMG"
fi

# 从png文件名提取应用名称（去掉后缀.png）
ICON_RAW=$(basename "$ICONPATH")
APPNAME="${ICON_RAW%.png}"

DESKTOP_FILE="$HOME/.local/share/applications/${APPNAME}.desktop"

# 写入desktop文件
cat > "$DESKTOP_FILE" <<EOF
[Desktop Entry]
Name=${APPNAME}
Exec=${APPIMG} %U
Icon=${ICONPATH}
Type=Application
Terminal=false
Categories=Network;FileTransfer;
StartupNotify=true
EOF

update-desktop-database "$HOME/.local/share/applications/"

echo "✅ 注册完成: $DESKTOP_FILE"
echo "👉 GNOME菜单搜索名称: $APPNAME"
echo "   Exec=$APPIMG"
echo "   Icon=$ICONPATH"
