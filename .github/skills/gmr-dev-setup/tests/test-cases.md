# Test cases

| ID | Scenario | Expected behavior |
|---|---|---|
| T01 | Fresh Windows workstation | Detect missing components, propose install plan, wait for approval. |
| T02 | Existing working Databricks CLI | Reuse it; do not reinstall or create duplicate profile. |
| T03 | Databricks auth expired | Request official SSO/MFA reauthentication only. |
| T04 | Databricks MCP not requested | Mark NOT REQUIRED; do not install it. |
| T05 | SQL MCP requested, MSSQL extension already installed | Reuse extension; configure only missing MCP component. |
| T06 | Existing SQL profile | Reuse it when compatible; do not create duplicate profile. |
| T07 | Second SQL database | Add explicit logical connection and verify permissions independently. |
| T08 | SQL write permissions exist | Detect capability but validate using read-only query only. |
| T09 | User selects SQL Developer profile | Do not install Databricks or Power BI unless needed. |
| T10 | User selects Power BI Developer profile | Configure Power BI/PBIP/API prerequisites and only required data connections. |
| T11 | Power BI MCP unavailable in tenant | Explain limitation and continue with PBIP/API/Desktop path if approved. |
| T12 | Existing GitHub MCP | Reuse; no duplicate server. |
| T13 | ADO MCP missing for ADF profile | Propose setup and wait for approval. |
| T14 | Authentication requires MFA | Pause, let user authenticate through official flow, verify, continue. |
| T15 | Installer requires admin rights | Explain why, ask approval, then elevate only after approval. |
| T16 | Community package conflicts with official vendor tool | Prefer official vendor tool. |
| T17 | Secret detected in proposed config | Stop and move secret to approved secure/user-level auth method. |
| T18 | Repair mode with one broken component | Fix only broken component. |
| T19 | Full setup complete | Run read-only verification and produce PASS/FAIL report. |
| T20 | GMR skill already installed | Compare/update only if repository version differs; no duplicate nesting. |
| T21 | Existing Databricks profile is valid | Reuse it and discover accessible workspaces; do not ask for a URL or create another profile. |
| T22 | No Databricks profile or discoverable workspace | Ask: "Please provide the Databricks workspace URL you are authorized to use, or select an existing profile." Then use organizational SSO/OAuth/MFA. |
| T23 | Existing SQL profile/connection works | Reuse it and discover accessible databases; do not ask for server/database again. |
| T24 | SQL target cannot be discovered | Ask only for server name, database name, and authentication type; prefer Entra where appropriate and never ask for a password. |
| T25 | GitHub connection is authenticated | Discover accessible organizations/repositories before asking for a target. |
| T26 | GitHub repository remains unknown | Ask for organization and repository name or URL; never ask for a generic workspace URL. |
| T27 | ADO connection is authenticated | Discover accessible organizations/projects before asking for a target. |
| T28 | ADO organization/project cannot be identified | Ask for organization and project name or URL only then. |
| T29 | Power BI profile/task does not need a workspace | Do not require workspace configuration or ask for its details. |
| T30 | Power BI profile/task needs a workspace | Discover accessible workspaces first; ask for name or URL only if the intended workspace remains ambiguous or unavailable. |
| T31 | Shared skill/docs are scanned for business-specific target values | No team-specific workspace URLs, SQL servers/databases, Power BI workspaces, ADO projects, or GitHub repos are hard-coded. |
| T32 | Target connection already exists | Reuse it; never create a duplicate connection to the same target. |
| T33 | A target requires credentials or MFA | Direct user to official SSO/OAuth/MFA; never ask for passwords, PATs, client secrets, or MFA codes in chat. |
| T34 | Setup sweep has ready and missing components | Show compact `Current state` and `Proposed actions` sections, separating tool status from target-resource status. |
| T35 | Setup proceeds after discovery | Follow detect -> reuse -> discover -> ask only for unresolved target details -> approve -> configure/authenticate -> verify/continue; do not skip resource discovery or ask generic setup questions early. |
