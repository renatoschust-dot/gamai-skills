# Architecture

gamAI is an agent runtime plus a library of reusable skills. The runtime decides, per request,
whether a deterministic path can answer (safety gate, SQL, skill match, screen control) before any
model call is made. Only when no deterministic path applies does it call an LLM.

```
user request
   |
   v
[risk gate] --block--> refuse (no model call)
   |
   v
[intent / domain router] --deterministic--> handler (SQL, skill, OS action)
   |                                   |
   | (no match)                        v
   v                              verified result
[LLM tool loop] --tools--> handler
   |
   v
[verification] -> answer / action
```

## Components

| Component | Responsibility |
|---|---|
| `router` | Classifies the request into a domain (sales, finance, code, ops, ...) using rules first, model second |
| `skills` | Each skill is a `SKILL.md` with YAML frontmatter (`name`, `description`) and a procedure. 992 public, 4500+ in the internal library |
| `tools` | SQL (read-only), files, browser (Playwright/CDP), screen control, messaging, documents |
| `risk gate` | Blocks destructive patterns (`rm -rf`, `DROP TABLE`, `mkfs`, shutdown) before any model call |
| `verification` | A claimed action is only accepted with evidence (file exists, row count, window title, OCR text) |
| `memory` | Vector memory (local embeddings) + case memory of successful trajectories |

## Design rules

1. **Determinism first.** If a rule can answer, no model is called. This makes cost and latency predictable.
2. **Tools are untrusted.** Every tool call is validated, and skill bundles are parsed as data, never executed as instructions.
3. **Evidence over assertions.** An agent may not report success without a verification step.
4. **Self-hostable.** Runs on a single small VPS with local models; cloud models are optional.
5. **Open formats.** Skills are plain Markdown with frontmatter; the runtime speaks the OpenAI-compatible API.
