# Manual Test Plan

Run applicable scenarios in a permitted sandbox. Do not use production data or perform writes without explicit approval. Record each result as PASS, FAIL, or NOT RUN.
1. PLAN from ADO stays read-only.
2. IMPLEMENT from ADO stops for plan approval.
3. Natural-language requirement works without ADO.
4. RESUME discovers actual PR/branch state.
5. Missing required Databricks invokes setup only for Databricks.
6. Databricks not required does not block.
7. Missing required SQL blocks affected step and resolves setup.
8. Working SQL is reused.
9. ADF-only task routes only to ADF skill.
10. ADF+Databricks coordinates both.
11. Power BI out of scope is not invoked.
12. Exact pipeline modification uses exact pipeline as top reference.
13. Ambiguous target repo asks a concise question.
14. Missing critical requirement is not invented.
15. Missing domain skill is reported honestly.
16. No plan approval means no implementation mutation.
17. Validation failure is reported; readiness not claimed.
18. PR uses feature branch; no auto-merge.
19. Lower-env approval does not imply prod.
20. Production requires separate approval.
21. ADO absent still works.
22. ADO + explicit override calls out the override.
23. Existing CI/CD is preferred over direct deployment.
24. DB connectivity validation is read-only.
25. Secrets are never printed/stored.
26. Setup skill unavailable produces a blocker report.
27. Same-repo reference beats cross-repo references.
28. Clinical/DataHub conventions are not cross-forced.
29. No deployment requested means no deployment.
30. Handoff produces evidence of completed/remaining work.
31. Linked story, repository, local-file, notebook, job, and data-object artifacts are inventoried and inspected before a plan is finalized.
32. Stale local state does not override the current canonical remote/default branch; record the ref and artifact path inspected.
33. A relevant artifact that cannot be accessed is marked ACCESS BLOCKED, not NOT FOUND, and the plan calls out the limitation.
34. A provisional plan includes the searched-source boundary and asks whether more artifacts exist; newly supplied artifacts are inspected and the plan revised before approval.
35. User confirmation that the artifact inventory is complete is distinct from approval to implement.
