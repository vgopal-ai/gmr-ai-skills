# Installation guide

This repo distributes skills as plain folders under `skills/<skill-name>/`. Installing a skill means copying that folder to a location your AI assistant scans for skills. This guide covers **GitHub Copilot personal (user-scope) installation**, which works the same way regardless of whether you plan to use the Azure DevOps MCP server or the Azure CLI as your transport — the skill detects and adapts to whichever is available at runtime.

## Prerequisites

1. **GitHub Copilot** in VS Code (or another client that supports Agent Skills), signed in.
2. **One authorized ADO transport**, already set up by you or your team:
   - **Option A — Azure DevOps MCP server**: already added to your Copilot/Claude Code MCP configuration and signed in, or
   - **Option B — Azure CLI**: `az` installed, `azure-devops` extension added (`az extension add --name azure-devops`), and authenticated (`az login`).

   You only need one of these. The skill checks which is available each session and tells you if neither is configured — it will not install or authenticate either for you.
3. Access to the ADO organization/project you intend to create or update work items in.

## Install at user scope (personal, all repositories)

### Windows (PowerShell)

```powershell
New-Item -ItemType Directory -Path "$env:USERPROFILE\.copilot\skills" -Force | Out-Null
git clone https://github.com/vgopal-ai/gmr-ai-skills.git "$env:TEMP\gmr-ai-skills"
Copy-Item -Path "$env:TEMP\gmr-ai-skills\skills\ado-story-creator" -Destination "$env:USERPROFILE\.copilot\skills\ado-story-creator" -Recurse -Force
```

### macOS / Linux (bash)

```bash
mkdir -p ~/.copilot/skills
git clone https://github.com/vgopal-ai/gmr-ai-skills.git /tmp/gmr-ai-skills
cp -R /tmp/gmr-ai-skills/skills/ado-story-creator ~/.copilot/skills/ado-story-creator
```

## Install for Claude Code instead

Copy the same `skills/ado-story-creator` folder into `.claude/skills/` (project scope) or `~/.claude/skills/` (personal scope). Confirm your installed Claude Code version supports Agent Skills.

## Install repository-wide (team scope, optional)

If your team wants the skill available to everyone who opens a specific repository, copy `skills/ado-story-creator/` into that repository's `.github/skills/ado-story-creator/` and commit it after internal review.

## Ready-to-copy prompt (recommended)

Instead of manually copying files, you can ask Copilot to do the install for you. Paste this into a Copilot Agent chat:

```text
Install the `ado-story-creator` skill from https://github.com/vgopal-ai/gmr-ai-skills at user scope for GitHub Copilot on this machine.

Steps:
1. Clone or fetch the `skills/ado-story-creator` folder from that repository (do not recreate it from scratch).
2. Copy it, preserving structure (SKILL.md, references/, examples/, tests/), into the personal Copilot skills directory:
   - Windows: %USERPROFILE%\.copilot\skills\ado-story-creator
   - macOS/Linux: ~/.copilot/skills/ado-story-creator
3. Do not overwrite unrelated files, and do not install or authenticate any Azure DevOps MCP server or Azure CLI extension — that must already be set up by me.
4. When done, confirm the copied file list and tell me whether an ADO MCP server or Azure CLI is currently detected as available in this environment.
```

After installation, verify by asking Copilot: *"What skills do you have available for Azure DevOps?"* — it should mention `ado-story-creator`.

## First use

Try a safe, non-destructive request first:

```text
Draft an ADO User Story for an ad hoc Excel crosswalk load. Ask about missing information; do not create anything yet.
```

The skill will draft the story and ask for the fields it can't verify (organization, project, assignee, etc.) — it will not write anything until you approve an exact preview.
