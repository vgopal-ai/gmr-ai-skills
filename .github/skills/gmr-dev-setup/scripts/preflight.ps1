# Read-only local discovery helper for gmr-dev-setup.
# It never installs software, authenticates users, or changes configuration.

$ErrorActionPreference = 'SilentlyContinue'

function Resolve-ToolPath {
    param([string]$Name, [string[]]$Candidates = @())

    $command = Get-Command $Name -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($command) {
        if ($command.Path) { return $command.Path }
        if ($command.Source) { return $command.Source }
    }

    foreach ($candidate in $Candidates) {
        $match = Get-ChildItem -Path $candidate -File -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($match) { return $match.FullName }
    }

    return $null
}

$userPaths = @{
    VSCode = @("$env:LOCALAPPDATA\Programs\Microsoft VS Code\bin\code.cmd")
    Git = @("$env:LOCALAPPDATA\Programs\Git\cmd\git.exe", "$env:ProgramFiles\Git\cmd\git.exe")
    GitHubCLI = @("$env:LOCALAPPDATA\Microsoft\WinGet\Links\gh.exe", "$env:LOCALAPPDATA\Programs\GitHub CLI\gh.exe", "$env:USERPROFILE\scoop\shims\gh.exe")
    AzureCLI = @("$env:APPDATA\Python\Python*\Scripts\az.bat", "$env:LOCALAPPDATA\Programs\Python\Python*\Scripts\az.exe")
    DatabricksCLI = @("$env:LOCALAPPDATA\Microsoft\WinGet\Links\databricks.exe", "$env:USERPROFILE\.databricks\bin\databricks.exe", "$env:USERPROFILE\scoop\shims\databricks.exe")
    DotNet = @("$env:LOCALAPPDATA\Microsoft\dotnet\dotnet.exe")
}
$commandNames = @{
    VSCode = 'code'
    Git = 'git'
    GitHubCLI = 'gh'
    AzureCLI = 'az'
    DatabricksCLI = 'databricks'
    DotNet = 'dotnet'
}

$toolPaths = @{}
foreach ($tool in $userPaths.Keys) {
    $toolPaths[$tool] = Resolve-ToolPath -Name $commandNames[$tool] -Candidates $userPaths[$tool]
}

# WinGet package installs are user-scoped and may not add their executable to PATH.
if (-not $toolPaths.GitHubCLI) {
    $ghPackage = Get-ChildItem -Path "$env:LOCALAPPDATA\Microsoft\WinGet\Packages\GitHub.cli_*" -Directory -ErrorAction SilentlyContinue |
        ForEach-Object { Get-ChildItem -Path $_.FullName -Filter gh.exe -File -Recurse -ErrorAction SilentlyContinue } |
        Select-Object -First 1
    if ($ghPackage) { $toolPaths.GitHubCLI = $ghPackage.FullName }
}
if (-not $toolPaths.DatabricksCLI) {
    $databricksPackage = Get-ChildItem -Path "$env:LOCALAPPDATA\Microsoft\WinGet\Packages\Databricks.DatabricksCLI_*" -Directory -ErrorAction SilentlyContinue |
        ForEach-Object { Get-ChildItem -Path $_.FullName -Filter databricks.exe -File -Recurse -ErrorAction SilentlyContinue } |
        Select-Object -First 1
    if ($databricksPackage) { $toolPaths.DatabricksCLI = $databricksPackage.FullName }
}

$results = [ordered]@{}
$results['OS'] = [System.Environment]::OSVersion.VersionString
$results['VSCode'] = [bool]$toolPaths.VSCode
$results['VSCodePath'] = $toolPaths.VSCode
$results['Git'] = [bool]$toolPaths.Git
$results['GitPath'] = $toolPaths.Git
$results['GitHubCLI'] = [bool]$toolPaths.GitHubCLI
$results['GitHubCLIPath'] = $toolPaths.GitHubCLI
$results['AzureCLI'] = [bool]$toolPaths.AzureCLI
$results['AzureCLIPath'] = $toolPaths.AzureCLI
$results['DatabricksCLI'] = [bool]$toolPaths.DatabricksCLI
$results['DatabricksCLIPath'] = $toolPaths.DatabricksCLI
$results['DotNet'] = [bool]$toolPaths.DotNet
$results['DotNetPath'] = $toolPaths.DotNet
$results['PowerShell'] = $true

if ($toolPaths.VSCode) {
    $ext = & $toolPaths.VSCode --list-extensions 2>$null
    $results['MSSQLExtension'] = [bool]($ext -match '^ms-mssql\.mssql$')
    $results['DatabricksExtension'] = [bool]($ext -match 'databricks')
} else {
    $results['MSSQLExtension'] = $false
    $results['DatabricksExtension'] = $false
}

$powerBiPaths = @(
    "$env:ProgramFiles\Microsoft Power BI Desktop\bin\PBIDesktop.exe",
    "${env:ProgramFiles(x86)}\Microsoft Power BI Desktop\bin\PBIDesktop.exe",
    "$env:LOCALAPPDATA\Programs\Microsoft Power BI Desktop\bin\PBIDesktop.exe",
    "$env:LOCALAPPDATA\Microsoft\WindowsApps\PBIDesktop.exe"
)
$results['PowerBIDesktopPath'] = Resolve-ToolPath -Name 'PBIDesktop' -Candidates $powerBiPaths
$results['PowerBIDesktop'] = [bool]$results['PowerBIDesktopPath']
if (-not $results['PowerBIDesktop']) {
    $powerBiPackage = Get-AppxPackage -Name 'Microsoft.MicrosoftPowerBIDesktop' -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($powerBiPackage) {
        $results['PowerBIDesktop'] = $true
        $results['PowerBIDesktopPath'] = "AppX:$($powerBiPackage.PackageFullName)"
    }
}

$mcpConfig = Join-Path $env:APPDATA 'Code\User\mcp.json'
$results['MCPConfigPresent'] = Test-Path -LiteralPath $mcpConfig
if ($results['MCPConfigPresent']) {
    $config = Get-Content -Raw -LiteralPath $mcpConfig | ConvertFrom-Json
    $servers = if ($config.servers) { $config.servers } else { $config }
    $results['MCPServerNames'] = @($servers.PSObject.Properties.Name | Where-Object { $_ -ne 'servers' })
}

$skillRoot = Join-Path $env:USERPROFILE '.copilot\skills'
$results['InstalledGMRSkills'] = @(Get-ChildItem -Path $skillRoot -Directory -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Name)

$results | ConvertTo-Json -Depth 3
