---
name: gama-contract-review
description: Review a contract or agreement for risks, unfair clauses and missing terms, and produce a red-flag list. Use when the user asks to review a contract, check terms, find risks, or understand a clause. This is not legal advice.
---

# Contract Review (red flags only)

Read a contract and return a prioritized risk list with exact clause references. **This is analysis, not legal advice** — say so once, then get to work.

## Output structure

**1. One-line verdict**
Can this be signed as-is, signed with changes, or do not sign — based on what is written.

**2. Red flags (ranked)**

| # | Clause (quote + section) | Risk | Suggested change |
|---|---|---|---|
| 1 | ... | ... | ... |

Rank by **money at stake × probability**, not by how scary the wording sounds.

**3. Missing terms** — what should be there but is not:
payment terms, delivery date, acceptance criteria, termination, liability cap, confidentiality, IP ownership, governing law, dispute resolution.

**4. One-sided terms to watch**
- Auto-renewal with a long notice window
- Unilateral price/scope change
- Uncapped liability or penalty
- Assignment without consent
- Non-compete too broad in time/scope

## Rules

- Quote the exact text; never paraphrase a clause you are flagging.
- Distinguish "unusual" from "risky" — flag both, label which.
- If a clause is standard for the jurisdiction, say so.
- Never invent clause numbers or missing text.
- End with: "This is not legal advice — for amounts above [X], have a lawyer review."
