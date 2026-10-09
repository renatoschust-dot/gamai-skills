#!/usr/bin/env bash
echo "== GAMA codespace setup =="
if ! command -v tailscale >/dev/null 2>&1; then curl -fsSL https://tailscale.com/install.sh | sh; fi
sudo pkill tailscaled 2>/dev/null || true
sudo nohup tailscaled --tun=userspace-networking --socks5-server=localhost:1055 --outbound-http-proxy-listen=localhost:1054 >/tmp/tsd.log 2>&1 &
sleep 3
if [ -n "$TS_AUTHKEY" ]; then sudo tailscale up --authkey="$TS_AUTHKEY" --hostname="$(hostname)"; else sudo tailscale up --hostname="$(hostname)"; fi
# nas HC daemon + worker s Contaba (kroz tailnet)
curl -fsSL --socks5-hostname 127.0.0.1:1055 "http://100.106.202.123:8123/gama_node_setup.sh" -o /tmp/gama_node_setup.sh && bash /tmp/gama_node_setup.sh
if ! command -v opencode >/dev/null 2>&1; then curl -fsSL https://opencode.ai/install | bash || true; fi
echo "== GAMA setup gotov =="
