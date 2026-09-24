---
name: self-healing-services
description: Keep local services, tunnels and background workers alive with a self-healing watchdog - single-instance mutex, port health checks, auto-restart, no admin required. Use when a service keeps dying, a tunnel drops, or you want a supervisor that repairs itself.
---

# Self-Healing Services

One supervisor that restarts everything that dies, within ~30s, without a human and without admin rights.

## Core pattern

1. **A single supervisor** loops every 30s:
   - for each target: is the port/health endpoint alive?
   - if not → start it, log the restart.
2. **Mutex / single instance** so two watchdogs never run at once (`Global\<App>Watchdog`).
3. **Never** auto-reboot or auto-shutdown the machine — only restart the failed process; report everything else.

## Windows (no admin)

- Use a hidden loop: `Start-Process` on a dead port, mutex to prevent duplicates, VBS/WScript launcher for silent start.
- With admin, prefer a Scheduled Task: `schtasks /Create /TN \<App>\Watchdog /TR "<cmd>" /SC ONLOGON /RL HIGHEST /F`.
- Log to a file and rotate it.

## Linux (systemd)

```ini
[Service]
Restart=always
RestartSec=5
StartLimitIntervalSec=0     # never give up
WatchdogSec=30
```
Verify: `systemctl show <svc> -p Restart -p RestartUSec` → `Restart=always`.

## Containers / non-systemd hosts

Use a supervisor (`supervisorctl`, `docker restart: unless-stopped`, or a small poll script) that hits `/health` and restarts on failure.

## Health contract (same shape everywhere)

```json
GET /health -> {"status":"ok","version":"x.y","uptime":1234}
```

## Diagnostics checklist

- Is there exactly **one** watchdog process?
- Is the port actually listening?
- What does the watchdog log say it last restarted, and when?
- Did the service crash-loop (start limit hit) or simply die once?

## Rules

- One watchdog, never two (mutex).
- Every restart is logged with timestamp + reason.
- Do not restart on a loop faster than every few seconds — back off, or you hide the real bug.
