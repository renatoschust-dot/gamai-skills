---
name: gama-sec-harness
description: Autonomni security harness (Anthropic defending-code-reference-harness) - threat-model -> recon -> vuln-scan -> triage -> patch sa execution-verifikacijom + detection&response (hunt/respond nad logovima). Koristi za dubinski pregled koda na ranjivosti, threat modeling, triage nalaza, generisanje i verifikaciju zakrpa, i D&R. Puni ono što nasi security-review/audit-code/senior-security skillovi rade manuelno.
---

# GAMA Security Harness

Referentni autonomni pipeline za pronalaženje i popravku ranjivosti (Anthropic, MIT).
Instaliran lokalno: **`$HOME/gamaos/tools/defending-code-harness`** (`pip install -e .` → komande `vuln-pipeline`, `dnr-pipeline`).

## Šta daje (preko naših postojećih skillova)
| Naš skill (manuelno) | Harness (autonomno, verifikovano) |
|---|---|
| `security-review`, `audit-code` | `/vuln-scan` + `vuln-pipeline` (recon→find→**execution-verified**→report→patch) |
| `senior-security`, threat modeling | `/threat-model` (STRIDE + severity politika → `threat_model.md`) |
| ručni triage | `/triage` + `vuln-pipeline dedup/report` |
| ručna popravka | `/patch` (+ `vuln-pipeline patch`, verifikuje da exploit više ne prolazi) |
| — | `/dnr-hunt` + `/dnr-respond` + `dnr-pipeline` (**detection & response**: pretraga log korpusa, scope štete, predlog odgovora) |

## Upotreba
```bash
cd $HOME/gamaos/tools/defending-code-harness
# 1) interaktivni skillovi (Claude Code / opencode): /quickstart /threat-model /vuln-scan /triage /patch /verify /dnr-hunt /dnr-respond
#    (definicije su u .claude/skills/*)

# 2) autonomni pipeline (CLI)
vuln-pipeline recon   <target>          # auto-otkrij fokus oblasti
vuln-pipeline run     <target>          # find + grade (izvršava ciljni kod -> TRAZI sandbox!)
vuln-pipeline dedup   <results-dir>     # grupiši po signature
vuln-pipeline report  <results-dir>     # exploitability izvještaj
vuln-pipeline patch   <results-dir>     # zakrpa + verifikacija

dnr-pipeline run      <dnr-target>      # hunt + grade nad logovima
```

## Sigurnost (obavezno)
- `/threat-model`, `/vuln-scan`, `/triage`, `/patch` nad **statičkim nalazima** (`TRIAGE.json`/`VULN-FINDINGS.json`) su **read/write-only → sigurni** nesandboxovani.
- **`vuln-pipeline` / `dnr-pipeline` / `/patch` nad pipeline rezultatima IZVRŠAVAJU ciljni kod** → **NIKAD** van sandboxa. Koristi `bin/vp-sandboxed` (gVisor setup: `scripts/setup_sandbox.sh`) ILI naš `gama_sandbox_srt.sh offline -- ...`.

## Portovanje na naš kod (Python/JS, ne samo C/C++)
Harness je referenca (default: C/C++ memory vulns + Docker + ASAN). Pokreni `/customize` da ga prilagodiš jeziku/detektoru/klasi ranjivosti. Generalni oblik, prompti i sandboxing su reusable.

## Napomena o `oss-scanner`
`anthropics/oss-scanner` NIJE lokalni skener — to je **servis**: prijavljuješ repo PR-om (javno, email u `project.yaml`) i Anthropic skenira na svojoj infra. **Zbog GAMA pravila #1 (nikad ne izlagati interno javno) NE prijavljuj naš repo.** Kopija je u `$HOME/gamaos/tools/oss-scanner/` — vrijedan je jedino `tools/check` (lokalno builduje tvoj Dockerfile u izolovanom VM bez mreže) kao **recept** za self-hosted skeniranje.
