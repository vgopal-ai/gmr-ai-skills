# Setup matrix

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
