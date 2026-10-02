# Setup matrix

| Capability | Reuse and discover first | Ask only if target remains unknown | Profile scope |
|---|---|---|---|
| GitHub | Existing GitHub MCP/CLI auth; list accessible orgs and repositories | Organization and repository name or URL; never a generic workspace URL | Full profile or task requires it |
| Azure DevOps | Existing ADO MCP/CLI auth; list accessible organizations and projects | Organization and project name or URL | Full profile or task requires it |
| Databricks | Existing CLI profiles/MCP connections; verify profiles and list accessible workspaces/catalogs | Workspace URL or selection of an existing profile | Full profile or task requires it |
| SQL | Existing SQL MCP connections, profiles, and authenticated sessions; list accessible databases | Server name, database name, and authentication type; prefer Entra where appropriate | Full profile or task requires it |
| Power BI / Fabric | Existing authenticated API/MCP connection; list accessible workspaces | Workspace name or URL only when needed and discovery is inconclusive | Full profile checks prerequisites; workspace is task-dependent |

## Setup module matrix

| Capability | Preferred AI-facing path | Traditional/fallback path | Required for every user? |
|---|---|---|---|
| GitHub | GitHub MCP | Git / gh | Usually |
| Azure DevOps | ADO MCP | ADO web / CLI optional | No |
| Databricks | Databricks MCP where approved | Databricks CLI + VS Code extension | No |
| SQL | SQL MCP | MSSQL extension / SSMS | No |
| Power BI | Power BI MCP where approved + PBIP/API workflows | Power BI Desktop | No |

## Notes
- MCP is preferred for natural-language agent interaction.
- CLI remains useful for deployment, jobs, admin, and automation where MCP does not expose the required capability.
- SSMS is not a separate platform integration; it is a human client for SQL.
- A single SQL MCP installation can be configured with multiple logical database connections, but each database must be explicitly configured and permission-checked.
- Databricks MCP and Databricks CLI can coexist. The CLI should remain available as a fallback even when MCP is working.
- Power BI automation requires Power BI/Fabric-specific tooling; SQL/Databricks MCP alone does not create reports.
- Discover accessible resources through existing authenticated connections before asking users to name a target.
- Never put team-specific workspaces, servers, databases, projects, or repositories in shared setup defaults.
