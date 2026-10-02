# Capability Routing
| Capability | Preferred handler |
|---|---|
| ADF | `gmr-adf-pipeline` |
| Environment/tool setup | `gmr-dev-setup` |
| Databricks | `gmr-databricks` when available |
| SQL | `gmr-sql` when available |
| Power BI/Fabric | `gmr-powerbi` when available |
| ADO story authoring | `ado-story-creator` when requested |
| Handoff | `gmr-implementation-handoff` when available |

States: REQUIRED, OPTIONAL, NOT REQUIRED, BLOCKED.
Missing OPTIONAL capability must not block work.
Missing REQUIRED capability blocks the affected step.
