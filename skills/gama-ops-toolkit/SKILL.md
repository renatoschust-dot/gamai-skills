---
name: gama-ops-toolkit
description: Jedinstveni GAMA operativni alatnik (2026-10-19) — svi agenti ga koriste. Sadrži: rezidencijalnu ruku (gama node — linux3, kućni BiH IP, za sajtove koji blokiraju datacenter), verifikator (gama verify — exact brojevi + NLI), evidence sistem (gama_evidence: bez dokaza = nepotvrđeno), HC file transfer (gama hc put/get/stat), idempotentne HC poslove (gama hc job), i keševe (retrieval L3, embedding L4, semcache 0.93). Koristi kad: treba kliknuti/otvoriti na mašini, sajt blokira IP, provjeriti da li je odgovor tačan, prenijeti fajl na čvor, pokrenuti komandu koja se ne smije izvršiti dvaput, ili ubrzati ponovljene upite.
---

# GAMA OPS TOOLKIT — svi agenti

> Pravilo: **LLM je zadnja instanca, ne prva.** Prvo deterministički alat, pa dokaz, pa odgovor.

## 1. Rezidencijalna ruka — `gama node`
Kad sajt blokira datacenter IP (AWS, hCaptcha, Cloudflare, DataDome), browser mora izaći
kroz kućnu liniju (linux3: 37.8.128.92, HT Mostar). CDP ide kroz SSH tunel, profil se briše.

```bash
gama node up --task mojzadatak        # -> CDP http://127.0.0.1:19333
gama node egress --task mojzadatak    # dokaz: IP/ASN/TZ kroz browser
gama node down --task mojzadatak      # ugasi + obriši profil
# ili automatski u sbrowse:
GAMACODE_NODE=linux3 GAMACODE_NODE_TASK=mojzadatak gama sbrowse open https://...
```
Python: `with Hand().via_node("linux3","mojzadatak") as n: ...`

## 2. Verifikator — `gama verify`
Bez dokaza nema „potvrđeno". Brojevi/šifre moraju biti **exact** u izvoru.

```bash
gama verify "Ukupno 1115 kupaca." "COUNT kupdob = 1115"
# -> {ok, ratio, missing_numbers, evidence_id, verdict}
```
Exit: 0 potvrđeno · 1 nepotvrđeno · 2 greška.

## 3. Evidence — `gama_evidence`
Svaki korak ostavlja dokaz (JSONL + SQLite). Harness `/chat` već vraća `evidence_id` i `verified`.

```python
from gama_evidence import record, verdict_ok
eid = record("sql", {"query_sha":"…","rows":3,"ms":42}, sid=sid)
verdict_ok([eid])   # True samo ako je confirmed
gama_evidence.py stats|tail|gc|check <id>
```

## 4. Prenos fajlova — `gama hc put|get|stat`
HC nema upload; ovaj alat dijeli na **64 KB** chunkove (ARG_MAX), sha256 + atomic mv.

```bash
gama hc put linux3 ./ponuda.pdf /tmp/ponuda.pdf
gama hc get linux3 /tmp/ponuda.pdf ./
gama hc stat linux3 /tmp/ponuda.pdf
```

## 5. Idempotentni HC posao — `gama hc job`
Ista komanda se ne izvršava dvaput (retry/dva agenta). `task_id = sha1(node|cmd)`, TTL 900 s.

```bash
gama hc job linux3 "open xterm"     # drugi poziv -> cached:true, isti evidence_id
gama hc jobstatus <task_id>
gama hc jobs 10
```
Python: `from gama_hc_job import job; job("linux3","open xterm")`

## 6. Keševi (brzina)
| Sloj | Gdje | Efekat |
|---|---|---|
| L3 retrieval | `gama_research._RET_CACHE` (TTL 600 s) | ponovljen upit **10,4 s → 0,0 s** |
| L4 embedding | `_emb_cache.db` (cross-process) | embed **~2 s → ~5 ms** |
| L2 semantic | `gama_semcache` THR **0,93** + antonim guard | parafraza bez LLM-a |
| Screenshot | `Hand.shot` cache 1,5 s | Windows **3,6 s → 0,0 s** u petlji |

## 6b. TOTP / MFA — `gama totp`
Kad tajnu MFA uređaja držimo mi, agent sam generiše kod (nema čekanja na čovjeka).

```bash
gama totp --name aws          # čita AWS_TOTP_SECRET iz $HOME/.gama_api_keys.env
gama totp --secret BASE32     # proizvoljna tajna
gama totp --uri "otpauth://totp/..."
gama totp --name aws --wait   # sačekaj svjež kod (>25s)
```
Tajna: `<IME>_TOTP_SECRET` (chmod 600). Backup tajne držati odvojeno (tablet/redroid/paper).

## 7. Determinizam — obavezno
- **Risk prvo:** `rm -rf`, `DROP TABLE`, `mkfs`, `shutdown` → blokirani **prije** modela (`RISK_GATE_FIRST_V2`).
- **Jedan IP = jedan identitet.** Nikad masovno pravljenje naloga sa kućnog IP-a.
- **linux3 nosi max 2 browser radnika** (7,8 GB RAM).
- **Sandbox** za nepouzdan kod: `gama sandbox offline -- bash -c '...'` (ima timeout/pids limit).
- Svaka akcija vraća dokaz: `{before_sha, after_sha, changed}` ili `{rows}` ili `{file, sha256}`.
