# GAMA skills

**Ten general-purpose skills** — no company-specific business processes, no ERP, no customer data.
They work for anyone running an agent with a shell, a browser or a desktop: deterministic GUI control,
CDP browsing, sandboxing, lab automation, and the meta-skills that keep an agent organised.

Earlier versions of this repository carried 992 mixed third-party skills, then 35 including our
business ones. Those remain in git history (`pre-gama-only-2026-11-26`, `pre-general-2026-11-26`);
nothing here references a customer, an invoice workflow or an internal database.

## Install

```bash
git clone https://github.com/renatoschust-dot/gamai-skills
cp -r gamai-skills/skills/* ~/.agents/skills/        # opencode / any Agent Skills host
cp -r gamai-skills/skills/* .claude/skills/          # Claude Code, per project
```

## What is inside

| Skill | What it does |
|---|---|
| `gama-agent-factory` | Izrada privatnih AI agenata za firme. Custom agent koji radi zadatke 24/7. Aktivira se na 'napravi agenta', 'ai agent za firmu', 'privatn… |
| `gama-autonomous` | AUTONOMOUS AGENTS — Agents that work without supervision, make decisions, handle complex workflows. Self-healing, self-optimizing. |
| `gama-container-lab` | Container lab across remote hosts — Docker on Crusoe and Vultr instances, driven over the HC protocol. Use when you need a real container… |
| `gama-hc-harness` | Human Compute (HC) automation harness — deterministički upravlja računarom (klik, kucanje, čitanje ekrana) preko UI Automation prvo, pa k… |
| `gama-predictive` | PREDICTIVE AI — Anticipates customer needs, predicts trends, foresees problems before they happen. 10x advantage through prediction. |
| `gama-sandbox-srt` | Izoluj pokretanje nepouzdanog koda, skillova ili MCP servera preko Anthropic Sandbox Runtime (srt) - OS-level fs + mreza gate BEZ Docker… |
| `gama-sec-harness` | Autonomni security harness (Anthropic defending-code-reference-harness) - threat-model -> recon -> vuln-scan -> triage -> patch sa execut… |
| `gama-self-organize` | SELF-ORGANIZING SYSTEM — Automatically organizes work, prioritizes tasks, manages time, optimizes workflows. The conductor of the orchestra. |
| `gama-superbrowser` | Jedinstveni GAMA browser/devtools tool preko CDP (Chrome/Edge). Koristi ga kad treba otvoriti sajt, pročitati stranicu, KLIKNUTI element,… |
| `gama-teleport` | META-SKILL teleporta — "morph" skill za BRZO kreiranje novih GAMA skillova. Koristi D:\ai\gama_skill_gen.py (scan/search/make) + skill-ex… |

## Start here

- **`gama-hc-harness`** — drive a GUI deterministically (UIA first, coordinates, OCR) with a proof per
  action; YAML routes instead of guessing. The most useful one if you automate a desktop.
- **`gama-superbrowser`** — read and click a real page over CDP, a11y-first; no headless surprises.
- **`gama-sandbox-srt`** — run untrusted code with no network and no secrets, without Docker.
- **`gama-self-organize` / `gama-autonomous`** — how to structure a long-running agent task.
- **`gama-container-lab`** — a real Docker host on Crusoe or Vultr, driven over the fleet; k3s/Firecracker where KVM exists.

## Honest notes

- These are instructions for an agent, not audited code. A skill that automates a screen or a browser
  runs with the permissions of whoever invokes it.
- They assume the host has the tools they name (`bwrap`/`srt`, CDP-capable Chrome, a Linux desktop).
  Where a skill needs configuration it says so instead of shipping a default address.
- MIT, everything authored here.
