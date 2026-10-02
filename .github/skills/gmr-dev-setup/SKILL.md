---
name: gmr-dev-setup
description: Set up, repair, and verify a GMR developer workstation for AI-assisted data engineering. Detects existing tools and connections, installs only missing approved components (GitHub/ADO MCP, Databricks CLI/extension/MCP, SQL extension/MCP, SSMS, Power BI/PBIP/Fabric prerequisites, GMR skills), pauses for approval and SSO/MFA, and finishes with read-only validation and a PASS/FAIL report.
---

# gmr-dev-setup

## Purpose
Set up and repair a GMR developer workstation for AI-assisted data engineering with the least possible manual work.

The skill must be safe for non-technical users. It should detect what already exists, install only what is missing, reuse existing authenticated connections, pause for human authentication/approval, and verify the environment at the end.

This is a setup/orchestration skill. It does not perform application implementation work.

## Supported setup modules
The skill can configure only the modules required by the selected profile or explicit user request:

- VS Code + GitHub Copilot prerequisites
- Git + GitHub tooling and GitHub MCP
- Azure DevOps MCP
- Databricks VS Code extension
- Databricks CLI + organization OAuth/unified authentication
- Databricks MCP when available and approved
- Microsoft SQL Server VS Code extension
- SQL MCP when available and approved
- SSMS (optional human SQL client)
- Power BI Desktop (optional)
- PBIP / Power BI project support
- Fabric / Power BI API prerequisites
- Power BI MCP when available and tenant-approved
- GMR AI skills installation/update

## Operating principle
Never assume every developer needs every tool.

At the beginning, determine the requested profile:

1. Full GMR Data Engineering
2. ADF / Data Engineer
3. Databricks Developer
4. SQL Developer
5. Power BI / BI Developer
6. Custom setup

If the user's prompt already makes the required modules clear, do not ask them to pick a profile.

## Checkpoint 1 — Pre-flight discovery
Before installing or modifying anything:

1. Detect OS and shell.
2. Check whether VS Code is installed.
3. Check Git and GitHub tooling.
4. Check existing MCP configuration and currently registered servers.
5. Check Databricks extension, CLI, profiles, and authentication state.
6. Check Microsoft SQL extension, saved SQL profiles, and SQL MCP if present.
7. Check Azure CLI / Entra authentication when required.
8. Check SSMS if requested or relevant.
9. Check Power BI Desktop, PBIP support, Fabric/Power BI API prerequisites, and Power BI MCP if requested/available.
10. Check which GMR skills are already installed.

Do not install or reconfigure anything during discovery.

Produce a concise pre-flight report using PASS / MISSING / AUTH REQUIRED / NOT REQUIRED.

Example:

```text
VS Code                     PASS
Git                         PASS
GitHub MCP                  PASS
ADO MCP                     PASS
Databricks CLI              PASS
Databricks OAuth            AUTH REQUIRED
Databricks MCP              NOT REQUIRED
SQL extension               PASS
SQL MCP                     MISSING
SSMS                        NOT REQUIRED
Power BI Desktop            NOT REQUIRED
GMR skills                  1 UPDATE AVAILABLE
```

## Checkpoint 2 — Setup plan and approval
After discovery, show exactly what the skill intends to install or change.

The plan must include:

- tools to install
- extensions to install
- MCP servers to configure
- user-level configuration files that will change
- authentication steps the human will need to complete
- whether any machine restart or VS Code reload is expected
- anything that requires organization/admin permission

Then ask:

**Approve this setup plan?**

Do not proceed without explicit approval.

## Installation rules

### General
- Install only missing approved dependencies.
- Prefer official vendor packages, extensions, CLIs, MCP servers, and APIs.
- Do not install community alternatives when an official supported option exists unless the user explicitly asks.
- Do not overwrite an existing working configuration.
- Do not create duplicate profiles or connections.
- Never store passwords, PATs, OAuth refresh tokens, client secrets, or connection strings containing secrets in source control.
- Prefer user-level configuration for personal authentication/settings.
- Do not commit personal MCP configuration into the shared skills repository.

### Authentication
The skill may launch or request official browser/SSO authentication flows.

The skill must never ask the user to paste a password into Copilot chat.

Pause when MFA/SSO/browser authorization is required and clearly tell the user what is happening.

After authentication, verify the session before continuing.

### GitHub
- Reuse existing GitHub authentication if present.
- Prefer GitHub MCP for agent interactions where available.
- Keep Git/gh available for source control and fallback automation.

### Azure DevOps
- Reuse an existing ADO MCP connection when available.
- Do not force ADO CLI if MCP already covers the required workflow.
- If the organization requires an approved remote MCP endpoint, configure only that endpoint.

### Databricks
Preferred capability model:

```text
Copilot/Agent
├── Databricks MCP        normal agent discovery/query tasks
└── Databricks CLI        auth fallback, jobs, bundles, deployment/admin tasks
```

Rules:
- Install the official Databricks VS Code extension if required.
- Install Databricks CLI when required.
- Prefer organization OAuth/unified authentication over hard-coded PATs.
- Reuse existing named profiles.
- Do not recreate a working profile.
- Configure Databricks MCP only when requested/available/approved.
- If MCP depends on an existing CLI OAuth session or approved local proxy, reuse it instead of creating a second credential set.
- A working SQL MCP endpoint does not imply notebook/job/workspace administration capability; preserve the CLI for those operations.

### SQL
Preferred capability model:

```text
Copilot/Agent -> SQL MCP -> Azure SQL / SQL Server
Human        -> SSMS / MSSQL extension -> same database
```

Rules:
- Install the official Microsoft SQL Server VS Code extension when required.
- Configure SQL MCP only through an approved Microsoft/org-supported implementation.
- Reuse Entra authentication where possible.
- One MCP installation may contain multiple logical database connections, but access to one database must never be assumed to grant access to another.
- Add each requested database explicitly and verify permissions independently.
- Keep write capability only if the user's database permissions allow it.
- During setup validation, perform read-only checks only.
- Any future write operation must require explicit human approval at execution time.
- SSMS is optional and is not an MCP dependency.

### Power BI / Fabric
The setup skill must treat Power BI as a separate capability module.

Possible components:
- Power BI Desktop
- PBIP / Power BI project support for source-controlled report/model development
- Power BI/Fabric REST API prerequisites
- Power BI MCP when available and tenant-approved

Rules:
- Detect what the organization/tenant supports before configuring automation.
- Do not claim that SQL or Databricks MCP alone can create Power BI reports.
- Prefer PBIP/Git for source-controlled report artifacts when applicable.
- Prefer approved Fabric/Power BI APIs for publish/manage operations.
- Configure Power BI MCP only if available and approved.
- Authentication must use the organization's normal Microsoft/Entra flow.

## GMR skill installation
When asked to install/update GMR skills:

1. Locate the requested skill in the shared GMR AI Skills repository.
2. Determine the correct local skill location used by the current Copilot environment.
3. Check whether it is already installed.
4. Compare existing vs repository content before changing it.
5. Install/update without creating duplicate nested folders.
6. Preserve the shared repository as the source of truth.
7. Validate SKILL.md, README, references, examples, and tests.

## Checkpoint 3 — Authentication / privilege pauses
Whenever setup reaches a step that requires the human to authenticate, elevate privileges, or approve an organization-managed connection:

1. Explain which product is requesting authorization.
2. Explain why it is required.
3. Open/use the official authentication flow when possible.
4. Wait for the user to complete it.
5. Verify success.
6. Continue automatically if verification passes.

Do not ask the user to learn or manually reproduce CLI commands unless automation cannot proceed.

## Validation
After setup, run read-only verification appropriate to the installed modules.

Examples:

### GitHub
- verify authenticated identity
- verify repository read access

### ADO
- verify MCP tool discovery
- verify a read-only board/work-item lookup

### Databricks
- verify CLI/profile auth
- verify MCP server starts if configured
- list catalog/schema or perform another harmless read
- never write during setup validation

### SQL
- verify MCP server/tool discovery
- verify database/schema/table discovery
- run a harmless SELECT
- never INSERT/UPDATE/DELETE/DDL during setup validation

### Power BI
- verify Desktop installation if requested
- verify project/tool/API prerequisites
- verify tenant/workspace authentication only when configured
- do not publish or alter a report merely to validate setup

## Checkpoint 4 — Final report
Return a simple final status report:

```text
GMR DEVELOPMENT ENVIRONMENT

VS Code                    PASS
GitHub                     PASS
GitHub MCP                 PASS
ADO MCP                    PASS
Databricks CLI             PASS
Databricks authentication  PASS
Databricks MCP             PASS / NOT REQUIRED
SQL extension              PASS
SQL MCP                    PASS / NOT REQUIRED
SSMS                       PASS / NOT REQUIRED
Power BI Desktop           PASS / NOT REQUIRED
Power BI automation        PASS / NOT REQUIRED
GMR skills                 PASS

Ready for:
✓ ADF development
✓ Databricks development
✓ SQL data work
✓ ADO automation
✓ Power BI development (if selected)
```

For failures, explain only the blocking item and the next action.

## Repair mode
If the user says "repair my GMR setup", rerun discovery and fix only broken or expired components.

Examples:
- expired Databricks OAuth -> reauthenticate only Databricks
- broken SQL MCP -> repair SQL MCP only
- missing skill -> install the missing skill only

Do not reinstall the entire environment.

## Safety boundaries
Always require explicit human approval before:
- installing software that changes the workstation
- modifying MCP configuration
- altering existing working profiles
- requesting admin/elevated privileges
- enabling a new write-capable connection

Never:
- capture or persist passwords
- commit secrets
- bypass organization SSO/MFA
- assume database permissions
- silently add production connections
- auto-approve database writes
- auto-publish Power BI reports during setup
- auto-deploy Databricks or ADF workloads during setup
- delete unrelated configuration

## Completion condition
The skill is complete only when:
1. requested modules are installed/configured,
2. required authentication is verified,
3. read-only validation succeeds,
4. the user receives a final PASS/FAIL report,
5. no unresolved setup action is hidden.
