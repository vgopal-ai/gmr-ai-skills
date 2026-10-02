# Read-only local verification helper.
# Provider-specific MCP/auth verification should be performed by the agent using
# the currently configured tools and official provider commands.

$ErrorActionPreference = 'Continue'

Write-Host '=== GMR Dev Setup Local Verification ==='

$checks = @(
    @{ Name='VS Code'; Cmd='code'; Args='--version' },
    @{ Name='Git'; Cmd='git'; Args='--version' },
    @{ Name='GitHub CLI'; Cmd='gh'; Args='--version' },
    @{ Name='Azure CLI'; Cmd='az'; Args='version' },
    @{ Name='Databricks CLI'; Cmd='databricks'; Args='--version' },
    @{ Name='.NET'; Cmd='dotnet'; Args='--info' }
)

foreach ($check in $checks) {
    $cmd = Get-Command $check.Cmd -ErrorAction SilentlyContinue
    if ($cmd) {
        Write-Host ("{0}: PASS" -f $check.Name)
    } else {
        Write-Host ("{0}: NOT INSTALLED / NOT REQUIRED" -f $check.Name)
    }
}

Write-Host 'Provider authentication and MCP connectivity must be verified with read-only provider-specific checks.'
