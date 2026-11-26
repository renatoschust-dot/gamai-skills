# GAMA skills

**25 skills we actually use**, written here, for [opencode](https://opencode.ai), Claude Code and
any host that reads the Agent Skills format. Nothing third-party is bundled: earlier versions of
this repository carried 992 skills, 565 of which had no recorded origin, so their licence could not
be stated. That library is still in git history (tag `pre-gama-only-2026-11-26`).

Each skill is a directory with a `SKILL.md`: frontmatter (`name`, `description`), then the
procedure, the commands, and what the skill does **not** prove.

## Install

```bash
git clone https://github.com/renatoschust-dot/gamai-skills
cp -r gamai-skills/skills/* ~/.agents/skills/        # opencode / any Agent Skills host
cp -r gamai-skills/skills/* .claude/skills/          # Claude Code, per project
```

Plugin marketplace (Claude Code): `/plugin marketplace add renatoschust-dot/gamai-skills`

## What is inside

| Skill | What it does |
|---|---|
| `gama-accounting` | Use for accounting tasks - invoices, receipts, VAT, ledgers, financial reports. Trigger: "račun", "faktura", "predračun", "otpremnica", "PDV", "bil… |
| `gama-agent-factory` | "Izrada privatnih AI agenata za firme. Custom agent koji radi zadatke 24/7. Aktivira se na 'napravi agenta', 'ai agent za firmu', 'privatni agent',… |
| `gama-autonomous` | AUTONOMOUS AGENTS — Agents that work without supervision, make decisions, handle complex workflows. Self-healing, self-optimizing. |
| `gama-cli` | Jedinstveni GAMA CLI (`gama`) - sve radi preko jedne komande (CLI-Anything stil): mozgovi (ask/orchestrate/search/rag/sub), flota i HUMAN COMPUTE (… |
| `gama-customer-search` | Use when searching for customers/partners in GAMA TRADE database. Handles customer lookup, JIB/PDV search, address verification. Trigger: "traži ku… |
| `gama-email` | Use when sending emails via SMTP for GAMA TRADE. Handles email composition, attachment sending, and email templates. Trigger: "posalji email", "ema… |
| `gama-google-ads` | Google Ads oglašavanje za GAMA TRADE — kampanje, ključne riječi, budžet, mjerenje, API. Aktivira se na 'Google Ads', 'kampanja', 'ključne riječi',… |
| `gama-hc-harness` | Human Compute (HC) automation harness — deterministički upravlja računarom (klik, kucanje, čitanje ekrana) preko UI Automation prvo, pa koordinate,… |
| `gama-inventory` | Upravljanje zalihama za GAMA TRADE — stanje, ulaz robe, izlaz robe, reklamacije, inventura, SQL upiti za zalihe. Aktivira se na 'zalihe', 'stock',… |
| `gama-knowledge-search` | Use before any GAMA TRADE task to automatically search GAMA_TRADE_ZNANJE.md for relevant knowledge, procedures, rules, and configuration. Ensures a… |
| `gama-omni` | MASTER ORCHESTRATOR — Handles ANY task automatically. Routes to best skills, learns new ones if needed, self-organizes. Use this for EVERYTHING. Th… |
| `gama-pdv` | PDV u Bosni i Hercegovini — obračun 17%, prijava PDV-a, ulazni/izlazni PDV, evidencija, ePorezi, rokovi, registracija. Aktivira se na 'PDV', 'porez… |
| `gama-ponuda-workflow` | Use when the user asks to generate a quotation/offer/ponuda for GAMA TRADE, create a price quote, send a commercial offer to a customer, or prepare… |
| `gama-predictive` | PREDICTIVE AI — Anticipates customer needs, predicts trends, foresees problems before they happen. 10x advantage through prediction. |
| `gama-racunovodstvo` | Računovodstvo za GAMA TRADE — knjiženje faktura, kontni plan, bilans, zaključci. Aktivira se na 'računovodstvo', 'knjiženje', 'bilans', 'kontni pla… |
| `gama-sandbox-srt` | Izoluj pokretanje nepouzdanog koda, skillova ili MCP servera preko Anthropic Sandbox Runtime (srt) - OS-level fs + mreza gate BEZ Docker kontejnera… |
| `gama-sec-harness` | Autonomni security harness (Anthropic defending-code-reference-harness) - threat-model -> recon -> vuln-scan -> triage -> patch sa execution-verifi… |
| `gama-self-organize` | SELF-ORGANIZING SYSTEM — Automatically organizes work, prioritizes tasks, manages time, optimizes workflows. The conductor of the orchestra. |
| `gama-seo` | Use for SEO optimization of gamatrade.ba - meta tags, schema markup, content optimization, AEO. Trigger: "SEO", "meta", "schema", "optimiziraj stra… |
| `gama-stock-check` | Use when checking stock availability, quantities, or prices in GAMA TRADE databases. Handles SQL queries for artikli, zalihe, cijene. Trigger: "ima… |
| `gama-stream` | GAMA Stream — control-first low-latency WebRTC/WHEP streaming and remote input. Use when the user asks to stream a screen, control a machine remote… |
| `gama-superbrowser` | Jedinstveni GAMA browser/devtools tool preko CDP (Chrome/Edge). Koristi ga kad treba otvoriti sajt, pročitati stranicu, KLIKNUTI element, popuniti/… |
| `gama-vmlab-lab` | Radi na GAMA vmlab (Lab VM) — pravi lokalni Docker daemon, gVisor, k3s, Firecracker mikro-VM sa KVM-om, gama-net bridge i GPU. Koristi kad treba iz… |
| `gama-whatsapp` | Use for WhatsApp bot operations, sending voice messages, or interacting with WhatsApp for GAMA TRADE. Trigger: "whatsapp", "pošalji poruku", "glaso… |
| `gama-wordpress` | Use for WordPress/gamatrade.ba operations - page editing, product updates, REST API calls. Trigger: "wordpress", "gamatrade.ba", "stranica", "proiz… |

## Honest notes

- These describe **how we work**, not a product: several assume GAMA's own services (`gama` CLI,
  Human Compute, the ERP). The addresses and credentials are not in this repository — the skills
  say which environment variable supplies them.
- None of them is a sandbox. A skill that automates a screen, a browser or SQL runs with the
  permissions of whoever invokes it; read it before you let an agent follow it.
- Two skills are large and load-bearing: `gama-hc-harness` (drive a GUI deterministically with
  verification) and `gama-superbrowser` (read/click a real page over CDP). Start there.

## License

MIT for everything in this repository — it is all authored here. See [`LICENSE`](LICENSE).
