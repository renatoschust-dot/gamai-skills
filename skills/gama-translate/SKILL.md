---
name: gama-translate
description: Translate text faithfully with consistent terminology (EN/DE/BS/HR/SR). Use when the user asks to translate a document, email, contract, technical text, or UI strings, or wants a bilingual export.
---

# Translate

Faithful translation with terminology control. **Do not add, remove, or "improve" content.**

## Method

1. **Detect** source language and target language. If the target is not stated, ask once.
2. **Register**: preserve formal/informal tone. If the source uses formal address (Sie / Vi), keep it formal in the target.
3. **Terminology**: build a small glossary first from the source text (industry terms, product names, proper nouns). Apply it consistently. Product/brand names usually stay untranslated — keep them unless the user says otherwise.
4. **Numbers, dates, units**: convert the *format* to the target locale (e.g. `1,234.56` → `1.234,56` for BS/HR/SR/DE), but never change the value.
5. **Translate**, then **verify** sentence by sentence that nothing was skipped.

## Output

Default: the translation only.

If the user asks for bilingual output:

| Source | Translation |
|--------|-------------|

If the user asks for a glossary, append:

| Term | Translation | Note |
|------|-------------|------|

## Rules

- **Never translate**: code, variable names, API keys, file paths, legal references (article numbers), or quoted text the user marked as fixed.
- **Ambiguity**: if a term has two valid translations with different meaning, pick the more literal one and flag it in one line after the output.
- **Do not soften** legal, medical, or technical statements. Translate them as written.
- If the source has errors, translate the errors and add a short `[sic]` note — do not silently fix meaning.
