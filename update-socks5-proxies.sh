#!/bin/bash
set -euo pipefail

# ===================== 可配置区 =====================
PROXY_LIST_URL="https://cdn.jsdelivr.net/gh/proxifly/free-proxy-list@main/proxies/protocols/socks5/data.txt"
TEST_URL="https://ip.sb"
TEST_TIMEOUT=3
CHAIN_MAX_COUNT=3          # 配置内固定输出3条，仅第1条启用，2、3注释
MAX_PARALLEL=20
WORK_DIR="$HOME/.proxychains"
AVAILABLE_PROXIES="$WORK_DIR/available-proxy-list.txt"
PROXYCHAINS_CONF="$WORK_DIR/ss5-temp.conf"
BIN_PATH="$HOME/bin"

# 原始列表持久存放工作目录
ORIG_FILE="$WORK_DIR/original-proxy-list.txt"
# /tmp临时文件不自动删除
TMP_CLEAN="/tmp/clean-raw.txt"
TMP_TOP="/tmp/top-working-proxy.txt"
# ====================================================

mkdir -p "$WORK_DIR"
mkdir -p "$BIN_PATH"

# 缓存判断：文件存在且不足10分钟，跳过下载
REDOWNLOAD=1
if [[ -f "$ORIG_FILE" ]]; then
    file_age=$(date +%s -r "$ORIG_FILE")
    now=$(date +%s)
    age_min=$(( (now - file_age) / 60 ))
    if (( age_min < 10 )); then
        echo "📦 本地原始列表未过期（<10分钟），跳过下载"
        REDOWNLOAD=0
    fi
fi

if (( REDOWNLOAD == 1 )); then
    echo "📥 拉取新代理源: $PROXY_LIST_URL"
    if ! curl -sSL --connect-timeout 10 "$PROXY_LIST_URL" -o "$ORIG_FILE"; then
        echo "❌ 代理列表下载失败，退出"
        exit 1
    fi
fi

# 过滤保序去重，awk静默无输出
grep -E '^(socks5|http)://[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+:[0-9]+$' "$ORIG_FILE" 2>/dev/null \
    | awk '!seen[$0]++' > "$TMP_CLEAN"

# 测速函数
test_single_proxy() {
    local line="$1"
    local proto ip port curl_proto
    if [[ "$line" =~ socks5://([0-9.]+):([0-9]+) ]]; then
        proto="socks5"
        ip="${BASH_REMATCH[1]}"
        port="${BASH_REMATCH[2]}"
        curl_proto="--socks5-hostname"
    elif [[ "$line" =~ http://([0-9.]+):([0-9]+) ]]; then
        proto="http"
        ip="${BASH_REMATCH[1]}"
        port="${BASH_REMATCH[2]}"
        curl_proto="--proxy"
    else
        return
    fi

    if curl -s "$curl_proto" "$ip:$port" --connect-timeout "$TEST_TIMEOUT" --max-time $((TEST_TIMEOUT+2)) "$TEST_URL" >/dev/null 2>&1; then
        echo "$proto $ip $port" >> "$AVAILABLE_PROXIES"
        echo "✅ 可用 $proto://$ip:$port"
    else
        echo "❌ 失效 $proto://$ip:$port"
    fi
}

# 并发测速，收集满3个可用立刻停止遍历剩余条目
echo "🧪 并行测速，收集满${CHAIN_MAX_COUNT}个可用即终止测试"
> "$AVAILABLE_PROXIES"
while IFS= read -r entry; do
    if (( $(wc -l < "$AVAILABLE_PROXIES") >= CHAIN_MAX_COUNT )); then
        break
    fi
    test_single_proxy "$entry" &
    if (( $(jobs -r | wc -l) >= MAX_PARALLEL )); then
        wait -n
    fi
done < "$TMP_CLEAN"
wait

# 仅保留前3条可用，写入临时文件
head -n "$CHAIN_MAX_COUNT" "$AVAILABLE_PROXIES" > "$TMP_TOP"
valid_total=$(wc -l < "$TMP_TOP")
echo -e "\n📊 共收集 $valid_total 个可用代理，配置仅输出3条：第1条启用，后2条注释"

# 生成proxychains配置：固定3行，第1行无#，2、3行加#
cat > "$PROXYCHAINS_CONF" <<EOF
#strict_chain
dynamic_chain
proxy_dns
tcp_read_time_out 15000
tcp_connect_time_out 2000

[ProxyList]
EOF

line_num=0
while IFS=' ' read -r p_type p_ip p_port; do
    line_num=$((line_num + 1))
    if (( line_num == 1 )); then
        echo "$p_type  $p_ip  $p_port" >> "$PROXYCHAINS_CONF"
    else
        echo "#$p_type  $p_ip  $p_port" >> "$PROXYCHAINS_CONF"
    fi
done < "$TMP_TOP"

echo -e "\n✅ 代理配置已生成：$PROXYCHAINS_CONF"

# ===================== Bashrc 别名处理 =====================
rc_file="$HOME/.bashrc"
target_ss5="alias ss5='proxychains4 -f $PROXYCHAINS_CONF'"
target_update="alias ss5-update='$BIN_PATH/update-socks5-proxies.sh'"

update_alias_line() {
    local target_line="$1"
    local alias_name
    alias_name=$(echo "$target_line" | awk '{print $2}' | cut -d'=' -f1)

    if grep -Fxq "^alias $alias_name=" "$rc_file"; then
        sed -i.bak "\|^alias $alias_name=|c\\$target_line" "$rc_file"
        rm -f "${rc_file}.bak"
    else
        echo "$target_line" >> "$rc_file"
    fi
}

update_alias_line "$target_ss5"
update_alias_line "$target_update"

# 自动补全 ~/bin 到PATH
if [[ ! "$PATH" =~ "$BIN_PATH" ]]; then
    echo -e "\n📂 写入PATH：$BIN_PATH"
    echo "export PATH=\"$BIN_PATH:\$PATH\"" >> "$rc_file"
fi

# 不清理/tmp临时文件
echo -e "\n🎉 脚本执行完成！/tmp临时文件保留未清理"
echo "使用命令："
echo "  ss5-update    测速满3个即停止，conf输出3条，仅第一条生效，后两条注释"
echo "  ss5 curl ip.sb 命令行走链式代理"
echo "提示：浏览器请勿使用 ss5 firefox 启动，单独在Firefox配置SOCKS5单节点"
