# Example run — Full GMR Data Engineering

## User prompt
> Set up my GMR development environment using the gmr-dev-setup skill. Reuse anything already configured and only ask me when authentication or approval is required.

## Pre-flight
```text
VS Code                     PASS
Git                         PASS
GitHub MCP                  PASS
ADO MCP                     PASS
Databricks extension        PASS
Databricks CLI              PASS
Databricks OAuth            AUTH REQUIRED
Databricks MCP              MISSING
SQL extension               PASS
SQL MCP                     MISSING
SSMS                        NOT REQUIRED
Power BI Desktop            MISSING
PBIP prerequisites          MISSING
GMR skills                  2 MISSING
```

## Proposed setup
```text
Changes requested:
1. Reauthenticate Databricks through company SSO/MFA.
2. Configure approved Databricks MCP using existing authentication.
3. Configure approved SQL MCP without storing secrets.
4. Install Power BI Desktop and PBIP prerequisites for the selected profile.
5. Install missing GMR skills.

No existing working connection will be replaced.
```

The skill asks: **Approve this setup plan?**

## Human action
The user approves, then completes company SSO/MFA in the official browser flows when prompted.

## Validation
Only read-only checks are executed.

## Final report
```text
VS Code                    PASS
GitHub MCP                 PASS
ADO MCP                    PASS
Databricks CLI             PASS
Databricks authentication  PASS
Databricks MCP             PASS
SQL MCP                    PASS
Power BI Desktop           PASS
PBIP prerequisites         PASS
GMR skills                 PASS
```
