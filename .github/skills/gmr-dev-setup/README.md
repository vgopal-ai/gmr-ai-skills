# GMR Dev Setup

A one-prompt onboarding and repair skill for GMR developers using GitHub Copilot.

## Goal
A developer should not need a one-hour setup call to configure GitHub, ADO, Databricks, SQL, Power BI, and the shared GMR AI skills.

The developer should be able to paste one prompt, approve the setup plan, complete normal company SSO/MFA when prompted, and receive a final verification report.

## One-prompt setup
Paste this into GitHub Copilot Agent mode after making this skill available:

> Set up my GMR development environment using the `gmr-dev-setup` skill. Detect what I already have, install only missing approved components, reuse existing connections and profiles, and do not create duplicates. Configure the tools needed for the full GMR data-engineering profile, including GitHub, Azure DevOps, Databricks, SQL, Power BI/Fabric prerequisites, and the shared GMR skills. Pause only when I need to approve a change or complete SSO/MFA. Do not ask me for passwords in chat. Validate everything with read-only checks and give me a final PASS/FAIL report.

For a smaller setup, replace `full GMR data-engineering profile` with `SQL Developer`, `Databricks Developer`, `ADF/Data Engineer`, or `Power BI Developer`.

## What it can configure

```text
GMR Developer Environment
│
├── VS Code + GitHub Copilot
│
├── GitHub
│   ├── GitHub MCP
│   └── Git / gh
│
├── Azure DevOps
│   └── ADO MCP
│
├── Databricks
│   ├── Databricks MCP (when supported/approved)
│   ├── Databricks CLI
│   └── VS Code extension
│
├── SQL
│   ├── SQL MCP
│   ├── Microsoft SQL extension
│   └── SSMS (optional)
│
├── Power BI / Fabric
│   ├── Power BI Desktop (optional by profile)
│   ├── PBIP project support
│   ├── Fabric / Power BI APIs
│   └── Power BI MCP (when tenant-approved)
│
└── GMR AI Skills
    ├── ado-story-creator
    ├── gmr-adf-pipeline
    └── future shared skills
```

## End-to-end setup flow

```text
One user prompt
      │
      v
Detect machine + existing tools
      │
      v
Check connections/authentication
      │
      v
Build minimal setup plan
      │
      v
HUMAN APPROVAL
      │
      v
Install only missing components
      │
      v
Authentication needed?
   ┌──┴───┐
  no     yes
   │       │
   │       v
   │   Browser / SSO / MFA
   │       │
   └───────┘
      │
      v
Configure/reuse profiles + MCP
      │
      v
Read-only verification
      │
      v
PASS / FAIL report
```

## Setup profiles

### Full GMR Data Engineering
GitHub + ADO + Databricks + SQL + Power BI/Fabric prerequisites + GMR skills.

### ADF / Data Engineer
GitHub + ADO + Databricks + SQL + ADF skills. Power BI is optional.

### Databricks Developer
GitHub + Databricks CLI/extension + Databricks MCP where approved.

### SQL Developer
GitHub if needed + SQL MCP + Microsoft SQL extension + optional SSMS.

### Power BI Developer
Power BI Desktop + PBIP + Fabric/Power BI API prerequisites + SQL/Databricks access as needed + Power BI MCP where approved.

## Human review points
The skill intentionally pauses before:

1. installing or changing workstation software,
2. changing MCP configuration,
3. modifying an existing connection/profile,
4. requesting admin privileges,
5. enabling a write-capable database connection.

It also pauses whenever the user needs to complete SSO/MFA.

## Authentication model
Users should authenticate directly with the official provider flow. They should never type passwords into Copilot chat.

Examples:

```text
Databricks setup -> browser -> company SSO/MFA -> verify -> continue
Azure SQL setup  -> Entra login -> MFA -> verify -> continue
GitHub setup     -> GitHub login/device/browser -> verify -> continue
Power BI/Fabric  -> Microsoft/Entra login -> verify -> continue
```

## Design rules
- Reuse working connections.
- Install only what is missing.
- Do not create duplicate profiles.
- Prefer official vendor tooling.
- Keep personal auth/config out of Git.
- Validate with read-only operations.
- Keep database writes human-approved.
- Do not deploy workloads as part of workstation setup.

## Repair prompt

> Repair my GMR development setup using the `gmr-dev-setup` skill. Check what is broken or expired, fix only those components, reuse all working configuration, pause for SSO/MFA or approvals when needed, and finish with a PASS/FAIL report.

## Expected final report

```text
GMR DEVELOPMENT ENVIRONMENT

VS Code                    PASS
GitHub                     PASS
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
✓ BI development (if selected)
```
