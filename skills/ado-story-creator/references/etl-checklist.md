# ETL story-specific questions

Ask only for missing details that affect the requested story. Do not turn one simple story into a long intake form.

- **Source:** DB/table/query, file format, approved storage location, sheet/header variations, sample schema (non-sensitive).
- **Target:** database/catalog/schema/table, create vs append vs merge/upsert, schema and partitioning if known.
- **Transformations:** mapping and renames, data types/length, nulls, deduplication, rejection rules.
- **Execution:** ad hoc, time schedule (with timezone), or file arrival (location, polling/event pattern, timeout, duplicate arrivals); describe current behavior if migration.
- **Reliability:** idempotency, restart point, watermark, expected volume, alerting, retries, upstream/downstream dependencies.
- **Validation:** row-count and key reconciliation, schema check, field-level expected values, rejected records and error handling.
- **Platform:** record existing team's approved implementation pattern, not a speculative Databricks/ADF choice.
- **Security:** sanitized samples only; use approved secrets storage and least privilege; no credentials in stories.

For SSIS migration, request original `.dtsx`, non-secret connection metadata, parameters/variables, package configuration, representative input/output and current SQL Agent schedule as applicable. Avoid promising parity from package XML alone; inspect custom components, scripts and external dependencies.
