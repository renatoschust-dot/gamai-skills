#!/usr/bin/env bash
# Optional GAMA devcontainer setup. Everything here is opt-in:
#   TS_AUTHKEY           — join your tailnet (unset: tailscale stays logged out)
#   GAMA_NODE_SETUP_URL  — HTTPS URL of a node setup script (unset: not fetched)
#   GAMA_NODE_SETUP_SHA256 — required with the URL; the download is executed only
#                            if its hash matches. Without both, nothing is run.
#
# Earlier versions fetched a script over plain HTTP from a LAN address and ran it
# as root on every container start, with no integrity check. That is removed.
set -euo pipefail
echo "== GAMA codespace setup =="

if ! command -v tailscale >/dev/null 2>&1; then
  curl -fsSL https://tailscale.com/install.sh | sh
fi

sudo pkill tailscaled 2>/dev/null || true
sudo nohup tailscaled --tun=userspace-networking --socks5-server=localhost:1055 \
  --outbound-http-proxy-listen=localhost:1054 >/tmp/tsd.log 2>&1 &
sleep 3
if [ -n "${TS_AUTHKEY:-}" ]; then
  sudo tailscale up --authkey="$TS_AUTHKEY" --hostname="$(hostname)"
else
  sudo tailscale up --hostname="$(hostname)"
fi

if [ -n "${GAMA_NODE_SETUP_URL:-}" ]; then
  if [ -z "${GAMA_NODE_SETUP_SHA256:-}" ]; then
    echo "GAMA_NODE_SETUP_SHA256 is required when GAMA_NODE_SETUP_URL is set" >&2
    exit 1
  fi
  case "$GAMA_NODE_SETUP_URL" in
    https://*) ;;
    *) echo "GAMA_NODE_SETUP_URL must be https:// (got: $GAMA_NODE_SETUP_URL)" >&2; exit 1 ;;
  esac
  tmp="$(mktemp)"
  curl -fsSL --socks5-hostname 127.0.0.1:1055 "$GAMA_NODE_SETUP_URL" -o "$tmp"
  if ! echo "$GAMA_NODE_SETUP_SHA256  $tmp" | sha256sum -c - >/dev/null 2>&1; then
    echo "sha256 mismatch for $GAMA_NODE_SETUP_URL — refusing to execute" >&2
    rm -f "$tmp"; exit 1
  fi
  bash "$tmp"
  rm -f "$tmp"
fi

if ! command -v opencode >/dev/null 2>&1; then
  curl -fsSL https://opencode.ai/install | bash || true
fi
echo "== GAMA setup gotov =="
