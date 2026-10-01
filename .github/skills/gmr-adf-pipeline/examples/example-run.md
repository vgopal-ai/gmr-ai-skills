# Example Skill Run

> Illustrative only. Names in angle brackets are placeholders; nothing here is real configuration.

## User request

> Create an ADF pipeline that runs every morning, invokes an existing Databricks silver notebook, and records operational status in the existing logging pattern.

## Example response progression

### Run log / pre-flight

```text
ADF SKILL RUN LOG
[0] Scope classified: ADF + Databricks
[1] Target repo detection: <repo> - family <DataHub | Clinical | Other> (evidence: remote URL, factory/ folder, existing orchestration)
[2] Pre-flight: PASS
    - GitHub target repo: PASS
    - Databricks auth/workspace: PASS
    - SQL: NOT REQUIRED for direct pipeline behavior; logging implementation will be inspected through the existing notebook contract
    - Azure runtime: NOT REQUIRED until deployment
    - ADO: NOT REQUIRED (no story supplied)
[3] Reference pattern: <closest pipeline> (priority 2 - same repo)
    - parameters, logging style, trigger pattern recorded from the reference
[4] Requirements: PARTIAL
```

### Missing input

The skill discovers multiple candidate notebooks and asks:

> I found two existing silver-processing notebooks matching the description. Which notebook should this pipeline invoke: `<A>` or `<B>`?

### Plan (Gate 1)

After resolution:

```text
GATE 1 - PLAN APPROVAL REQUIRED
Detected repo: <repo> (<family>)
Closest reference: <reference pipeline> (priority 2)
- Create pipeline/<name>.json
- Reuse existing Databricks linked service <name>
- Pass notebook parameters using the reference's names: <list>
- Reuse the reference's logging and failure handling
- Create trigger/<name>.json for the approved morning schedule
- Do not create a new linked service
- Validate using the repository ADF validation/build command
- No deployment will occur in this step
```

The skill includes a request-specific diagram and asks for plan approval.

### Generate and validate

After explicit approval, the skill changes source files, validates JSON/references/build, and reports the diff.

### PR (Gate 2)

The skill works on a feature branch, shows files changed, validation results, and the diff, and asks before pushing and creating the PR. It does not merge.

### Deployment (Gates 3 and 4)

Only after merge and a Deployment Declaration does the skill ask for deployment approval for a named environment. Production, if needed, gets a separate PRODUCTION approval.
