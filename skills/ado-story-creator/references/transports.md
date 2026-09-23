# ADO MCP / Azure CLI transport reference

## Azure DevOps MCP

Use the **installed server's exposed tools and advertised schemas**; versions and tool names can differ. Prefer its existing authenticated work-item read/create/update operations. Work-item search and identity lookup may be separate tools. Ask for credentials through the organization's normal sign-in flow only; never paste PATs into prompts.

MCP tools are not guaranteed to be enabled by an extension just because board read works. Check for create/update tools and permission to write in the selected project. If MCP writes unavailable, use an explicitly approved CLI fallback, otherwise stop at draft.

## Azure CLI (az + azure-devops extension)

Prerequisites to check in local terminal (read-only):

```powershell
az version
az extension show --name azure-devops
az devops configure --list
az boards work-item --help
```

Do **not** install or authenticate on the user's behalf without consent. Azure DevOps extension commands use `--org` and `--project` or previously configured validated defaults. Creation supports `--title`, `--type`, `--description`, `--assigned-to`, `--area`, `--iteration` and `--fields`. Work-item processes have different required/custom fields: inspect the current project before writing. Treat description and acceptance criteria as HTML when required by the ADO process.

Illustrative PowerShell **shape only**, not something to run with placeholder values or raw untrusted text:

```powershell
# First verify the organization/project/type, sanitized HTML fields, and approved assignee.
# Supply arguments as discrete values; avoid building a shell command from untrusted story text.
$created = az boards work-item create --org $VerifiedOrg --project $VerifiedProject `
  --type $VerifiedType --title $ApprovedTitle --description $ApprovedDescriptionHtml `
  --assigned-to $ApprovedAssignee --fields "Microsoft.VSTS.Common.AcceptanceCriteria=$ApprovedCriteriaHtml" `
  --output json | ConvertFrom-Json
# Omit the AcceptanceCriteria field unless it is supported in this project's process.
# On success, use returned ID to read and verify.
az boards work-item show --org $VerifiedOrg --id $created.id --output json
```

The CLI sample deliberately uses variables, not hardcoded company names or credentials. Actual terminals differ (PowerShell vs Bash), and shell/argument-length limitations may require carefully prepared temporary text files or MCP. Don't print sensitive content into command logs. Azure CLI extension generally offers no guaranteed full transaction between initial create and follow-up updates; verify all fields and disclose partial success.

If CLI is available only to a local workstation, a remote cloud agent might not have access to it. Don't claim universal cross-client execution.

## Manual browser fallback

Return a copy-ready preview and tell the user how to paste it into an ADO new-work-item form. Do not claim the skill clicked the GUI unless an approved browser automation tool actually exists and executed.
