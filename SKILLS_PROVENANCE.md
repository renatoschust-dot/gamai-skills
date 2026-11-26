# Provenance and licensing of the skill library

This repository collects **992 `SKILL.md` files**. They did not all originate here, and the
frontmatter is the only record of where each one came from. This file states exactly what
that record says today, so nobody has to guess — and so a false licence claim is not made.

## What the frontmatter says (2026-11-26)

| | skills |
|---|---:|
| total | 992 |
| carry a `source:` field | 427 |
| **no `source:` field at all** | **565** |

| most common `source:` values | skills |
|---|---:|
| `community` (aggregate label, not a specific origin) | 254 |
| `self` (written here) | 33 |
| named upstream projects and URLs (e.g. `vibeship-spawner-skills`, `beingsmit/technical-product-gtm`, `amElnagdy/delegate-skills`, `coreyhaines31/marketingskills`) | ≈140 |

Reproduce with `python3 tools/provenance_report.py` (`--list` prints every unattributed
skill by name).

## What the MIT licence here covers

`LICENSE` applies to **the content of this repository that originated here** — the
packaging, the index, the tooling, and the skills marked `self`.

It does **not** re-license third-party skills. Where a skill names an upstream project,
that project's terms apply. Where a skill carries no `source:`, the origin is simply not
recorded, and this repository makes **no claim** about its licence.

## If you recognise your work here

Two things can be true and both are fixable:

1. **Attribution is missing.** Write to **renato@gamatrade.ba** with the skill name and a
   link; the `source:` field will be filled in (or the skill removed) in the next commit.
2. **You did not intend it to be redistributed.** Say so and it is removed — a skill is a
   directory, so removal is a single commit and does not affect the rest of the library.

There is no intention to claim authorship of other people's work; a collection this size
accumulated faster than its attribution did, and this file is the honest state of that.

## What is *not* claimed

- Not "production-ready" for every entry: they are instructions for an agent, not audited
  code, and a few describe `curl … | bash` installs.
- Not a security-reviewed corpus: read a skill before you let an agent follow it,
  especially the ones that install software or touch credentials.
