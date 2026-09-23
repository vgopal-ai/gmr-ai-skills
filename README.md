# gmr-ai-skills

Centralized repository for **reusable AI coding skills** shared across GitHub Copilot, Claude Code, and future AI coding assistants. This repo initially focuses on **Azure DevOps (ADO)** and **data engineering** workflows.

Repository: https://github.com/vgopal-ai/gmr-ai-skills

## What's in here

| Skill | Purpose |
|---|---|
| [`ado-story-creator`](./skills/ado-story-creator/SKILL.md) | Draft, validate, create, and update Azure DevOps Boards work items (stories, tasks, bugs) from natural language, using an already-authorized ADO MCP server or Azure CLI. |

Each skill lives under `skills/<skill-name>/` and follows the Agent Skills convention: a `SKILL.md` entry point plus optional `references/`, `examples/`, and `tests/` folders.

## Design principles

- **Draft-then-approve.** No skill in this repo writes to an external system without explicit user approval of the exact destination and content.
- **No bundled credentials.** Skills rely on integrations (MCP servers, CLIs) that the user has already authorized. Nothing here installs, stores, or requests secrets.
- **Transport-agnostic.** Skills describe behavior in terms of capabilities (read/write work items) rather than hardcoded tool names, so they work whether you use an ADO MCP server or the `az devops` CLI.
- **Verify, don't assume.** Skills confirm identities, projects, and field names against live tool output rather than guessing.

## Quick links

- [Installation guide](./INSTALLATION.md) — install a skill once, at user scope, in GitHub Copilot.
- [Troubleshooting guide](./TROUBLESHOOTING.md) — common setup and authorization issues.
- [Contributing guide](./CONTRIBUTING.md) — how to add or update a skill.

## Requirements

Skills in this repo assume you already have one of the following authorized and working in your environment:

- An **Azure DevOps MCP server** connected to your GitHub Copilot / Claude Code client, with read (and optionally write) access to your ADO organization, **or**
- **Azure CLI** (`az`) with the `azure-devops` extension installed and signed in (`az login`, `az devops configure --defaults organization=... project=...`).

This repository does not install or configure either integration — see [Installation](./INSTALLATION.md) for what to check before you start.
