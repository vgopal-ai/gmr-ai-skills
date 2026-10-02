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
