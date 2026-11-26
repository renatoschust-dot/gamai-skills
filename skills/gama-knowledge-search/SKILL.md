---
name: gama-knowledge-search
description: Use before any GAMA TRADE task to automatically search GAMA_TRADE_ZNANJE.md for relevant knowledge, procedures, rules, and configuration. Ensures agents follow correct procedures and avoid known pitfalls.
---

# GAMA Knowledge Search

Automatically search GAMA_TRADE_ZNANJE.md before every task to find relevant knowledge.

## When to Use
- Before any GAMA TRADE task (ponuda, račun, SQL, email, PostIS, RDP)
- When user asks about GAMA procedures, rules, or configuration
- When agent needs context about GAMA TRADE operations

## How to Use

### Step 1: Extract Keywords
From the user's request, extract 2-3 key terms:
- Task type: ponuda, račun, faktura, kalkulacija, postis, email
- Entity names: kupac, artikl, dobavljač
- Technical terms: SQL, VP2026, MP2026, FoxPro

### Step 2: Search Knowledge Base
```bash
grep -n -i "KEYWORD1\|KEYWORD2\|KEYWORD3" "D:\ai\GAMA_TRADE_ZNANJE.md"
```

### Step 3: Read Relevant Sections
From grep results, read specific lines:
```bash
read "D:\ai\GAMA_TRADE_ZNANJE.md" offset=START_LINE limit=50
```

### Step 4: Apply Knowledge
Use the found information to:
- Follow correct procedures
- Apply proper rules (e.g., PDV always on ponude)
- Use correct paths and configurations
- Avoid known pitfalls

## Common Search Patterns

| Task | Search Keywords |
|------|-----------------|
| Ponuda | ponuda, PDF, HTML, email, PDV |
| Račun | račun, faktura, VP2026, kalk |
| SQL | SQL, server, vp2026, mp2026, kupdob, mat |
| PostIS | PostIS, naljepnica, poštar, adresa |
| Email | SMTP, email, sumeja, gamatrade |
| RDP | RDP, KASA, FoxPro, rdpdo |
| Marketing | SEO, WordPress, gamatrade.ba |

## Example Flow

User: "Napravi ponudu za ALFA HADŽIĆI"

1. Search: `grep -n -i "ponuda\|ALFA\|PDV" D:\ai\GAMA_TRADE_ZNANJE.md`
2. Found: "PONUDE — UVIJEK SA PDV" rule
3. Found: ponuda workflow in §19
4. Apply: Create ponuda with PDV columns, follow workflow

## Integration with Other Skills
- `gama-ponuda-workflow`: Use knowledge search before generating ponuda
- `vp2026-workflow`: Use knowledge search before VP2026 operations
- `agent-rdp`: Use knowledge search before RDP/KASA tasks

## Key Files
- **Main Knowledge**: `D:\ai\GAMA_TRADE_ZNANJE.md` (1330+ lines)
- **Skills Directory**: `C:\Users\User\Documents\Default Project\.agents\skills\`
- **Working Directory**: `C:\Users\User\AppData\Local\Temp\gama_offer\`

## Rules to Remember
1. **NE učitavaj cijeli ZNANJE.md** — grep pa read offset/limit
2. **UVJEK SA PDV** na ponudama
3. **PostIS iz ADRESARA** — nikad ručno
4. **Naljepnice po JEDNU** — ne 4 odjednom
5. **Bosanski jezik ijekavica** — sva komunikacija
