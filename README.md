# gmr-ai-skills
Centralized, reusable AI coding skills (GitHub Copilot, Claude Code, and future assistants) for Azure DevOps and data engineering workflows.

## Skill catalog

| Skill | Purpose | Common prompts | Prerequisites | ADO story | Integrations | Docs |
|---|---|---|---|---|---|---|
| `gmr-adf-pipeline` | Plan, create, modify, validate, and safely deliver Azure Data Factory pipelines. Adapts to DataHub, Clinical, or other ADF repos and requires human approval before implementation and deployment. | "Create an ADF pipeline that reads from `<source>`, calls notebook `<notebook>`, and runs daily." / "Modify `<pipeline>` to add `<requirement>`." / "Use ADO story `<id>` as requirements." | GitHub access to the target ADF repo. Databricks, SQL, Azure, and ADO are needed only when the request uses them. These are checked automatically. | Optional | GitHub, Azure/ADF, Databricks, SQL, Key Vault, Azure DevOps (each only when needed) | [README](.github/skills/gmr-adf-pipeline/README.md) |

Skills live under `.github/skills/<skill-name>/`, each with a `SKILL.md` entry point plus optional `references/`, `examples/`, and `tests/` folders.

## Install a Skill with Copilot

You don't need to copy folders by hand.

1. Open **VS Code**.
2. Open **Copilot Chat** and switch it to **Agent** mode.
3. Paste this prompt, replacing `<skill-name>` with the skill you want (for example `gmr-adf-pipeline`):

   ```text
   Install the <skill-name> skill from https://github.com/vgopal-ai/gmr-ai-skills into my local Copilot skills setup, following .github/prompts/install-skill.prompt.md in that repository. Verify prerequisites, reuse my existing authenticated connections where possible, do not create duplicate configurations, and tell me only if something requires my login or approval.
   ```

4. Copilot finds the skill, copies it to your personal skills folder, and checks what it needs.
5. You only need to respond if a login or permission is actually required.

At the end, Copilot shows a short status summary like this:

```text
Skill: gmr-adf-pipeline
Installation: PASS
GitHub: PASS
Azure DevOps: NOT REQUIRED
Databricks: NOT REQUIRED
SQL: NOT REQUIRED
Additional authentication required: NO
```

Databricks and SQL are never required just to install a skill. A skill checks them later, only when a specific request needs them.

## Safety principles

- No credentials, tokens, or personal connection details are stored in this repository.
- Skills reuse connections you have already set up and ask before anything needs your login.
- Changes reach `main` only through a feature branch and a reviewed pull request.
