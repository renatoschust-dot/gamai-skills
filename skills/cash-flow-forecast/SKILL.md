---
name: cash-flow-forecast
description: Build a simple cash-flow forecast for a small business - money in, money out, monthly balance, and where it runs dry. Use when the user asks "can I afford X", "will I make it to next month", or wants a cash-flow projection.
---

# Cash Flow Forecast

The question is never "is it profitable" — it is **"when does the money arrive vs leave"**.

## Structure

1. **Opening balance** — cash available today.
2. **Money in (inflows)** per month — with realistic delays:
   - Cash sales: same month.
   - Invoices: +30/+60 days if the customer pays on terms (do not count on day 1).
   - Loans/grants: on the stated date only.
3. **Money out (outflows)** per month — fixed vs variable:
   - Rent, salaries, subscriptions (fixed).
   - Suppliers, materials, taxes (variable; taxes due dates matter).
4. **Monthly net** = inflows − outflows.
5. **Closing balance** = opening + net (carried month to month).
6. **Lowest point** — the month with the smallest balance. That is the number that matters.

## Output

| Month | In | Out | Net | Balance |
|---|---|---|---|---|

Then: **"Lowest balance: X in [month]"**, and if it goes negative, "Gap of X in [month] — needs Y".

## Rules

- Use conservative inflow timing (assume late payment, not early).
- Never invent amounts; use `[iznos]` placeholders.
- Separate one-off costs (equipment, deposits) from repeating costs.
- Flag any month with a negative closing balance **first**, before anything else.
