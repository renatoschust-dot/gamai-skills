---
name: gama-seo-audit
description: Run a 12-point on-page SEO audit on a page or a set of pages and return a prioritized fix list. Use when the user asks to audit SEO, check why a page does not rank, review meta tags, headings, internal links, or Core Web Vitals signals.
---

# SEO Audit (on-page, 12 checks)

Audit one page (or a list). Output a table plus a ranked fix list. No theory essays.

## The 12 checks

1. **Title tag** — 50-60 chars, primary keyword near the front, unique per page.
2. **Meta description** — 140-160 chars, includes the keyword, has a reason to click.
3. **H1** — exactly one, matches search intent, not identical to the title.
4. **Heading structure** — logical H2/H3 order, no skipped levels, keywords in some H2s.
5. **URL** — short, lowercase, hyphens, no IDs/junk params in the canonical.
6. **Canonical tag** — present, self-referencing, matches the live URL.
7. **Indexability** — robots meta, no accidental `noindex`, page not blocked in robots.txt.
8. **Internal links** — at least 2-3 contextual links in, descriptive anchor text (not "click here").
9. **Images** — real `alt` text, compressed, modern format, explicit width/height.
10. **Content depth** — does it answer the query fully? Flag thin pages (< 300 words of substance).
11. **Schema** — appropriate JSON-LD (Article / Product / FAQPage / LocalBusiness), valid, no errors.
12. **Performance signals** — LCP image size, render-blocking scripts, layout shift offenders.

## Output format

| # | Check | Status | Issue found | Fix |
|---|-------|--------|-------------|-----|

Then:

**Priority fixes (do these first)**
1. …

**Nice to have**
1. …

## Rules

- Mark each check `OK`, `WARN`, or `FAIL`. Never `OK` without evidence from the page.
- Every fix must be concrete: exact suggested title, exact alt text, exact link target.
- If you cannot verify a check (no access to the page), say `UNVERIFIED` — do not guess.
