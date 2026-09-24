---
name: gama-pricing
description: Calculate selling prices, margins and markups from cost, and check if a price makes sense. Use when the user asks how much to charge, what the margin is, how to price a product/service, or to compute a markup or a discount.
---

# Pricing / Margin

Turn cost into a price with correct math, then sanity-check it.

## Formulas (state which one you use)

- **Markup** on cost: `price = cost × (1 + markup%)`
- **Margin**: `margin% = (price - cost) / price × 100`
- **Price from target margin**: `price = cost / (1 - margin%)`
- **Discount**: `new_price = price × (1 - discount%)`
- **Breakeven units** = `fixed_costs / (price - variable_cost_per_unit)`

**Markup ≠ margin.** The user must say which one they mean. If ambiguous, compute both and label them clearly.

## Output

1. Inputs: cost breakdown (purchase, shipping, packaging, fees, tax).
2. Calculation with the exact formula used.
3. Price recommendation (VPC = wholesale, MPC = retail, both with VAT if the user is VAT-registered).
4. At least 3 price points: cost-covering, market-typical, premium.
5. A one-line check: "At this price and margin, breakeven is X units / X months."

## Rules

- Never invent a VAT rate — use the country's standard rate if the user names the country (e.g. Bosnia 17%).
- Include payment-processor fees and shipping in the *variable* cost when selling online.
- Round to 2 decimals at the end only; show full math.
- Flag clearly if the resulting margin is below ~15% (thin, risky) or above ~60% (may lose sales).
