---
name: gama-sandbox-srt
description: Izoluj pokretanje nepouzdanog koda, skillova ili MCP servera preko Anthropic Sandbox Runtime (srt) - OS-level fs + mreza gate BEZ Docker kontejnera. Koristi kad treba pokrenuti tuđi/neprovjereni kod, skill iz biblioteke, MCP server, ili "sandbox", "izoluj", "nepouzdan kod", "block network", "deny read". Zamjena/olaksanje za Docker gama_sandbox.
---

# GAMA Sandbox (srt / bubblewrap)

Jedan sloj izolacije za SVE GAMA mašine. Node CLI `srt` + `bubblewrap` (Linux) ili `sandbox-exec` (macOS).
**Prednost nad Docker `gama_sandbox`:** nema kontejnera, nema image pull, startup ~ms, radi na svakom čvoru sa `bwrap`.

## Preduslovi (već instalirano na ovom čvoru)
- `npm i -g @anthropic-ai/sandbox-runtime` (CLI `srt`) · `apt install bubblewrap socat`
- **Ubuntu 24.04 fiks:** `/etc/sysctl.d/99-gama-sandbox.conf` → `kernel.apparmor_restrict_unprivileged_userns=0` i `kernel.unprivileged_userns_clone=1` (AppArmor inače blokira nested userns → `apply-seccomp: setgroups Permission denied`).

## Upotreba (omotač)
```bash
$HOME/gamaos/tools/gama_sandbox_srt.sh <profil> [--env SRT_DOMAINS=a.com,b.com] -- <komanda...>
```
Ili preko jedinstvenog CLI (preporučeno): **`gama sandbox <profil> -- <komanda...>`** (vidi skill `gama-cli`).
Profili:
- **offline** (default) — nema mreže; čita sve osim tajni (`~/.ssh`,`~/.aws`,`/etc/gama-harness.env`,`**/.env`,`**/*.pem`); piše samo u cwd + `/tmp`. → **za svaki nepouzdan kod/skill.**
- **readonly** — nema mreže; piše samo `/tmp` (repo netaknut).
- **net** — mreža SAMO na domene iz `SRT_DOMAINS`; strogi fs.
- **audit** — bez blokada + `SRT_DEBUG` (samo dijagnostika).

Primjeri:
```bash
# pokreni tuđi python skript bez mreže i bez pristupa tajnama
gama_sandbox_srt.sh offline -- bash -lc 'python3 /tmp/untrusted.py'

# MCP server: dozvoli samo github
gama_sandbox_srt.sh net --env SRT_DOMAINS=api.github.com,github.com -- node mcp-server.js

# skill iz biblioteke (neprovjeren)
gama_sandbox_srt.sh offline -- bash $HOME/.agents/skills/<skill>/scripts/run.sh
```

## Dokazano (2026-10-13, ovaj čvor)
- `offline`: `curl https://example.com` → **HTTP 000** (blokirano); `echo x > /etc/...` → **Read-only file system**; `cat ~/.ssh/id_ed25519` → **No such file** (maskirano).
- `net SRT_DOMAINS=example.com`: `curl https://example.com` → **HTTP 200** (prolazi kroz allowlist proxy).

## Pravila
- Nepouzdan kod/skill/MCP **NIKAD** ne pokretati golo — uvijek kroz `offline` (ili `net` sa minimalnim domenama).
- Ako treba mreža → navedi TAČNE domene, ne `*` (srt odbija `*` u allowlisti).
- Na Windows čvorovima srt ima `windows-install` (WFP filteri) — vidi `srt --help`.

## Status (2026-10-13)
| Čvor | srt | Wrapper | Dokaz |
|---|---|---|---|
| **contabo** (ovaj) | ✅ 0.0.79 | `$HOME/gamaos/tools/gama_sandbox_srt.sh` | offline HTTP000 / net example.com=200 |
| **oracle** | ✅ | `/opt/gama-bot/gama_sandbox_srt.sh` | tool `sandbox` sada `via:srt`; `2**10`=1024; `/etc` RO |
| **linux3** | ✅ (node22 u `/opt/node22`) | `/usr/local/bin/gama_sandbox_srt.sh` | offline HTTP000 / net=200 |
| **vast** | ❌ | (wrapper tu, ne radi) | host blokira userns (seccomp, bez CAP_SYS_ADMIN, sysctl RO) → srt **nemoguć** u Vast kontejneru; tamo Docker |
| kuca/podrum/server (Win) | — | — | koristiti `srt windows-install` (WFP) po potrebi |

MCP `gama_sandbox` (`/opt/gama-bot/gama_mcp_server.py`, `_t_sandbox`, marker **SRT_V1**): default image + `net=false` → **srt offline** (`via:"srt"`); `net=true` ili non-default image → **Docker** (`via:"docker"`).
