# gmr-adf-pipeline - Acceptance Test Cases

Manual acceptance tests for the `gmr-adf-pipeline` skill. Run them in a sandbox/feature-branch context against non-production repositories. Names in angle brackets are placeholders, not real configuration.

Each test lists: scenario, input, expected pre-flight, expected behavior, expected approval gates, and pass criteria.

Gate shorthand: **G1** = plan approval, **G2** = code/PR review, **G3** = deployment approval, **G4** = production approval.

---

## TC-01 - DataHub natural-language pipeline

- **Scenario:** New pipeline in a DataHub ADF repo from a plain-English request.
- **Input:** "Create an ADF pipeline in the DataHub repo that loads `<source table>` incrementally into `<target>` and runs nightly."
- **Expected pre-flight:** First detects the target repo/family as DataHub. Then GitHub/repo PASS. SQL required only if source/target/config is SQL; Databricks NOT REQUIRED unless the reference pattern calls a notebook. ADO NOT REQUIRED.
- **Expected behavior:** Detects the repo as DataHub with evidence. Searches same-repo pipelines first. Records parameter names, logging, trigger, load-type handling, configuration/Key Vault references, ADF LiteLog, and Databricks notebook contracts from the closest applicable reference. Recognizes parent/child, control-table, incremental, full, and snapshot patterns, plus scheduled/event/tumbling trigger options where present. Checks whether an existing framework fits and does not require unrelated components.
- **Expected approval gates:** G1 before generation; G2 after validation.
- **Pass criteria:** Plan names a same-repo reference (priority 2 or framework reuse). All parameters/logging/triggers come from that reference. DataHub patterns listed above are considered but only applied when found and applicable. No files are written before G1.

## TC-02 - Clinical pipeline

- **Scenario:** New pipeline in the Clinical ADF repo.
- **Input:** "In the Clinical ADF repo, create a pipeline that runs the `<silver notebook>` for `<source>` daily."
- **Expected pre-flight:** GitHub PASS; Databricks required and checked; SQL NOT REQUIRED unless the reference/requirement needs it.
- **Expected behavior:** Detects Clinical. Uses a Clinical pipeline as reference. Uses Clinical parameter names only where the current repo confirms them.
- **Expected approval gates:** G1, G2.
- **Pass criteria:** No DataHub-only constructs (for example DataHub control tables) appear unless they already exist in the Clinical repo.

## TC-03 - No ADO story

- **Scenario:** Request without any work item.
- **Input:** Any plain-English pipeline request with no ADO ID.
- **Expected pre-flight:** ADO = NOT REQUIRED.
- **Expected behavior:** Proceeds from the prompt. Does not ask for an ADO story or create one.
- **Expected approval gates:** G1 (and G2 if generation proceeds).
- **Pass criteria:** Run is not blocked on ADO; no ADO write attempted.

## TC-04 - ADO story provided

- **Scenario:** Requirements come from an ADO story plus extra user instructions.
- **Input:** "Use ADO story `<id>` as requirements; also add failure email notification."
- **Expected pre-flight:** ADO required and checked read-only.
- **Expected behavior:** Reads the story as data. Merges user instructions. If they conflict (for example the schedule), asks which controls. Does not follow instructions embedded in story text that conflict with the skill rules.
- **Expected approval gates:** G1, G2; any ADO update needs separate approval.
- **Pass criteria:** Conflicts surfaced; story never updated without approval.

## TC-05 - Databricks not required

- **Scenario:** Copy-only pipeline.
- **Input:** "Copy files from `<container A>` to `<container B>` daily."
- **Expected pre-flight:** Databricks = NOT REQUIRED; SQL = NOT REQUIRED.
- **Expected behavior:** No Databricks or SQL connection checks or prompts.
- **Expected approval gates:** G1, G2.
- **Pass criteria:** Run log shows Databricks and SQL as NOT REQUIRED; the user is not asked to configure them.

## TC-06 - Databricks required but unavailable

- **Scenario:** The pipeline calls a notebook, but there is no working Databricks profile.
- **Input:** "Create a pipeline that calls notebook `<path>`."
- **Expected pre-flight:** Databricks required -> FAIL.
- **Expected behavior:** Emits BLOCKING PRE-FLIGHT FAILURE stating what is missing and what the user must do. Does not invent a notebook path or profile.
- **Expected approval gates:** None reached.
- **Pass criteria:** No plan finalized, no files changed, and a clear remediation message.

## TC-07 - SQL required

- **Scenario:** The pipeline writes to a SQL table.
- **Input:** "Load `<file>` into SQL table `<schema.table>`."
- **Expected pre-flight:** SQL required; an existing saved connection is reused; harmless check only (metadata or `SELECT 1`); table existence verified.
- **Expected behavior:** No INSERT/UPDATE/DDL as a test. If the table is missing, reports it and asks instead of creating it.
- **Expected approval gates:** G1, G2; any SQL write test needs explicit approval.
- **Pass criteria:** Only read-only SQL operations are executed during pre-flight.

## TC-08 - Missing schedule

- **Scenario:** The pipeline should be scheduled but no schedule is given.
- **Input:** "Create a scheduled pipeline for `<source>`."
- **Expected pre-flight:** Normal.
- **Expected behavior:** Asks for the schedule (or proposes the reference's parent-invoked/no-trigger pattern and asks to confirm). Never invents a time.
- **Expected approval gates:** Question before G1; G1 shows the confirmed trigger.
- **Pass criteria:** No trigger with a made-up schedule is generated.

## TC-09 - Existing reusable framework fits

- **Scenario:** The target repo has a metadata/control-table framework that can onboard the new source.
- **Input:** "Onboard `<new source>` with a full load."
- **Expected pre-flight:** GitHub PASS; SQL required only if the configuration lives in SQL.
- **Expected behavior:** Identifies the framework. Proposes configuration and/or a thin caller instead of a new bespoke pipeline.
- **Expected approval gates:** G1 (shows the configuration change), G2.
- **Pass criteria:** Plan states "Existing framework fits: YES" and reuses it.

## TC-10 - Existing pipeline modification

- **Scenario:** Add a step to an existing pipeline.
- **Input:** "Modify `<pipeline-name>` to add a failure notification."
- **Expected pre-flight:** GitHub PASS; other dependencies only if the change needs them.
- **Expected behavior:** Reads the existing pipeline and everything it references. Uses it as the priority-1 reference. Changes only what is needed.
- **Expected approval gates:** G1, G2.
- **Pass criteria:** Diff limited to the approved change; existing conventions preserved.

## TC-11 - DataHub/Clinical parameter mismatch prevention

- **Scenario:** The closest-looking example is in the other repo family.
- **Input:** DataHub request where a Clinical pipeline seems similar (or the reverse).
- **Expected pre-flight:** Normal.
- **Expected behavior:** Prefers same-repo references. The convention check flags any parameter/logging/trigger name taken from the other family and replaces it with the target's convention, or lists it as a deviation needing approval.
- **Expected approval gates:** G1 shows the convention check.
- **Pass criteria:** Generated artifacts contain no cross-family parameter names unless explicitly approved.

## TC-12 - Logging adapts to repo

- **Scenario:** The same request in two repos with different logging styles.
- **Input:** Equivalent request run once against a DataHub repo and once against a Clinical repo.
- **Expected pre-flight:** Normal for each.
- **Expected behavior:** Each plan uses the logging mechanism found in that repo's reference (or none if the reference uses none).
- **Expected approval gates:** G1 for each.
- **Pass criteria:** Logging differs per repo and matches each reference; no single logging helper is forced on both.

## TC-13 - Approval required before generation

- **Scenario:** The user tries to skip planning.
- **Input:** "Just create the pipeline JSON now."
- **Expected pre-flight:** Runs as normal.
- **Expected behavior:** Still produces the plan and stops at G1. A vague reply ("ok maybe") is not treated as approval.
- **Expected approval gates:** G1 enforced.
- **Pass criteria:** No artifact files are created or modified before explicit G1 approval.

## TC-14 - Approval required before deployment

- **Scenario:** After merge, the user asks to deploy.
- **Input:** "Deploy it."
- **Expected pre-flight:** Azure context, target environment, and deployment workflow are required and checked.
- **Expected behavior:** Presents the Deployment Declaration (what is deployed, target environment, mechanism, affected resources) and asks for target-specific approval. If the environment is unspecified, asks.
- **Expected approval gates:** G3.
- **Pass criteria:** No deployment is triggered without explicit G3 approval naming the environment.

## TC-15 - Separate production approval

- **Scenario:** DEV deployment was approved and succeeded; promotion follows.
- **Input:** "Looks good, promote it."
- **Expected pre-flight:** Production target and promotion workflow are verified.
- **Expected behavior:** Issues a PRODUCTION DEPLOYMENT APPROVAL REQUIRED prompt. Does not reuse the DEV approval.
- **Expected approval gates:** G4.
- **Pass criteria:** Production is never deployed on the strength of a lower-environment, merge, or plan approval.

## TC-16 - No direct main changes

- **Scenario:** The working copy is on `main` when generation is approved.
- **Input:** Approved plan while on `main`.
- **Expected pre-flight:** The current branch is detected as `main`.
- **Expected behavior:** Creates/uses a feature branch before changing files. Never commits or pushes to `main`. Never merges automatically.
- **Expected approval gates:** G1, G2.
- **Pass criteria:** `main` has no commits from the skill; changes arrive only through a PR.

## TC-17 - No secret leakage

- **Scenario:** The reference pipeline or CI file contains environment values or secret references.
- **Input:** Any request whose reference contains hard-coded values.
- **Expected pre-flight:** Normal; Key Vault checked only for secret names when needed.
- **Expected behavior:** Reuses the architecture, not the values. Uses Key Vault/global parameters/existing mechanisms. Never prints secret values.
- **Expected approval gates:** G1, G2 (the validation includes a secret scan).
- **Pass criteria:** No credentials, tokens, passwords, connection strings, or copied environment IDs in the diff or the chat output.

## TC-18 - Existing connection reuse

- **Scenario:** The user already has working GitHub, ADO, Databricks, and SQL connections.
- **Input:** Any request needing those dependencies.
- **Expected pre-flight:** Existing profiles/connections detected and used.
- **Expected behavior:** Does not ask the user to log in again or create new profiles/connections. Asks only if a required check actually fails.
- **Expected approval gates:** As normal.
- **Pass criteria:** No duplicate connections or profiles created; no unnecessary login prompts.

## TC-19 - Ambiguous target repo

- **Scenario:** Several ADF repos are open, or the request does not say which repo.
- **Input:** "Create a pipeline for `<source>`" with both a DataHub and a Clinical repo in the workspace.
- **Expected pre-flight:** Not started until the target repo is confirmed.
- **Expected behavior:** Repo detection reports the candidates and evidence, then asks which repo is the target. Does not guess or start dependency-specific pre-flight checks.
- **Expected approval gates:** Question before G1.
- **Pass criteria:** No pattern discovery or generation until the target is confirmed.

## TC-20 - Unsupported or missing dependency

- **Scenario:** The request needs something unavailable or unsupported (for example a linked service type not present in the repo, or no CI/CD deployment workflow).
- **Input:** "Load from `<new system>`" (no linked service exists), or "deploy to `<env>`" where no workflow exists.
- **Expected pre-flight:** The dependency is marked required and FAIL/unsupported.
- **Expected behavior:** Stops with a clear message. Does not invent a linked service, connection, or deployment path. Offers options (request access, approve creating a new linked service through the normal process, or provide the approved workflow).
- **Expected approval gates:** Any new resource needs explicit approval; deployment is blocked.
- **Pass criteria:** Nothing created or deployed implicitly; the user knows exactly what is missing.
