# GMR Implementation Orchestrator

This skill turns an ADO story or plain-language request into an evidence-based implementation plan. It inventories and inspects relevant linked/discovered artifacts, confirms the inventory with the user, then coordinates approved work.

## Simple flow

```text
ADO Story / User Requirement
        |
        v
Inventory and inspect linked/discovered artifacts
        |
        v
Confirm artifact inventory is complete
        |
        v
Determine scope and technologies
        |
        v
Pre-flight required capabilities
        |
        +---- missing setup? ----> gmr-dev-setup
        |                            |
        |                         SSO / MFA
        |                            |
        +----------------------------+
        |
        v
Implementation plan
        |
        v
HUMAN APPROVAL
        |
        v
Route to domain skills
        |
        +--> gmr-adf-pipeline
        +--> gmr-databricks (when available)
        +--> gmr-sql (when available)
        +--> gmr-powerbi (when available)
        |
        v
Validate
        |
        v
Feature branch + PR
        |
        v
HUMAN CODE REVIEW
        |
        v
Existing CI/CD
        |
        v
EXPLICIT DEPLOYMENT APPROVAL
```

## Modes

**PLAN**
> Read ADO 12345 and tell me what I need to do. Do not change anything.

**IMPLEMENT**
> Implement ADO 12345. Inspect everything first, show me the plan, and wait for my approval.

**RESUME**
> Resume ADO 12345 from the current PR. Discover what is already done before proposing next steps.

## Setup behavior
`gmr-dev-setup` is a dependency resolver, not something that runs every time. If SQL is missing but Databricks works, only SQL should be remediated.

The bundled `scripts/preflight.ps1` reports local CLI presence only. It does not test sign-in, permissions, service access, MCP availability, or whether a CLI is required for a particular task. Use it as an inventory aid, not as the orchestrator's capability check.

## Evidence priority
1. Exact artifact being modified
2. Same target repo
3. Same domain/product family
4. Other approved GMR repos
5. Generic platform best practice

## Human approvals
1. Implementation plan
2. Code/PR review
3. Deployment
4. Separate production approval

## Install
The canonical shared path is `skills/gmr-implementation-orchestrator/`. Follow the [repository installation guide](../../INSTALLATION.md) to install it in a supported client.

## One-prompt usage
> Use the `gmr-implementation-orchestrator` skill to implement ADO story 12345. Inspect the story and linked artifacts first, verify only the prerequisites required for this task, use `gmr-dev-setup` if required setup is missing, show me the implementation plan and wait for my approval before making changes. Use the appropriate domain skills. Do not deploy, merge, publish, or perform database writes without explicit approval.

The orchestrator must inventory and inspect relevant story links, repositories/refs, local files, notebooks, jobs, data objects, and dependencies that are discoverable with authorized access. Show the searched-source boundary and artifact inventory. Mark the plan provisional and ask whether other artifacts should be included; inspect any additional artifacts and revise the plan before asking for implementation approval. If none are found, still provide a provisional plan and ask the same completeness question. Inventory confirmation is not implementation approval.
