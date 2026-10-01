# Observed GMR Reference Patterns (Clinical snapshot)

This file documents patterns observed in the supplied `GMR.Clinical.ADF-main` repository and deployed Databricks notebook package. These are inputs to v1 of the skill, not declarations of a formal enterprise standard.

> **Scope:** These observations describe the **Clinical** ADF repository family only. They are priority-3 evidence at most (see `repo-detection-and-patterns.md`). Do **not** apply them to DataHub or other repositories, and always confirm them against the current target repo before use. Parameter names below are Clinical examples, not a GMR-wide convention.

## Repository structure

The supplied ADF repository contains resource folders including:

```text
pipeline/
trigger/
linkedService/
dataset/
integrationRuntime/
managedVirtualNetwork/
factory/
release/
build/
.github/workflows/
```

In the supplied snapshot there are 37 pipeline JSON files, 15 trigger JSON files, 22 dataset JSON files, and 22 linked-service JSON files.

## Common ADF activities observed

Across the supplied pipeline JSON files, recurring ADF activity types include:

- Copy
- DatabricksNotebook
- Lookup
- ForEach
- WebActivity
- IfCondition
- Script
- ExecutePipeline
- SetVariable

The skill should select activities based on the request and closest reference pattern rather than forcing a fixed activity chain.

## Frequently recurring pipeline parameters

The repository repeatedly uses names such as:

- `PipelineName`
- `RecipientList`
- `SourceName`
- `NotebookName`
- `Stage`
- `env`
- `Config_Catalog_Name`
- `Silver_Catalog_Name`
- `Gold_Catalog_Name`
- `StorageAccount`
- file path/name and trigger-window parameters in relevant pipelines

Where a new pipeline in the Clinical repo participates in the same contract, prefer compatible parameter names. Do not add unused parameters merely to imitate another pipeline, and do not carry these names into DataHub or other repos.

## Trigger patterns observed

The supplied trigger folder includes examples of:

- scheduled triggers;
- tumbling-window triggers;
- storage/event-style triggers;
- batch/backlog-style trigger patterns.

Treat the trigger as a separate source artifact when scheduling is required. A request for an ad-hoc pipeline may require no trigger.

## Databricks integration patterns observed

The supplied deployed notebooks include shared modules such as:

```text
datahub_processing/common/imports.py
datahub_processing/common/functions.py
```

The raw-to-silver notebooks explicitly load these shared helpers.

Observed widget/input names include examples such as:

- `Datasource`
- `Group` / `ProcessGroup`
- `ParentPipeline`
- `LoadType`
- `RawContainer`
- `RawPath`
- `RawFilename`
- `SilverSchema`
- `SilverTablename`
- `SilverKeys`
- `WatermarkColumn`
- `EmailNotification`
- `JobImportance`

The shared functions include load-oriented helpers for patterns such as incremental, snapshot, snapshot-append, incremental-append, and full processing.

The skill should reuse the established caller/callee contract where applicable. It must not modify Databricks implementation logic unless that work is explicitly in scope or delegated to a Databricks skill.

## Logging pattern observed

The supplied notebooks use a `sqlWriteDatahub_Litelog(...)` helper for begin/end/failure events. The raw-to-silver flows call this operational logging around processing.

For v1, this is evidence of an existing logging pattern that may be referenced when the requested pipeline/notebook participates in it. Do not hard-code LiteLog into unrelated pipelines without confirming it is applicable.

## CI/CD observations

The supplied GitHub Actions workflow includes steps to:

- check out source;
- install Node/npm dependencies;
- validate ADF resources;
- export ARM templates;
- publish build artifacts;
- authenticate to Azure for a release stage.

The supplied release portion also contains an explicitly marked incomplete section and numerous environment-specific values. Therefore:

- validation/build behavior is useful as a reference;
- the skill must discover the currently approved deployment workflow before deployment;
- the skill must not assume that every release fragment in the supplied snapshot is production-ready;
- environment-specific constants from CI configuration must not be copied into generated ADF source.

## Reference-selection heuristic

When choosing a baseline, prioritize in this order:

1. same source/target integration type;
2. same orchestration shape (copy-only, ADF→Databricks, parent/child, API, etc.);
3. same trigger model;
4. same logging/failure pattern;
5. same environment/configuration mechanism;
6. newest/current approved implementation where repository history makes that clear.

If the closest reference contains hard-coded or suspicious configuration, reuse the architecture—not the unsafe values.
