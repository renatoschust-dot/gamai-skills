# Proof and status

This page exists because grant reviewers ask the same questions: what is real, what is measured,
and what is still missing. Numbers below are verifiable from the repository or a running instance.

## Verifiable now

| Claim | How to verify |
|---|---|
| 992 public skills, each a `SKILL.md` with frontmatter | `find skills -name SKILL.md | wc -l`, and CI job `validate-skills` |
| Frontmatter validated on every push | GitHub Actions, workflow `validate-skills` (green) |
| Skills are plain Markdown, MIT licensed | `LICENSE`, file format |
| Runtime uses OpenAI-compatible APIs | `docs/ARCHITECTURE.md` |

## Honest limitations

- **One maintainer.** The project is maintained by the founder with occasional contracted help.
- **Small public footprint.** The public repository is young; most usage is inside one company and
  a handful of early external users.
- **No external funding yet.** Development has been funded by the founder's trading company.
- **Test coverage is partial.** CI validates skill structure; it does not yet run every skill against
  multiple models. That is exactly what the proposed work packages would fix.

## What funding would change

1. A security and supply-chain review of every published skill, with sandboxed execution.
2. A compatibility harness that runs skills against several model backends on every change.
3. Documentation and governance so the project does not depend on a single person.
