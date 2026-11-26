---
name: gama-stream
description: GAMA Stream — control-first low-latency WebRTC/WHEP streaming and remote input. Use when the user asks to stream a screen, control a machine remotely, test WebRTC/WHEP, measure input RTT, or use the GAMA media stack (MediaMTX, coturn, Vast NVENC, Tailscale).
---

# GAMA Stream

## Kada koristiti
- "streamuj ekran", "remote control", "WebRTC", "WHEP", "latency", "input RTT"
- "gama stream", "pusti Vast", "kontroliši podrum/dispečer"
- Testiranje video/input lanca na floti.

## Arhitektura
```
Host capture (X11/DXGI) -> NVENC/QSV -> RTSP -> MediaMTX :8554
MediaMTX WebRTC/WHEP :8889 (ICE 8189) -> browser <video>
Browser input -> WebSocket :7333 -> OS input (XTEST/SendInput)
Tailscale = transport; TURN/coturn = relay fallback
```
Control-first: input ide odvojeno; video se dropuje/degradira prije kontrole.

## Fajlovi / servisi (Contabo)
- MediaMTX: `gama-mediamtx` Docker, `:8554/:8889/:8189/:9997`; config `/opt/gama-stream/mediamtx.yml`.
- coturn: systemd, `:3478/:5349`, config `/etc/turnserver.conf`.
- Web: `gama-stream-web` systemd, `:8077`, root `/opt/gama-stream/web`.
- Secrets: `/opt/gama-stream/secrets.env` (600) — nikad ne ispisivati.
- Report: `/opt/gama-stream/PHASE0_REPORT.md`.

## Host (Vast)
- `run_xterm.sh`, `run_agent.sh`, `run_pub.sh`, `run_pub_low.sh` u `/opt/gama-stream/agent/`.
- `run_pub.sh` -> `live_vast` 1080p30; `run_pub_low.sh` -> `live_vast_low` 640x360/350k.
- Input agent `gama_stream_agent.py` na `127.0.0.1:7333`; Tailscale Serve `http://gama-vast...:8088`.
- Windows agent `gama_stream_agent_win.py` (SendInput); podrum `:7333`.

## Korišćenje
- 1080p: `http://<node-ip>:8077/go.html` (tailnet)
- 360p: `http://<node-ip>:8077/go_low.html`
- WHEP test: `python3 /opt/gama-stream/whep_probe.py live_vast`
- Input test: `python3 /opt/gama-stream/input_rtt.py` (Vast tunnel) ili `win_input_test.py`.
- Provjera: `curl -u $MTX_USER:$MTX_PASS http://127.0.0.1:9997/v3/paths/list`.

## Pravila
- Ne izlagati HC shell kroz stream; input mapirati samo na miš/tastaturu.
- Ne dirati dispečer miš/tastaturu bez dozvole; koristiti podrum/server/kuća za test.
- Javni portovi su blokirani; koristi Tailscale/tunel. Za spolja treba VPS/443 relay.
- Vast/lab su daleko; za game streaming koristi GPU bliže korisniku.
- Windows input traži otključanu interactive sesiju.

## Dokazano (2026-10-25)
- 1080p WHEP + 360p/350k WHEP rade; browser video 1920x1080/4.2 Mbps.
- Browser → WS → XTEST upisao `BROWSER` u xterm.
- Input RTT: Vast ~117 ms (Tailscale), podrum ~69–92 ms.
- Vast NVENC 4× realtime 1080p60; lab 1660S 9.2×.
