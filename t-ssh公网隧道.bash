#!/bin/bash
export AUTOSSH_GATETIME=0
LOCAL_TARGET="0.0.0.0:80"
SSH_COMMON_OPTS=(
  -T
  -q
  -o ServerAliveInterval=45
  -o ServerAliveCountMax=3
  -o ExitOnForwardFailure=yes
  -o StrictHostKeyChecking=no
  -o UserKnownHostsFile=/dev/null
)
SUBDOMAIN="wsl-eexpss-2026"

echo "确定已经启用了本地http服务。"
echo "sudo python3 -m http.server 80 --bind 0.0.0.0"
echo "必须使用pkill autossh停止。"
echo "===== 公共SSH反向隧道 ====="
echo "1: localhost.run (随机域名，nokey匿名模式)"
echo "2: serveo.net (自定义子域名: $SUBDOMAIN)"
read -p "选择 [1/2]: " opt

case "$opt" in
1)
  echo "启动 localhost.run 隧道..."
  autossh -M 0 -R "80:$LOCAL_TARGET" nokey@localhost.run "${SSH_COMMON_OPTS[@]}"
  ;;
2)
  echo "启动 serveo.net 隧道，子域名 $SUBDOMAIN"
  autossh -M 0 -R "${SUBDOMAIN}:80:$LOCAL_TARGET" serveo.net "${SSH_COMMON_OPTS[@]}"
  ;;
*)
  echo "无效选项"
  exit 1
esac
