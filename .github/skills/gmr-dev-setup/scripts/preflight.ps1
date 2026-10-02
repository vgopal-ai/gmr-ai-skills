# Read-only helper for gmr-dev-setup.
# It intentionally does not install software or authenticate users.

$ErrorActionPreference = 'SilentlyContinue'

function Test-Command($Name) {
    return [bool](Get-Command $Name -ErrorAction SilentlyContinue)
}

$results = [ordered]@{}
$results['OS'] = [System.Environment]::OSVersion.VersionString
$results['VSCode'] = Test-Command 'code'
$results['Git'] = Test-Command 'git'
$results['GitHubCLI'] = Test-Command 'gh'
$results['AzureCLI'] = Test-Command 'az'
$results['DatabricksCLI'] = Test-Command 'databricks'
$results['DotNet'] = Test-Command 'dotnet'
$results['PowerShell'] = $true

if (Test-Command 'code') {
    $ext = & code --list-extensions 2>$null
    $results['MSSQLExtension'] = [bool]($ext -match '^ms-mssql\.mssql$')
    $results['DatabricksExtension'] = [bool]($ext -match 'databricks')
} else {
    $results['MSSQLExtension'] = $false
    $results['DatabricksExtension'] = $false
}

$results | ConvertTo-Json -Depth 3
