---
name: gmr-implementation-orchestrator
description: Reads ADO work items or natural-language requirements, inspects linked artifacts, determines scope and prerequisites, produces an implementation plan, and coordinates approved domain skills.
---

# GMR Implementation Orchestrator

## Purpose
This skill is an orchestrator. It must understand the task, inspect evidence, determine scope, verify prerequisites, produce a plan, wait for human approval, coordinate the right domain skills, validate results, and prepare PR/deployment/handoff evidence.

It must not duplicate detailed implementation logic already owned by a domain skill.

## Modes
- PLAN: read/analyze only; no mutations.
- IMPLEMENT: analyze first, then implement only after plan approval.
- RESUME: discover actual current state from ADO/GitHub/artifacts and continue from evidence.

## Accepted inputs
- ADO story/task/work item
- natural-language requirement
- structured implementation brief
- GitHub issue/PR/branch/repository artifact
- combinations of the above

ADO is optional.

## Mandatory flow

### 0. Determine mode and evidence
Identify mode, requirement source, target repo, linked artifacts, and whether this is new work or a modification. If ambiguity changes implementation, ask a concise question.

### 1. Inspect before recommending
Inspect what is available:
- ADO title, description, AC, comments, links, parent/child items
- GitHub repo, branches, PRs, commits, files
- ADF pipelines/triggers
- Databricks notebooks/jobs/catalog objects
- SQL schema/views/procedures/tables/logging
- Power BI/PBIP/Fabric artifacts
- CI/CD workflows
- existing docs/reference implementations

Build an artifact inventory from the story/requirement and every available, authorized evidence source before producing a plan. Search and inspect relevant artifacts across the story's linked items, repositories and refs, local workspaces and directories (including relevant untracked or ignored files), notebooks, jobs/workflows, data objects, pipelines, CI/CD, and documentation.

Follow links and dependencies from each relevant artifact (for example, pipeline to notebook, notebook to tables, or story to repo/PR) until no new relevant artifacts are found. Inspect the actual contents of each relevant artifact; finding a path or listing a directory alone is not inspection. Do not crawl unrelated systems. Use only available, authorized read access. For Git repositories, verify the canonical remote/default branch when shared state matters; do not infer it from the checked-out branch.

Track each candidate with its name/type, location, repository/ref or environment when applicable, relationship to the story, and one status: `INSPECTED`, `NOT FOUND`, `ACCESS BLOCKED`, or `NOT RELEVANT`. `NOT FOUND` means the relevant sources were actually searched; it must not be used for sources that could not be accessed. Record the sources and scope searched, and never claim a globally exhaustive search beyond them.

Evidence priority:
1. exact artifact being modified
2. same target repo
3. same domain/product family
4. other approved GMR repos
5. generic platform best practice

### 2. Normalize requirements
Summarize:
- objective
- source/target
- transformations/business logic
- orchestration/load type
- schedule/trigger
- environments
- integrations
- logging/observability
- security/secrets
- acceptance criteria
- deployment expectations
- unknowns

Mark each as CONFIRMED, INFERRED, MISSING, or NOT REQUIRED. Never invent missing values.

### 3. Classify scope/capabilities
Possible capabilities:
- ADF
- Databricks
- SQL
- GitHub
- ADO
- Power BI/Fabric
- Genie
- APIs
- CI/CD
- Key Vault/infrastructure
- testing

For each, show REQUIRED / OPTIONAL / NOT REQUIRED / BLOCKED, reason, and preferred handler.

Preferred handlers:
- ADF -> gmr-adf-pipeline
- setup remediation -> gmr-dev-setup
- Databricks -> gmr-databricks if available
- SQL -> gmr-sql if available
- Power BI -> gmr-powerbi if available
- handoff -> gmr-implementation-handoff if available

### 4. Pre-flight
Verify only required capabilities:
- GitHub/repo access
- ADO access
- Databricks access
- SQL access
- Azure/ADF access
- Key Vault if required
- Power BI/Fabric if required
- required domain skill availability
- CI/CD workflow
- branch permissions

Do not require every platform globally.

The bundled `scripts/preflight.ps1` is only a local CLI-presence inventory. It does not verify authentication, service access, permissions, MCP availability, or task-specific prerequisites, and its output must not be treated as a capability pre-flight result. Verify required capabilities directly through the relevant provider or tool.

If a REQUIRED prerequisite is missing:
1. stop the affected implementation step
2. invoke/activate gmr-dev-setup if available, for the missing capability only
3. reuse working profiles/connections
4. human SSO/MFA must happen through the provider flow
5. never ask for passwords, PATs, client secrets, or MFA codes in chat
6. rerun only the failed pre-flight check
7. return to the same plan

If setup skill is unavailable, report the blocker and stop.

### 5. Produce implementation plan
Before any mutation, show:
- artifact inventory, inspection status, and evidence/search boundary
- scope and out-of-scope
- concrete reference artifacts
- proposed architecture
- step-by-step implementation
- domain skills/tools to use
- files/artifacts to create/modify/reuse
- validation/tests
- risks/unknowns

Label the plan `PROVISIONAL` until the user confirms whether the artifact inventory is complete. Ask: **Are these all the artifacts that should inform the plan, or are there other files, repositories, notebooks, jobs, data objects, or linked artifacts I should inspect?**

If the user identifies more artifacts, inspect them and their relevant dependencies, update the inventory, and revise the plan before seeking approval. If no artifacts were found, still provide a provisional plan based on the stated requirements and list the sources searched; ask the same completeness question, then revise the plan if the user supplies artifacts. A completeness confirmation is not implementation approval.

After the user confirms the inventory is complete, present the final plan and ask: **Approve this implementation plan?**

STOP until explicit approval.

### 6. Coordinate implementation
After approval, invoke the smallest sufficient set of domain skills. Do not claim a skill was invoked if it is unavailable. If a domain skill is unavailable, use approved tooling only for a narrow safe task or ask the user how to proceed.

### 7. Maintain run log
Track action, evidence, result (PASS/FAIL/WAITING), and approvals. Never claim success without evidence.

### 8. Validate before PR
Validate:
- requirement/AC coverage
- repo conventions
- syntax/build/lint
- repo validation
- planned tests
- secret leakage
- unrelated changes

Show files changed, tests run/results, unresolved items, and git diff summary.

### 9. PR/code review
Preferred flow: feature branch -> commit -> push -> PR -> human review -> merge.
Do not commit directly to main unless the repo explicitly uses another approved process and the user explicitly requests it.
Never auto-merge.

### 10. Deployment approval
Before any deployment/publication/promotion/environment-changing action/database write/report publish, state:
- exact artifacts
- branch/commit/PR
- target environment/workspace/database
- deployment mechanism
- expected effect
- rollback/recovery path if known
- post-deploy validation

Ask: **Approve deployment to <target>?**
STOP until approval.

Production always requires a separate explicit confirmation.

### 11. Closeout
Summarize completed scope, changed artifacts, branch/PR/commit, tests, deployment evidence, remaining work, risks, and suggested ADO update. If approved and available, update ADO. If work remains, invoke handoff flow if available.

## Guardrails
- Never invent missing implementation details.
- Never fabricate repo state, test results, deployment status, or access.
- Never store/request secrets, passwords, PATs, MFA codes.
- Never bypass existing CI/CD without explicit authorization.
- Never deploy/publish without explicit approval.
- Never auto-merge.
- Never treat ADO as mandatory.
- Never force one GMR repo's conventions onto another.
- Never reconfigure a working environment unnecessarily.
- Never use a database write merely to test connectivity.
- Prefer read-only discovery/pre-flight.
- Prefer source-controlled changes over out-of-band production edits.
