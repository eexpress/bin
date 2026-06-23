#!/bin/bash
set -euo pipefail

# ========== 常量配置 ==========
PAC_FILE="$HOME/.cache/temp_proxy.pac"
MAX_ACTIVE=3
TEST_TARGET="https://ip.sb"
TEST_TIMEOUT=2

# 按网址性质分组分行整理域名规则
KEYWORD_ARRAY=(
    # Google 全家
    'google*' 'gstatic' 'gmail'
    # 视频平台
    'youtube'
    # 验证码/社交图床
    'sstatic.net' 'recaptcha.net'
    'pinterest.com' 'pinimg.com'
    '*twitter' 'twimg' 'imgur.com'
    # 博客评论类
    'disqus.com' 'wordpress' 'blogspot'
    # 论坛/资源站
    'reddit.com' 'thepiratebay' 'wikipedia.org'
    # 短链接跳转
    'bit.ly' 'ift.tt' 't.co' 'ow.ly' 'goo.gl' 'j.mp'
    # Android应用分发
    'apkpure.com' 'apkmirror.com' 'f-droid.org'
    # 技术社区/开源/即时通讯
    'stackexchange' 'element.io' 'matrix.org'
    'github*.com' 'valadoc.org' 'mastodon.social'
)

# ========== 精准校验节点：连通且出口IP匹配节点IP才有效 ==========
check_socks_node() {
    local ip_port="$1"
    local node_ip="${ip_port%%:*}"

    local out_ip
    if ! out_ip=$(curl -s --max-time "$TEST_TIMEOUT" -x "socks5h://$ip_port" "$TEST_TARGET" 2>/dev/null); then
        echo "❌ $ip_port 连接超时/被拒绝"
        return 1
    fi

    out_ip=$(echo "$out_ip" | tr -d '[:space:]')
    if [[ "$out_ip" == "$node_ip" ]]; then
        echo "✅ $ip_port 校验通过，出口IP:$out_ip"
        return 0
    else
        echo "⚠️ $ip_port 连通但出口IP不匹配(返回:$out_ip)，本次跳过"
        return 1
    fi
}

# ========== 无参数：关闭系统代理并打印提示 ==========
if [[ $# -eq 0 ]]; then
    gsettings set org.gnome.system.proxy mode none 2>/dev/null || true
    echo "==================== 操作完成 & 使用说明 ===================="
    echo "✅ 已关闭GNOME系统代理，不再加载PAC分流规则"
    echo ""
    echo "如需启用代理分流，请传入代理列表文件执行："
    echo "  用法：$0 代理列表文件路径"
    echo "  功能：自动检测SOCKS5节点，筛选前3个有效节点生成PAC并配置系统代理"
    echo "  示例：$0 ~/socks5.list"
    echo "============================================================"
    exit 0
fi

LIST_FILE="$1"
[[ ! -f "$LIST_FILE" ]] && echo "❌ 文件不存在: $LIST_FILE" && exit 1

# ========== 读取文件，正则匹配有效socks行，自动忽略首尾空白 ==========
valid_nodes=()
# 正则捕获完整 socks5://ip:port
REG_FULL='socks5://([0-9]{1,3}\.){3}[0-9]+:[0-9]+'

while IFS= read -r line; do
    # 跳过空行、注释行
    [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue

    line_copy="$line"
    # 正则匹配提取节点，循环匹配一行内多个节点
    while [[ "$line_copy" =~ $REG_FULL ]]; do
        node_full="${BASH_REMATCH[0]}"
        ip_port="${node_full#socks5://}"
        echo "🔍 检测节点: $node_full"

        if check_socks_node "$ip_port"; then
            valid_nodes+=("SOCKS5 $ip_port")
            [[ ${#valid_nodes[@]} -ge "$MAX_ACTIVE" ]] && break 2 # 跳出两层循环
        fi
        # 截断已匹配内容，匹配该行下一个节点
        line_copy="${line_copy#*$node_full}"
    done
done < "$LIST_FILE" || true

# 拼接PAC代理分号分隔字符串
SOCKS_SEGMENTS="${valid_nodes[*]}"
SOCKS_SEGMENTS="${SOCKS_SEGMENTS// /; }"

# ========== 生成Firefox兼容PAC脚本 ==========
JS_KEYWORDS=$(printf "'%s', " "${KEYWORD_ARRAY[@]}")
JS_KEYWORDS="${JS_KEYWORDS%, }"

cat > "$PAC_FILE" <<JS
var socksPart = "${SOCKS_SEGMENTS}";
var keyword_array = [${JS_KEYWORDS}];
var proxyRule = socksPart + "; DIRECT";

function FindProxyForURL(url, host) {
    for (var i = 0; i < keyword_array.length; i++) {
        var item = keyword_array[i];
        var append = item.indexOf('.') !== -1 ? '' : '.*';
        if (shExpMatch(host, "*." + item + append) || shExpMatch(host, item + append)) {
            return proxyRule;
        }
    }
    return "DIRECT";
}
JS

# 权限修复
chmod 644 "$PAC_FILE"
chmod 755 "$(dirname "$PAC_FILE")"

# ========== 写入GNOME系统代理配置 ==========
PAC_URI="file://$PAC_FILE"
echo -e "\n==================== 检测结果 ===================="
if [[ -z "$SOCKS_SEGMENTS" ]]; then
    echo "⚠️ 未找到任何有效节点，PAC全部直连，系统代理已加载空规则"
else
    echo "✅ 可用代理队列：$SOCKS_SEGMENTS"
fi
echo "📁 PAC文件路径：$PAC_URI"

gsettings set org.gnome.system.proxy mode auto 2>/dev/null || true
gsettings set org.gnome.system.proxy autoconfig-url "$PAC_URI" 2>/dev/null || true

echo -e "\n✅ PAC生成完成，GNOME系统代理已自动配置完毕"
