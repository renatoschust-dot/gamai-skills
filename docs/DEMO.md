# Demo (reproducible in ~5 minutes)

The demo shows one workflow end to end: from a plain-language request to a verified result,
with the deterministic path visible.

## Prerequisites

- Python 3.12
- A model backend: local (Ollama / llama.cpp) or any OpenAI-compatible endpoint
- Optional: a PostgreSQL/SQL Server database for the SQL part

## Steps

1. **Clone and install**

   ```bash
   git clone https://github.com/renatoschust-dot/gamai-skills
   cd gamai-skills
   ```

2. **Pick a skill** — every skill is a folder with `SKILL.md`. The frontmatter tells the runtime when to use it:

   ```yaml
   ---
   name: quote
   description: Build a price quotation from customer and item data.
   ---
   ```

3. **Ask in plain language.** The runtime classifies the request, matches the skill, fills the inputs,
   produces the document and verifies that the file exists before reporting success.

4. **Verify.** The run log shows:
   - which path was taken (deterministic / LLM),
   - which tools were called,
   - the evidence for the final claim.

## What to look for

| Observation | Meaning |
|---|---|
| No model call for a SQL question | The deterministic path handled it |
| A destructive request is refused instantly | The risk gate runs before the model |
| The answer cites a file path / row count | Verification produced evidence |
| Same request twice gives the same result | Behavior is reproducible |
