# GMR Dev Setup

A one-prompt onboarding and repair skill for GMR developers using GitHub Copilot.

## Goal
A developer should not need a one-hour setup call to configure GitHub, ADO, Databricks, SQL, Power BI, and the shared GMR AI skills.

The developer should be able to paste one prompt, approve the missing-component summary once, complete normal company SSO/MFA when prompted, and receive a final verification report.

## One-prompt setup
Paste this into GitHub Copilot Agent mode after making this skill available:

> Run the gmr-dev-setup skill and fully set up my GMR data-engineering environment. Detect what I already have, install and configure everything missing, reuse existing connections, and only stop when I personally need to complete SSO/MFA or approve something. Verify everything when finished.

For a smaller setup, add an explicit profile request such as `Use the SQL Developer profile` or `Use the Databricks Developer profile`.

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
│   ├── Power BI Desktop (required for full profile)
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
Reuse saved connections and discover resources
      │
      v
Ask only for undiscoverable target details
      │
      v
Summarize ready / missing / input / auth / blocked
      │
      v
ONE HUMAN APPROVAL
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

Keep sweep output compact and distinguish installed tools from configured targets:

```text
Current state
GitHub: PASS
ADO: PASS
Databricks CLI: PASS
Databricks workspace: MISSING
SQL connection: MISSING
Power BI: MISSING

Proposed actions
- Configure Databricks workspace
- Configure SQL connection
- Install Power BI

Approve installation and configuration of the missing required components?
```

Show `Needs user input`, `Needs authentication`, and `Blocked/admin-required` only when those sections have entries. Ask only for target details that resource discovery could not resolve.

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
The skill asks once before setup to approve installation/configuration of missing required components. It then pauses only for:

1. SSO/MFA or browser authorization,
2. admin/elevation approval,
3. another unavoidable user action.

Before asking for target details, the skill checks existing profiles, connections, and accessible-resource discovery. It asks only for missing or ambiguous target information. Workspace configuration is required only when the selected profile or task needs that workspace.

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

> Repair my GMR development setup using the `gmr-dev-setup` skill. Check what is broken or expired, fix only those components, reuse all working configuration, pause only for SSO/MFA or unavoidable approval, and finish with a PASS/FAIL report.

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
Power BI Desktop / PBIP     PASS / FAIL / AUTH REQUIRED / BLOCKED
Power BI automation        PASS / FAIL / AUTH REQUIRED / BLOCKED / NOT REQUIRED (only for an explicitly narrower profile after checking)
GMR skills                 PASS

Ready for:
✓ ADF development
✓ Databricks development
✓ SQL data work
✓ ADO automation
✓ Power BI/Fabric development
```
