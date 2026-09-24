---
name: gama-invoice
description: Build a clean invoice or proforma from plain data (items, prices, VAT, buyer). Use when the user gives invoice details and asks to make an invoice/faktura/predracun, calculate VAT, line totals, and print-ready output.
---

# Invoice / Proforma

Turn plain data into a correct, print-ready invoice. **Math must be exact.**

## Inputs the user should provide

- Seller: name, address, tax/registration number
- Buyer: name, address, tax/registration number
- Invoice number, issue date, due date
- Currency and VAT rate
- Line items: description, quantity, unit, unit price (net or gross — ask which)
- Payment details (IBAN, reference, payment method)

If any of these are missing, ask **once**, in a single short list. Never guess tax numbers or account numbers.

## Calculation rules

1. Work **net** prices internally. If the user gives gross, back out net with `net = gross / (1 + vat)`.
2. Line total = `quantity × unit_price`.
3. Subtotal = sum of line totals.
4. VAT = `subtotal × vat_rate` (unless the invoice is exempt — then state the legal reason on the invoice).
5. Total = `subtotal + VAT`.
6. **Round to 2 decimals only at the end of each printed figure.** Round half-up.
7. Show the arithmetic: subtotal, VAT (rate), total. No hidden rounding.

## Output

1. A summary block: seller, buyer, number, dates, currency, VAT rate.
2. A line-items table: `# | description | qty | unit | unit price | line total`.
3. A totals block: Subtotal / VAT (x%) / **Total**.
4. Payment details.
5. Optional: a one-line "amount in words" if the user asks.

## Rules

- Never invent a VAT rate — use the one the user gives, or the standard rate of the country the user names.
- Mark a proforma clearly as **"PROFORMA — not a tax document"** (or the local-language equivalent) unless the user says it is the final invoice.
- If numbers do not add up, stop and say exactly which two figures disagree.
