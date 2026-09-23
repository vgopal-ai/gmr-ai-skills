# Illustrative draft: Crosswalk load (DO NOT automatically create)

**Type:** User Story (confirm project process)
**Title:** Load crosswalk spreadsheet into validated test table
**Business objective:** Allow analysts to load an updated crosswalk without manual transformation steps.

**Description:** On demand, take the approved Excel crosswalk input, convert the source column `AM2K DIV` to a string with max length 10, rename the target field `Division`, and write into a test table named `Crosswalk_test`. This draft does not choose Databricks, ADF or SQL Server as the target until approved. It does not assume every spreadsheet version uses the same schema.

**Candidate acceptance criteria for confirmation:**
1. A representative approved spreadsheet loads into `Crosswalk_test` in the verified target environment.
2. `Division` contains the mapped input values, follows the approved 10-character rule, and conversion errors follow the agreed error policy.
3. Loaded row counts and selected values reconcile with a sanitized test fixture.
4. Ad hoc execution works without deploying a recurring schedule.

**Open questions:** Target environment/catalog/database, table create vs replace behavior, sheet/file variants, missing/long value policy, validation threshold, approved storage path and assignee.

**Note:** These candidate acceptance criteria are proposed draft material, not facts already established in ADO story 108147. Ask Randy to approve them.
