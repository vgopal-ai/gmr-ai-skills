# Repository Detection and Pattern Discovery

This reference supports Checkpoints 2 and 3 of `SKILL.md`. It explains how to identify the target ADF repository and how to learn its conventions from existing pipelines instead of assuming them.

## 1. Detect the target repository

Collect evidence, then classify:

| Evidence | Where to look |
|---|---|
| Repo name / remote URL | `git remote -v`, workspace folder name |
| ADF resource layout | `pipeline/`, `trigger/`, `dataset/`, `linkedService/`, `factory/`, `integrationRuntime/` |
| Factory name | JSON under `factory/` |
| Orchestration framework | control/metadata tables referenced by Lookup activities, generic parent pipelines, ExecutePipeline chains |
| Logging approach | dedicated logging pipelines, stored-procedure activities, notebook-side logging helpers |
| CI/CD | `.github/workflows/`, `build/`, `release/`, Azure Pipelines YAML |
| Documentation | README, docs folder |

Classification result:

```text
TARGET REPO
Name:            <repo>
Family:          DataHub | Clinical | Other: <name>
Evidence:        <bullets>
Confidence:      HIGH | MEDIUM | LOW
```

If confidence is not HIGH, or more than one candidate repo is in play, ask the user to confirm before continuing.

The family label only narrows *where to search for references*. It never replaces reading the actual pipelines.

## 2. Reference priority

| Priority | Source | Use when |
|---:|---|---|
| 1 | Existing pipeline being modified | Always authoritative for modification requests |
| 2 | Same target repo, same integration shape | Default for new pipelines |
| 3 | Same domain/family (other DataHub or other Clinical repos) | Target repo has no close match |
| 4 | Other GMR ADF repos | No family match |
| 5 | Generic ADF best practice | No GMR reference fits; state this explicitly in the plan |

A convention must come from the highest-priority source that defines it.

## 3. Choosing the closest pipeline within a priority level

Rank candidates by:

1. same source/target integration type;
2. same orchestration shape (copy-only, Lookup -> ForEach, parent/child, control-table driven, ADF -> Databricks, API);
3. same load type (incremental, full, snapshot, append variants);
4. same trigger model;
5. same logging/failure pattern;
6. most recent / currently maintained, when history makes that clear.

## 4. Discovery checklist

Record each item from the chosen reference, with the file it came from:

```text
PATTERN DISCOVERY
Reference pipeline(s):       <path> (priority <n>)
Existing framework fits?:    YES (<name>) | NO (<reason>)
Orchestration shape:         <...>
Load pattern:                <incremental | full | snapshot | ...>
Pipeline parameters:         <exact names and casing>
Child/notebook parameters:   <exact names and casing>
Logging style:               <activity/pipeline/proc/notebook helper/none>
Failure handling:            <...>
Notification:                <...>
Trigger pattern:             <schedule | tumbling | event | parent-invoked | none>
Linked services:             <names>
Datasets:                    <names>
Databricks usage:            <none | linked service + parameter contract>
Configuration mechanism:     <global params | Key Vault | control table | params>
Values NOT to copy:          <hard-coded IDs, URLs, environment constants>
```

## 5. Family-specific notes

### DataHub-style repos

Look for these patterns in the **target DataHub repo**, and reuse only when present and applicable to the request:

- control-table / metadata-driven orchestration (for example, a Lookup over a configuration table feeding ForEach or child pipelines);
- parent/child pipelines through ExecutePipeline and reusable orchestration frameworks;
- load types such as incremental (including watermark-based), full, and snapshot, typically selected by configuration;
- configuration via pipeline/factory parameters, configuration tables, and Key Vault references;
- ADF LiteLog / operational logging activities or pipelines, distinguished from notebook-side logging;
- Databricks notebook activities, linked services, and parameter contracts when used by the reference;
- scheduled, storage/event, and tumbling-window triggers when present in the target repo;
- shared failure-handling and notification patterns.

These are discovery targets, not a checklist of components every pipeline must use. If a new source can be onboarded by adding configuration to an existing framework, prefer that over a new bespoke pipeline, and show the configuration change in the plan. Never reuse DataHub names or conventions in Clinical unless the Clinical target repo independently confirms the same convention.

### Clinical-style repos

See `observed-gmr-patterns.md` for patterns seen in a Clinical ADF snapshot. Confirm each against the current repo before using it.

### Other repos

Apply sections 2-4 as written. Do not import DataHub or Clinical conventions unless the repo already uses them.

## 6. Mismatch prevention

Before Gate 1, compare each proposed parameter, logging call, and trigger to the reference:

```text
CONVENTION CHECK
Item            Proposed         Reference          Source repo    OK?
Parameter       <name>           <name>             <repo>         YES/NO
Logging         <style>          <style>            <repo>         YES/NO
Trigger         <type>           <type>             <repo>         YES/NO
```

Any `NO` must be corrected to the target convention or listed in the plan as an explicit deviation for the human to approve.
