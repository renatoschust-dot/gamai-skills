#!/usr/bin/env bash
echo "== GAMA codespace setup =="
if ! command -v tailscale >/dev/null 2>&1; then
  curl -fsSL https://tailscale.com/install.sh | sh
fi
sudo pkill tailscaled 2>/dev/null || true
sudo nohup tailscaled --tun=userspace-networking --socks5-server=localhost:1055 >/tmp/tsd.log 2>&1 &
sleep 3
sudo tailscale up --hostname="$(hostname)" 2>&1 | head -3 || true
if ! command -v opencode >/dev/null 2>&1; then
  curl -fsSL https://opencode.ai/install | bash || true
fi
echo "== GAMA setup gotov =="
