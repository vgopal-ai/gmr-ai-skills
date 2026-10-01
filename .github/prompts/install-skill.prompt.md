---
description: Install or update any skill from the GMR AI Skills repository into the user's personal Copilot skills folder, check its prerequisites, and report a status summary.
---

# Install a GMR AI skill

You are installing the skill named by the user (`<skill-name>`) from https://github.com/vgopal-ai/gmr-ai-skills. Follow these steps exactly. The repository version is the source of truth.

## 1. Locate the skill

- Find `.github/skills/<skill-name>/SKILL.md` in the repository. Use a local clone if one is open; otherwise fetch the folder from GitHub (read-only).
- If the skill does not exist, list the available skills under `.github/skills/` and stop.

## 2. Determine the local skills location

- GitHub Copilot personal skills: `%USERPROFILE%\.copilot\skills\<skill-name>` on Windows, `~/.copilot/skills/<skill-name>` on macOS/Linux.
- If the user's environment clearly uses a different supported location (for example Claude Code `~/.claude/skills/`), tell the user and ask before using it.

## 3. Check for an existing installation

- If the skill folder already exists, compare it file-by-file with the repository version.
- If the files are identical, report "already up to date" and do not copy anything.
- If they differ, show which files differ and replace the local copy with the repository version. Do not create a second copy or a renamed duplicate.
- Do not touch other skills or unrelated files.

## 4. Install or update

- Copy the whole skill folder, preserving its structure (`SKILL.md`, `README.md`, `references/`, `examples/`, `tests/` where present).
- Do not modify the skill content during installation.

## 5. Validate

- Confirm `SKILL.md` exists and has YAML frontmatter with `name` and `description`.
- Confirm every relative file linked from `SKILL.md` and `README.md` exists in the installed copy.

## 6. Check prerequisites for this skill only

- Read the skill's README "Prerequisites" section.
- Check only prerequisites that are needed **at install time or for every use**. Mark conditional ones (for example Databricks or SQL for `gmr-adf-pipeline`) as `NOT REQUIRED`. The skill checks those later, when a request needs them.
- Use harmless, read-only checks against **existing** authenticated connections: GitHub/Git credentials, Azure DevOps MCP server or `az devops`, Azure CLI context, Databricks CLI profiles, saved SQL connections.
- Never ask the user to recreate a working connection. Never create new connections, profiles, or MCP server entries without asking.
- Never store credentials, tokens, or connection details in the skills repository or the installed skill.

## 7. Only interrupt the user when necessary

Ask the user only when a login, permission, or decision is actually required. In that case, say exactly what is missing and what they need to do.

## 8. Final status summary

Finish with exactly this block (use `PASS`, `FAIL`, or `NOT REQUIRED` as appropriate):

```text
Skill: <skill-name>
Installation: PASS/FAIL
GitHub: PASS/NOT REQUIRED
Azure DevOps: PASS/NOT REQUIRED
Databricks: PASS/NOT REQUIRED
SQL: PASS/NOT REQUIRED
Additional authentication required: YES/NO
```

If anything failed, add one short line per failure explaining what the user needs to do.
