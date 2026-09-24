# gamAI Skills

**992 production-ready Agent Skills** for Claude Code, Cursor, opencode, and any tool that speaks the Agent Skills format.

Each skill is a self-contained `SKILL.md`. Drop it in and your agent instantly gets a proven workflow.

## Install (Claude Code)

```
/plugin marketplace add renatoschust-dot/gamai-skills
```

## Install (manual / any agent)

Copy folders from `skills/` into:

- Claude Code: `.claude/skills/`
- opencode / Cursor / Windsurf: your skills directory
- any Agent Skills host: its skills folder

## What's inside

| Area | Skills | Examples |
|---|---|---|
| AI & agents | 60+ | agent orchestration, RAG, prompt engineering, MCP, evaluations |
| Development | 50+ | code review, testing, refactoring, APIs, git workflows |
| Web & design | 45+ | React, frontend, UI/UX, design systems, accessibility |
| Marketing & sales | 35+ | SEO, AEO, ads, copywriting, cold email, funnels |
| Data | 25+ | SQL, dbt, pandas, pipelines, analytics |
| DevOps & cloud | 30+ | Docker, Kubernetes, CI/CD, Terraform, AWS/GCP/Azure |
| HR | 35+ | hiring, interviewing, onboarding, performance |
| Legal | 15+ | contract review, GDPR, compliance |
| Business & finance | 15+ | pricing, cash flow, proposals, unit economics |
| Security | 10+ | OWASP, hardening, threat modeling, audits |
| Health, media, education | 25+ | medical, video/audio, image, teaching |
| And much more | 600+ | domain-specific playbooks |

## Signature skills (hand-written, tested)

| Skill | What it does |
|---|---|
| `task-dag` | Split a goal into 5-15+ branches; safety layer before any AI call |
| `self-healing-services` | Watchdog that keeps services/tunnels alive (no admin) |
| `report-with-images` | Finished DOCX + PDF report with real images in one command |
| `gama-invoice` | Invoices and proforma with exact VAT math |
| `gama-pricing` | Price / margin / markup with sanity checks |
| `gama-seo-audit` | 12-point on-page SEO audit with a prioritized fix list |
| `gama-contract-review` | Contract red-flag list with clause references |
| `gama-cold-email` | B2B cold outreach + follow-up that gets replies |
| `full-output-enforcement` | Force complete, unabridged output with no placeholders |
| `verification-before-completion` | Evidence before claims — run it, don't assume it |

## Why

Most "skill packs" are prompt dumps. These are narrow, tested, and boring on purpose — one job each, with an explicit output format, so an agent cannot drift.

## License

MIT — free to use and modify.

## Links

- Website: https://gamai.io
- Skill browser: https://gamai.io/gamai-skills
