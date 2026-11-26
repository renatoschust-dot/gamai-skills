---
name: gama-cli
description: Jedinstveni GAMA CLI (`gama`) - sve radi preko jedne komande (CLI-Anything stil): mozgovi (ask/orchestrate/search/rag/sub), flota i HUMAN COMPUTE (hc), sandbox, find, health. Svaka komanda podrzava --json za agente. Koristi kad treba "preko CLI", "gama komanda", poslati zadatak, komandovati masinama, screenshot, otvoriti program, izolovano pokrenuti kod - umjesto rucnih curl/SSH poziva.
---

# GAMA CLI (`gama`) — sve preko jedne komande

`/usr/local/bin/gama` (python3, stdlib-only; radi na SVIM čvorovima, i gdje nema node). Instaliran: **contabo, oracle, linux3, vast** (izvor `$HOME/gamaos/tools/gama`).
Backend: `:7132` (unified) + `:7125` (harness) + `:7200` (fleet most) + srt sandbox.

## Komande
```bash
gama ask "..."                 # pametan odgovor (unified)
gama orchestrate "..."         # više mozgova (--engines, --mode)
gama search "..."              # web/memory (--mode --k)
gama rag "..."                 # lokalni RAG (<300ms)
gama sub <kind> "..."          # subagent
gama who [node]                # flota zdravlje (svi ili jedan)
gama nodes                     # alias za who
gama health                    # stanje servisa
gama inventory | agents
gama find "*.pdf" [--machine]  # fajlovi na floti (gama-find)
gama --json <sve>              # mašinski izlaz

# HUMAN COMPUTE (najbrže do ruke)
gama hc who                    # svi HC čvorovi
gama hc inv <node>             # inventar čvora (OS/RAM/disk/CLI)
gama hc apps <node>            # instalirani programi
gama hc findapp <node> <ime>   # gdje je program
gama hc open <node> <app>      # otvori + verifikuj (do_auto)
gama hc run <node> <prog>      # pokreni program
gama hc close <node> <app>
gama hc focus <node>           # aktivni prozor
gama hc type <node> "tekst"
gama hc click <node> <x> <y>   # tap
gama hc key <node> <Key>
gama hc shot <node> [out.png]  # screenshot -> fajl (vrati putanju)
gama hc shell <node> "komanda" # shell na čvoru (Linux/Windows)
gama hc chat <node> "tekst"    # chat preko HC do motorа
gama hc <node> <bilo koja HC komanda>   # generički (raw)
gama sync [node...]            # razvuci toolchain (gama+gama-find+srt+cli-hub) na sve cvorove (idempotentno)
```
Čvorovi: `dispecer server podrum kuca oracle linux3 contabo vast tablet`.

## Auto-sync + self-test (systemd, na contabo)
- **`gama-toolchain-sync.timer`** (dnevno + 5min nakon boota) → `toolchain_sync.py`: build kanonskih bundle-a + deploy na sve čvorove. **Content-hash** (ne md5 arhive → tar/zip nose mtime); preskače nepromijenjene; **offline čvor skip** (`alive()` 12s). Log: `tools/toolchain_sync.log`.
- **`gama-doctor.timer`** (dnevno 07:00 + 3min nakon boota) → `doctor_cron.sh`: `gama doctor --json` → `tools/doctor.log`; ako kritično → `tools/DOCTOR_ALERT.json`.
- Ručno: `gama sync` (sve ili `gama sync gcp server`).

## Sandbox (izolovano pokretanje)
```bash
gama sandbox offline -- bash -c 'python3 untrusted.py'   # bez mreže, bez tajni
gama sandbox net -- bash -c 'curl https://api.github.com' # + SRT_DOMAINS
gama sandbox readonly -- ...
```
Vidi skill `gama-sandbox-srt`.

## Primjeri (dokazano 2026-10-13)
```bash
gama hc shot linux3 /tmp/x.png        # -> {"ok":true,"file":"/tmp/x.png","bytes":1802025}
gama hc inv oracle                    # -> os/cpu/ram/disk/cores
gama hc shell oracle "uname -a"       # -> Linux instance-... aarch64
gama sandbox offline -- bash -c 'echo OK'
```

## Bonus: cli-hub (CLI-Anything katalog)
`pip install cli-anything-hub` → `cli-hub list` (blender, freecad, comfyui, gimp…), `cli-hub install <ime>`. Instaliran na Contabo. Sve je CLI → agent može zvati profesionalni softver.

## Self-test (doctor)
```bash
gama doctor            # provjeri cijeli sistem (unified/harness/fleet/HC/sandbox/tokeni/disk)
gama doctor --json     # za agente; exit 1 ako kriticno pada
```
Provjerava: unified :7132, harness :7125, fleet :7200, HC čvorove, srt sandbox, tokene, alate, disk. Dokaz 2026-10-13: **SVE U REDU** na contabo/oracle/linux3 (fleet 11/12, fails=['podrum']).

## Konfiguracija (env)
CLI čita redom: `~/.gama_api_keys.env` → `/etc/gama-harness.env` → `/etc/gama-cli.env` → `~/.gama_cli.env` (kasniji pobjeđuje), plus env varijable.
- **Tokeni:** `GAMA_HARNESS_TOKEN`, `GAMA_HC_TOKEN` (iz `/etc/gama-harness.env`).
- **Adrese:** `GAMA_UNI`, `GAMA_HAR`, `GAMA_FLEET`.
- **Lokalno (contabo):** `http://127.0.0.1:7132` / `http://127.0.0.1:7125`.
- **Remote čvorovi:** harness je iza `tailscale serve` → `https://contabo-vps.tailf8e6be.ts.net:7125` (+`:7132`, dodato `tailscale serve --bg --https=7132 http://127.0.0.1:7132`). Config u `/etc/gama-cli.env` (root) + `~/.gama_cli.env` (user, 600 — jer /etc 600 root ne čita običan user).
- Fleet most je običan HTTP: `http://<node-ip>:7200/fleet`.

## Rasprostiranje (svuda) — 2026-10-13
Instalater: `$HOME/gamaos/tools/install_toolchain.sh` (pakirano u `dist`/bundle). Postavlja: `gama`, `gama-find`, `gama_sandbox_srt.sh`, config (`/etc/gama-cli.env` + `~/.gama_cli.env`), apt depe (plocate/ripgrep/bubblewrap/socat), `pip`+`cli-hub`, i po potrebi node22+`srt` (arch-aware, PATH fix).

| Čvor | gama | gama-find | cli-hub | srt |
|---|---|---|---|---|
| contabo | ✅ | ✅ plocate | ✅ | ✅ radi |
| oracle | ✅ | ✅ plocate | ✅ | ✅ radi |
| linux3 | ✅ | ✅ plocate | ✅ | ✅ radi |
| gcp | ✅ | ✅ plocate | ✅ | ⚠️ instaliran (HC-shell home quirk) |
| vast | ✅ | ✅ plocate | ✅ | ❌ host blokira userns |
| dispecer (Win) | ✅ `C:\gama\gama.cmd` | ✅ es.exe (Everything) | ✅ | — (Linux-only) |
| server (Win) | ✅ | ✅ PowerShell fallback | ✅ | — |
| kuca (Win) | ✅ | ✅ PowerShell fallback | ✅ | — |
| podrum (Win) | — | — | — | offline (22 unreachable) |

**Windows:** `install.ps1` → `C:\gama\{gama,gama-find,gama.cmd}`, config `C:\gama-cli.env` + `%USERPROFILE%\.gama_cli.env`, PATH (`C:\gama`), `/etc/hosts` MagicDNS fallback, `pip install cli-anything-hub`. CLI je cross-platform (guarded `os.uname`/`statvfs`, `platform.node()`, `subprocess` umjesto `execvp` za find). Deploy bez SSH (dispecer nema inbound): preko HC shell, zip→base64 u chunkovima (`echo …>C:\Windows\Temp\g.b64` ×3 → `certutil -decode` → `Expand-Archive` → `install.ps1`).

Nove čvorove dodaj: Linux → `bash install.sh`; Windows → chunked b64 preko HC shell; bez-SSH čvor → isto preko HC (`gama hc shell <node> …`).

## Pravilo
- Za SVAKU akciju prvo `gama` komanda (ne ručni curl/SSH). `--json` obavezno kad poziva drugi agent/skripta.
- Tokeni se čitaju iz `/etc/gama-harness.env` / `~/.gama_api_keys.env` (env override: `GAMA_HARNESS_TOKEN`, `GAMA_HC_TOKEN`).
