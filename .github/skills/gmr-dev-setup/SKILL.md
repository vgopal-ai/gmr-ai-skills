---
name: gmr-dev-setup
description: Run the full GMR data-engineering workstation setup by default when asked to run the setup skill, set up an environment, or install/configure the GMR dev environment. Checks GitHub, ADO, Databricks, SQL, Power BI/Fabric, VS Code extensions, MCPs, CLIs, and GMR skills; discovers accessible resources before asking for target details; reuses existing tools and connections; obtains one approval before installing missing components; pauses only for unavoidable user actions; and verifies the result. Explicit test, preflight, or check requests are read-only.
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
- Power BI Desktop (required for the default Full GMR Data Engineering profile)
- PBIP / Power BI project support
- Fabric / Power BI API prerequisites
- Power BI MCP when available and tenant-approved
- GMR AI skills installation/update

## Operating principle
Never assume every developer needs every tool.

Choose the requested profile using this order:

1. Use a profile explicitly named by the user.
2. Otherwise, use **Full GMR Data Engineering** for setup/install/configure/run requests.
3. Use **Custom setup** only when the user explicitly limits the requested components.

Do not ask the user to choose a profile when the default applies. A request to test, preflight, inspect, or check setup is read-only and must not install or configure anything. A request to run, set up, install, configure, or repair the environment executes the setup workflow below.

For the default Full GMR Data Engineering profile, check and configure GitHub, Azure DevOps, Databricks, SQL, Power BI/Fabric, VS Code extensions, MCP servers, CLIs, and shared GMR skills. Power BI Desktop and PBIP support are part of this profile; SSMS and Power BI MCP are conditional on availability, tenant approval, and user needs. Do not label any component NOT REQUIRED until the profile is selected and that component has actually been checked.

## Checkpoint 1 — Pre-flight discovery
Before installing or modifying anything:

1. Detect OS and shell.
2. Check whether VS Code is installed.
3. Check Git, GitHub CLI and authentication, GitHub MCP, and repository access.
4. Check Azure DevOps MCP, CLI if used, authentication, and read access.
5. Check all configured MCP servers by name and connectivity; never display or copy secret values.
6. Check Databricks VS Code extension, CLI, profiles, authentication, and MCP availability.
7. Check Microsoft SQL extension, SQL MCP, existing profiles/connections, and read-only permissions.
8. Check Power BI Desktop in machine and user install locations, PBIP support, Fabric/Power BI API prerequisites, tenant support, and Power BI MCP availability.
9. Check Azure CLI / Entra authentication when required, SSMS, and all other profile components.
10. Check installed GMR skills and compare them with the shared repository.

Use the local preflight script where available, but do not rely on PATH alone. Check documented machine-wide and user-scoped install locations, VS Code extension listings, MCP configuration, provider tools, and existing authenticated MCP connections. Resolve actual executable paths without changing PATH or configuration.

Do not install or reconfigure anything during discovery.

### Resource discovery before questions
Before asking for a workspace, server, organization, project, or repository, inspect saved profiles, existing connections, local configuration, and authenticated provider tools. Reuse a working connection and use it to discover accessible resources with harmless list/read operations whenever supported. Do not ask for a target that is already configured or can be uniquely discovered. If discovery returns multiple plausible targets, ask the user to select among those results rather than asking them to restate connection details.

- **Databricks:** inspect existing CLI profiles and MCP connections, verify available profiles, and list accessible workspaces/catalogs where supported. If no usable profile or unique authorized workspace can be discovered, ask: “Please provide the Databricks workspace URL you are authorized to use, or select an existing profile.” Authenticate only through organizational SSO/OAuth/MFA.
- **SQL:** inspect existing SQL MCP connections, saved profiles, and authenticated SQL connections first. If no usable connection identifies the required target, ask only for the SQL server name, database name, and authentication type. Prefer Microsoft Entra authentication where appropriate. Never ask for a password in chat.
- **GitHub:** inspect GitHub MCP/CLI authentication and discover accessible organizations and repositories first. If the requested repository cannot be determined, ask for the GitHub organization and repository name or URL. Never ask for a generic workspace URL.
- **Azure DevOps:** reuse the existing ADO connection and discover accessible organizations/projects first. Ask for the organization and project name or URL only when the requested target cannot be discovered or uniquely identified.
- **Power BI / Fabric:** when required by the selected profile or task, discover accessible workspaces using existing authenticated connections. Ask for the workspace name or URL only when the intended workspace cannot be determined. Do not require workspace configuration for profiles or tasks that do not need it.

Never guess a target, create a duplicate connection to avoid discovery, or globally hard-code a team-specific workspace URL, SQL server/database, Power BI workspace, ADO project, or GitHub repository. Users and teams may have different access.

If required target details remain unavailable after discovery, put only those details under **Needs user input** in the setup summary and ask for them before requesting setup approval. Once supplied, finish discovery and show the approval summary; do not ask for details that can be discovered through the selected connection.

Determine each component's actual state as READY, MISSING, AUTH REQUIRED, or BLOCKED / ADMIN REQUIRED. NOT REQUIRED is allowed only for an optional component after profile selection and an actual check.

Present sweep results compactly. Report tools and target resources separately so a working CLI does not imply a configured workspace or database connection. Use `PASS` for ready, `MISSING` for absent or unconfigured, and `AUTH REQUIRED` / `BLOCKED` where appropriate. Do not add narrative around the status list unless it explains a blocker or user action.

Example:

```text
Current state
GitHub: PASS
ADO: PASS
Databricks CLI: PASS
Databricks workspace: MISSING
SQL connection: MISSING
Power BI: MISSING

Needs user input
- Databricks workspace URL or existing profile
- SQL server, database, and authentication type

Proposed actions
- Configure Databricks workspace
- Configure SQL connection
- Install Power BI Desktop

Approve installation and configuration of the missing required components?
```

## Checkpoint 2 — One approval
After discovery, derive the minimal changes yourself. Do not ask the user to prepare or approve a detailed setup plan. Show the compact `Current state` and `Proposed actions` sections above. Include `Needs user input`, `Needs authentication`, and `Blocked/admin-required` sections only when they are non-empty. Keep entries to one line per component/action, and identify only target details that discovery could not find or uniquely resolve.

Then ask exactly:

**Approve installation and configuration of the missing required components?**

Do not install software, change configuration, or create connections until the user approves. This is the only general setup approval; after it, continue automatically wherever possible.

## Setup execution order
Follow this order for setup and repair requests:

1. Detect the local environment and selected profile.
2. Reuse existing working tools, profiles, connections, and authentication.
3. Discover accessible resources through those connections.
4. Ask only for required target details that remain missing or ambiguous.
5. Show the concise current-state/action summary and obtain the one setup approval.
6. Configure approved missing components; pause only for unavoidable SSO/MFA, browser authorization, admin approval, or another user action. Verify access after authentication.
7. Continue remaining setup automatically, then run read-only end-to-end verification and report PASS/FAIL.

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

Pause only when human MFA/SSO, browser authorization, admin approval, or another unavoidable user action is required. Clearly say which product needs the action and why. Continue the remaining setup automatically after the user completes it; do not restart discovery or ask for another general approval.

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
- Check Databricks MCP availability for the selected profile; configure it when supported and approved.
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
- verify Desktop and PBIP support for the selected profile
- verify project/tool/API prerequisites
- verify tenant/workspace authentication only when configured
- verify Power BI MCP only when available and approved
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
SSMS                       PASS / NOT REQUIRED (only after checking)
Power BI Desktop / PBIP     PASS / FAIL / AUTH REQUIRED / BLOCKED
Power BI automation        PASS / FAIL / AUTH REQUIRED / BLOCKED / NOT REQUIRED (only after checking)
GMR skills                 PASS

Ready for:
✓ ADF development
✓ Databricks development
✓ SQL data work
✓ ADO automation
✓ Power BI/Fabric development
```

For failures, explain only the blocking item and the next action.

## Repair mode
If the user says "repair my GMR setup", rerun environment and resource discovery and fix only broken, expired, or missing components required by the selected profile. Reuse working tools, profiles, connections, and discovered targets; do not reinstall working tools or create duplicate connections.

Examples:
- expired Databricks OAuth -> reauthenticate only Databricks
- broken SQL MCP -> repair SQL MCP only
- missing skill -> install the missing skill only

Do not reinstall the entire environment.

## Safety boundaries
Require the single setup approval before installing missing components or changing configuration. After that approval, proceed without repeated general approvals. Never alter an existing working profile/connection or enable database writes as part of setup. Pause only for human authentication, browser authorization, elevation/admin approval, or another unavoidable user action.

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
1. all possible requested modules are installed/configured,
2. required authentication is verified,
3. read-only validation succeeds,
4. the user receives a final PASS/FAIL report,
5. every unavailable component is explicitly identified with its required user/admin action.
