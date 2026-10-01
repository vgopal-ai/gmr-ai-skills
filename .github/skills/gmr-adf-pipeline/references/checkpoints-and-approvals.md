# Checkpoints and Approval Language

Use this reference to keep executions predictable and reviewable.

## Checkpoint status values

Use concise statuses:

- `PASS`
- `FAIL — BLOCKING`
- `NOT REQUIRED`
- `READY FOR REVIEW`
- `WAITING FOR APPROVAL`
- `APPROVED`
- `NOT AUTHORIZED`
- `DEPLOYED — VERIFIED`
- `DEPLOYED — VERIFICATION FAILED`

## Gate summary

| Gate | When | Authorizes | Does NOT authorize |
|---|---|---|---|
| 1 - Plan approval | Before any artifact is generated | Local source-file changes on a feature branch | Push, PR, merge, deploy |
| 2 - Code/PR review | After generation + validation | Push + PR (if approved); merge only with explicit merge approval | Deploy |
| 3 - Deployment approval | Before any deployment | Deployment of one commit to one named non-production environment | Production |
| 4 - Production approval | Before production promotion | Production deployment of one named commit | Anything else |

## Gate 1 - Plan approval prompt

```text
GATE 1 - PLAN APPROVAL REQUIRED

Detected repo:        <repo> (<DataHub | Clinical | Other>)
Closest reference(s): <pipeline(s)> (priority <1-5>)
Architecture:         <summary>
Parameters:           <names from reference>
Logging:              <style from reference>
Trigger:              <type/schedule or none>
Files to create:      <list>
Files to change:      <list>
I will not deploy anything at this stage.

Approve this plan and authorize local source-file changes?
```

## Gate 2 - Code/PR review prompt

```text
GATE 2 - CODE / PR REVIEW

Branch:        <feature branch>
Files changed: <list>
Validation:    <summary>
Diff:          <git diff --stat>
PR:            <link or 'not created'>

Authorize push of this branch and creation/update of the PR?
(Merging is a separate explicit decision.)
```

## Gate 3 - Deployment declaration prompt

```text
DEPLOYMENT DECLARATION

Commit: <sha>
PR: <number/link>
Target environment: <environment>
ADF factory: <factory>
Resource group: <resource group>
Subscription: <subscription or not provided>
Deployment mechanism: <approved workflow>
Affected resources: <pipelines/triggers/datasets/linked services/other>
Expected runtime changes: <summary>
Validation evidence: <summary>
Rollback/recovery: <known approach or not confirmed>

This action will deploy runtime changes to <environment>.
Approve deployment to <environment>?
```

## Gate 4 - Production approval

Production must use an unmistakable prompt:

```text
PRODUCTION DEPLOYMENT APPROVAL REQUIRED

The following commit is ready for PRODUCTION promotion:
<sha>

Production target:
<factory / resource group / subscription>

Lower-environment evidence:
<summary>

Approve deployment to PRODUCTION?
```

Do not reuse a prior DEV/TEST/UAT approval.

## Missing-input behavior

Ask only questions whose answers cannot safely be derived from authorized resources and that materially affect implementation. Good examples:

- Which target environment is intended?
- Which of these two existing linked services should be used?
- The story says daily but the prompt says hourly; which schedule controls?
- Is a new linked service authorized, or must we reuse an existing one?

Do not ask the user for a repository folder name if it can be discovered safely from the target repo.
