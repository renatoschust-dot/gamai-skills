---
name: task-dag
description: Split one large goal into 5-15+ parallel sub-tasks (a DAG), run a deterministic reflex layer first (safety / SQL / skill / UI / fast-path), call AI only where needed, then verify each branch with evidence and merge. Use when a task should be parallelized across agents, cost must be kept low, or destructive actions must be blocked before any model call.
---

# Task DAG

Structure a hard goal as a directed graph of branches. **Deterministic trunk, AI only on the leaves that need it.**

## Flow

1. **plan** — decompose the goal into N branches (fan-out, e.g. `2,2,2` → 1 + 2 + 4 + 8 = 15 nodes).
2. **reflex** — every branch is classified *before* any model call:
   - `block` — destructive/risky (delete, wipe, drop, shutdown, format) → refuse without spending tokens
   - `sql` — answerable from a database
   - `skill` — a known procedure/reference exists
   - `ui` — a screen action (open/click/type)
   - `fastpath` — static answer
   - `ai` — only now call a model
3. **execute** — deterministic handler or the cheapest capable model.
4. **verify** — every branch must return **evidence** (a result, a row count, a screenshot hash). No evidence → retry, then drop the branch.
5. **merge** — join only verified branches.
6. **memory** — append findings to a log so the next run is cheaper.

## Why the reflex layer first

- Destructive input (`rm -rf /`, `DROP TABLE`, `shutdown`) is refused at ~50 ms with **zero** model cost.
- Most branches are SQL/skill/fastpath → the AI bill drops by an order of magnitude.

## Fan-out template

```
python task_dag.py "<goal>" --levels 2,2,2         # 15 nodes, simulated
python task_dag.py "<goal>" --levels 2,2,2 --real   # real workers
python task_dag.py "<goal>" --levels 3,2 --proliferate 3   # same sub-task on 3 channels, verifier picks the proven one
```

## Rules

- Safety check **before** AI. Always.
- No branch enters the final answer without evidence.
- Verification is a first-class step, not an afterthought.
- Keep internal plans out of public output.
- Prefer the cheapest model that can do the leaf; escalate only on failure.
