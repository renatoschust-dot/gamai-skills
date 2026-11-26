# GAMA skills

**35 skills we actually use**, written here, for [opencode](https://opencode.ai), Claude Code and
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
| `gama-accounting` | Use for accounting tasks - invoices, receipts, VAT, ledgers, financial reports. Trigger: "račun", "faktura", "predračun", "otpremnica", "… |
| `gama-agent-factory` | Izrada privatnih AI agenata za firme. Custom agent koji radi zadatke 24/7. Aktivira se na 'napravi agenta', 'ai agent za firmu', 'privatn… |
| `gama-android-vm` | Android virtuelna mašina na zahtjev — Redroid Android 13, ADB, Scrcpy, testiranje APK-ova. Aktivira se na 'android vm', 'testiraj apk', '… |
| `gama-auto-learn` | Automatically learns new skills when encountering unknown tasks. Searches internet, reads docs, creates reusable skills. The self-improvi… |
| `gama-autonomous` | AUTONOMOUS AGENTS — Agents that work without supervision, make decisions, handle complex workflows. Self-healing, self-optimizing. |
| `gama-cli` | Jedinstveni GAMA CLI (`gama`) - sve radi preko jedne komande (CLI-Anything stil): mozgovi (ask/orchestrate/search/rag/sub), flota i HUMAN… |
| `gama-computer-vision` | COMPUTER VISION — Understand images, documents, receipts, products. See and interpret the visual world. OCR, image analysis, document par… |
| `gama-customer-search` | Use when searching for customers/partners in GAMA TRADE database. Handles customer lookup, JIB/PDV search, address verification. Trigger:… |
| `gama-email` | Use when sending emails via SMTP for GAMA TRADE. Handles email composition, attachment sending, and email templates. Trigger: "posalji em… |
| `gama-google-ads` | Google Ads oglašavanje za GAMA TRADE — kampanje, ključne riječi, budžet, mjerenje, API. Aktivira se na 'Google Ads', 'kampanja', 'ključne… |
| `gama-hc-harness` | Human Compute (HC) automation harness — deterministički upravlja računarom (klik, kucanje, čitanje ekrana) preko UI Automation prvo, pa k… |
| `gama-inventory` | Upravljanje zalihama za GAMA TRADE — stanje, ulaz robe, izlaz robe, reklamacije, inventura, SQL upiti za zalihe. Aktivira se na 'zalihe',… |
| `gama-knowledge-search` | Use before any GAMA TRADE task to automatically search GAMA_TRADE_ZNANJE.md for relevant knowledge, procedures, rules, and configuration.… |
| `gama-omni` | MASTER ORCHESTRATOR — Handles ANY task automatically. Routes to best skills, learns new ones if needed, self-organizes. Use this for EVER… |
| `gama-ops-toolkit` | Jedinstveni GAMA operativni alatnik (2026-10-19) — svi agenti ga koriste. Sadrži: rezidencijalnu ruku (gama node — linux3, kućni BiH IP,… |
| `gama-pdv` | PDV u Bosni i Hercegovini — obračun 17%, prijava PDV-a, ulazni/izlazni PDV, evidencija, ePorezi, rokovi, registracija. Aktivira se na 'PD… |
| `gama-ponuda-workflow` | Use when the user asks to generate a quotation/offer/ponuda for GAMA TRADE, create a price quote, send a commercial offer to a customer,… |
| `gama-predictive` | PREDICTIVE AI — Anticipates customer needs, predicts trends, foresees problems before they happen. 10x advantage through prediction. |
| `gama-racunovodstvo` | Računovodstvo za GAMA TRADE — knjiženje faktura, kontni plan, bilans, zaključci. Aktivira se na 'računovodstvo', 'knjiženje', 'bilans', '… |
| `gama-revenue` | Revenue generation engine — finds ways to make money with AI, creates monetization strategies, builds income streams. Use when user menti… |
| `gama-sandbox-srt` | Izoluj pokretanje nepouzdanog koda, skillova ili MCP servera preko Anthropic Sandbox Runtime (srt) - OS-level fs + mreza gate BEZ Docker… |
| `gama-sec-harness` | Autonomni security harness (Anthropic defending-code-reference-harness) - threat-model -> recon -> vuln-scan -> triage -> patch sa execut… |
| `gama-self-organize` | SELF-ORGANIZING SYSTEM — Automatically organizes work, prioritizes tasks, manages time, optimizes workflows. The conductor of the orchestra. |
| `gama-seo` | Use for SEO optimization of gamatrade.ba - meta tags, schema markup, content optimization, AEO. Trigger: "SEO", "meta", "schema", "optimi… |
| `gama-smart-router` | MASTER SKILL — Automatically selects the right skill and approach for any GAMA TRADE task. Use at the start of any task to determine the… |
| `gama-sql-vp2026` | GAMA TRADE SQL radnik — verifikovani upiti nad vp2026/mp2026 bazama. Koristi za SVAKI upit o: šifri i cijeni artikla, stanju/zalihi, zadn… |
| `gama-stock-check` | Use when checking stock availability, quantities, or prices in GAMA TRADE databases. Handles SQL queries for artikli, zalihe, cijene. Tri… |
| `gama-stream` | GAMA Stream — control-first low-latency WebRTC/WHEP streaming and remote input. Use when the user asks to stream a screen, control a mach… |
| `gama-superbrowser` | Jedinstveni GAMA browser/devtools tool preko CDP (Chrome/Edge). Koristi ga kad treba otvoriti sajt, pročitati stranicu, KLIKNUTI element,… |
| `gama-teleport` | META-SKILL teleporta — "morph" skill za BRZO kreiranje novih GAMA skillova. Koristi D:\ai\gama_skill_gen.py (scan/search/make) + skill-ex… |
| `gama-video-studio` | AI video za socijalne mreže — Reels, TikTok, Shorts, kompresija, montaža, konverzija. Radi na GPU. Aktivira se na 'video za instagram', '… |
| `gama-vmlab-lab` | Radi na GAMA vmlab (Lab VM) — pravi lokalni Docker daemon, gVisor, k3s, Firecracker mikro-VM sa KVM-om, gama-net bridge i GPU. Koristi ka… |
| `gama-voice-first` | VOICE-FIRST INTERFACE — Talk to the system, voice commands, voice responses, hands-free operation. The future of interaction. |
| `gama-whatsapp` | Use for WhatsApp bot operations, sending voice messages, or interacting with WhatsApp for GAMA TRADE. Trigger: "whatsapp", "pošalji poruk… |
| `gama-wordpress` | Use for WordPress/gamatrade.ba operations - page editing, product updates, REST API calls. Trigger: "wordpress", "gamatrade.ba", "stranic… |

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
