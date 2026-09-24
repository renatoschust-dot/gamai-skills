---
name: trade-quote
description: Build a quote / estimate for a service job (repair, install, build, maintenance) from a description and rates - line items, labour, materials, margin. Use when a tradesperson or service business needs a professional job quote or estimate.
---

# Trade Quote

Turn a job description into a professional quote with correct math and no missing line.

## Structure

1. **Job** — short description, address/area, date, validity (e.g. 30 days).
2. **Scope** — bullet list of exactly what is included, and a short **excluded** list (what is NOT included). Exclusions prevent disputes.
3. **Line items:**

| # | Description | Qty | Unit | Unit price | Total |
|---|---|---|---|---|---|

4. **Cost blocks** — separate materials, labour, equipment, disposal, access/setup.
5. **Totals** — Subtotal / Discount (if any) / VAT / **Total**. Include VAT only if the business is VAT-registered.
6. **Terms** — payment (advance %), deadline, warranty, what voids the warranty.

## Formula rules

- Labour = `hours × rate`. If hours unknown, use a range (`est. 4-6 h`) and mark it `estimate`.
- Materials = `qty × unit price × (1 + waste%)`.
- Margin must be explicit: state markup or margin, not both mixed.
- Round only final figures; show the math.

## Rules

- Never invent prices — use `[cijena]` if the user did not give a rate.
- Mark clearly: **QUOTE (not final)** vs **FINAL**.
- One hidden cost is worse than a slightly higher price — always list access, disposal, permits.

## Output

The quote in the user's language, ready to send, plus a one-line summary: `Total ~X, margin Y%, valid Z days`.
