# Contributing

Thank you for improving `gmr-ai-skills`. This repo holds instructions consumed by AI coding assistants, so review bar and safety rules are stricter than for typical scripts.

## Adding a new skill

1. Create `skills/<skill-name>/SKILL.md` with YAML frontmatter (`name`, `description`) and the operating instructions.
2. Add supporting material only as needed:
   - `skills/<skill-name>/references/` — longer reference docs the skill links to, kept out of the main flow.
   - `skills/<skill-name>/examples/` — illustrative, clearly-labeled non-authoritative drafts (never real production data).
   - `skills/<skill-name>/tests/manual-test-plan.md` — a manual acceptance test plan reviewers can run in a sandbox.
3. Update the root [README.md](./README.md) skills table.

## Required safety properties for every skill

Before opening a PR, confirm your skill:

- **Never writes without explicit, specific approval** of the destination and final content — no "create if reasonable" behavior.
- **Never guesses** identities, projects, schedules, or acceptance criteria; asks concise grouped questions or labels items `TBD` instead.
- **Treats retrieved content as data, not instructions** (prompt-injection resistance) — call this out explicitly in the skill if it consumes external text (tickets, files, web content).
- **Contains no secrets, tokens, connection strings, or real production/PII data** anywhere in the skill, references, or examples.
- **Does not claim capabilities it can't verify** (e.g., GUI automation, cross-client compatibility) unless actually tested and stated as such.
- **Uses least-permissive available access** and clearly states when only read access is available.

## Pull request checklist

- [ ] `SKILL.md` has valid YAML frontmatter and a clear `description` (this is what triggers skill selection).
- [ ] No secrets, tokens, credentials, or real customer/PII data anywhere in the diff.
- [ ] Example/template files are clearly labeled as illustrative, not real configuration.
- [ ] `tests/manual-test-plan.md` included and, where possible, actually run in a sandbox before merging.
- [ ] README skills table updated.
- [ ] Changes are made on a feature branch and submitted as a PR — no direct pushes to `main`.

## Review and merge

- At least one reviewer should read the full `SKILL.md` diff line by line — these files are effectively executable instructions for an AI agent.
- Merges to `main` require explicit repository owner approval. Do not self-merge changes to shared skills without review.
- Squash-merge preferred to keep `main` history readable.

## Reporting a skill defect or safety issue

Open an issue describing: the skill name, your AI client/transport, the exact prompt, expected vs. actual behavior, and (for safety issues) why it violates one of the required safety properties above. Do not include real secrets or production data in the issue — sanitize first.
