# gamAI Skills

**A growing library of production-ready Agent Skills for Claude Code, Cursor, opencode, and any tool that speaks the Agent Skills format.**

Each skill is a self-contained `SKILL.md` — drop it in and your agent instantly gets a proven workflow.

## Install (Claude Code)

```
/plugin marketplace add renatoschust-dot/gamai-skills
```

Then install any skill from this marketplace.

## Install (manual / any agent)

Copy a folder from `skills/` into:

- Claude Code: `.claude/skills/`
- opencode / Cursor / Windsurf: your skills directory
- any Agent Skills host: its skills folder

## Skills (22)

### Business & admin
| Skill | What it does |
|---|---|
| `gama-invoice` | Clean invoices and proforma documents from plain data |
| `gama-pricing` | Price / margin / markup math with sanity checks |
| `gama-meeting-notes` | Turn raw notes or transcripts into decisions + action items |
| `cash-flow-forecast` | Monthly cash-flow projection and the "when do I run dry" month |
| `trade-quote` | Professional job quote for service/trade work (scope, exclusions, terms) |

### Marketing, sales & content
| Skill | What it does |
|---|---|
| `gama-ads-copy` | Google Search + Meta ad copy variants to test |
| `gama-social-caption` | Platform-native posts for FB / IG / LinkedIn / TikTok |
| `gama-cold-email` | B2B cold outreach + follow-up sequence that gets replies |
| `email-sequence` | Onboarding / nurture / win-back drip sequences |
| `content-brief` | SEO content brief a writer can execute without guessing |
| `gama-seo-audit` | 12-point on-page SEO audit with a prioritized fix list |
| `whatsapp-business` | WhatsApp customer replies, qualification and follow-ups |

### Communication & negotiation
| Skill | What it does |
|---|---|
| `gama-email-writer` | Professional emails that get answers (replies, difficult messages) |
| `gama-negotiation` | Negotiation prep with numbers, BATNA and exact scripts |
| `gama-translate` | Faithful translation with terminology consistency (EN/DE/BS/HR/SR) |

### Legal & HR
| Skill | What it does |
|---|---|
| `gama-contract-review` | Contract red-flag list with clause references (not legal advice) |
| `job-description` | Job ad + interview questions + scoring rubric |

### Dev & operations
| Skill | What it does |
|---|---|
| `code-review-checklist` | PR review: correctness, security, data, perf — ranked with fixes |
| `self-healing-services` | Watchdog that keeps services/tunnels alive (mutex, port health, no admin) |
| `task-dag` | Split a goal into 5-15+ branches; safety layer before any AI call |
| `ocr-data-entry` | Images/PDFs → clean structured data (CSV/JSON/XLSX) |
| `report-with-images` | Finished DOCX + PDF report with real images in one command |

## Why

Most "skill packs" are prompt dumps. These are narrow, tested, and boring on purpose — one job each, with an explicit output format, so an agent cannot drift.

## License

MIT — free to use and modify. Attribution appreciated.

## Links

- Website: https://gamai.io
