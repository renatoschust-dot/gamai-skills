---
name: code-review-checklist
description: Review a pull request or code change for bugs, security, performance and maintainability, and return findings ranked by severity with concrete fixes. Use when the user asks to review code, check a diff, or find problems in a change.
---

# Code Review

Find the things that will bite in production. Ranked, with a fix for each — not a style lecture.

## Order of review (do not skip)

1. **Correctness** — does it do what it claims? Edge cases: empty, null, zero, huge, concurrent.
2. **Security** — injection (SQL/command/template), path traversal, unsafe deserialization, secrets in code, missing auth/authorization, unsafe defaults.
3. **Data** — transactions, race conditions, idempotency, migrations that lose data, N+1 queries.
4. **Error handling** — swallowed exceptions, wrong status codes, retries without backoff.
5. **Performance** — O(n²), unbounded loops, missing indexes, sync I/O in hot paths.
6. **Maintainability** — naming, duplication, dead code, test coverage of the change.

## Output

| # | Severity | File:line | Problem | Fix |
|---|---|---|---|---|

Severity: **Blocker** (ship-stopper) · **Major** (fix before merge) · **Minor** (nice to have).

Then:
- **Blocker count: N.** If N > 0, say clearly: do not merge.
- **What is good** (2-3 lines) — real, not filler.

## Rules

- Every finding needs a concrete fix, not "consider refactoring".
- Quote the offending line.
- Do not invent line numbers or files you did not read.
- Do not flag style if a linter/formatter already handles it.
- If the change is clean, say so plainly — do not manufacture findings.
