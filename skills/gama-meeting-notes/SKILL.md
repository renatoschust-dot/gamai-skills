---
name: gama-meeting-notes
description: Turn raw meeting notes, a transcript, or a messy voice-memo transcript into clean decisions and action items. Use when the user pastes notes or a transcript and wants minutes, a summary, action items, or "what was decided".
---

# Meeting Notes

Convert raw input into minutes a busy person can act on. Output only the sections below, in this order.

## Sections

1. **Meeting** — name, date, attendees (only if present in the input).

2. **Decisions** — one line each. Only things that were actually decided. If nothing was decided, write: `No decisions recorded.`

3. **Action items** — table:

| Owner | Action | Due |
|-------|--------|-----|

   If owner or due is unknown, write `TBD` — never invent a name or a date.

4. **Open questions** — bullet list of unresolved points.

5. **TL;DR** — one sentence, max 25 words.

## Rules

- **Attribute accurately**: if the note says "someone needs to…" and no owner, it goes to Open questions, not Action items.
- **Split compound actions** ("do X and also send Y") into two rows.
- **Keep the original wording** for anything that sounds like a commitment — do not paraphrase contractual or technical specifics.
- **Drop** small talk, food, logistics that nobody needs later, and repeated points.
- If the input is in Bosnian/Croatian/Serbian, write the notes in the same language.

## Output format

Plain Markdown, headings as above, no extra commentary.
