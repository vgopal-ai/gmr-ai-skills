# Approval Gates
## A — Plan approval
Required before implementation mutations.
Prompt: `Approve this implementation plan?`

## B — PR/code review
Show files, tests, validation, diff, unresolved issues. Never auto-merge.

## C — Deployment
State source, target, artifacts, mechanism, effect.
Prompt: `Approve deployment to <environment>?`

## D — Production
Always separate.
Prompt: `Approve promotion/deployment to Production?`
