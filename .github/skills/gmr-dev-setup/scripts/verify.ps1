# Read-only local verification helper.
# Provider-specific MCP/auth verification should use existing tools/connections.

$ErrorActionPreference = 'Continue'

Write-Host '=== GMR Dev Setup Local Verification ==='

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
    'VS Code' = @("$env:LOCALAPPDATA\Programs\Microsoft VS Code\bin\code.cmd")
    'Git' = @("$env:LOCALAPPDATA\Programs\Git\cmd\git.exe", "$env:ProgramFiles\Git\cmd\git.exe")
    'GitHub CLI' = @("$env:LOCALAPPDATA\Microsoft\WinGet\Links\gh.exe", "$env:LOCALAPPDATA\Programs\GitHub CLI\gh.exe", "$env:USERPROFILE\scoop\shims\gh.exe")
    'Azure CLI' = @("$env:APPDATA\Python\Python*\Scripts\az.bat", "$env:LOCALAPPDATA\Programs\Python\Python*\Scripts\az.exe")
    'Databricks CLI' = @("$env:LOCALAPPDATA\Microsoft\WinGet\Links\databricks.exe", "$env:USERPROFILE\.databricks\bin\databricks.exe", "$env:USERPROFILE\scoop\shims\databricks.exe")
    '.NET' = @("$env:LOCALAPPDATA\Microsoft\dotnet\dotnet.exe")
}

$checks = @(
    @{ Name='VS Code'; Cmd='code' },
    @{ Name='Git'; Cmd='git' },
    @{ Name='GitHub CLI'; Cmd='gh' },
    @{ Name='Azure CLI'; Cmd='az' },
    @{ Name='Databricks CLI'; Cmd='databricks' },
    @{ Name='.NET'; Cmd='dotnet' }
)

foreach ($check in $checks) {
    $path = Resolve-ToolPath -Name $check.Cmd -Candidates $userPaths[$check.Name]
    if ($check.Name -eq 'GitHub CLI' -and -not $path) {
        $ghPackage = Get-ChildItem -Path "$env:LOCALAPPDATA\Microsoft\WinGet\Packages\GitHub.cli_*" -Directory -ErrorAction SilentlyContinue |
            ForEach-Object { Get-ChildItem -Path $_.FullName -Filter gh.exe -File -Recurse -ErrorAction SilentlyContinue } |
            Select-Object -First 1
        if ($ghPackage) { $path = $ghPackage.FullName }
    }
    if ($check.Name -eq 'Databricks CLI' -and -not $path) {
        $databricksPackage = Get-ChildItem -Path "$env:LOCALAPPDATA\Microsoft\WinGet\Packages\Databricks.DatabricksCLI_*" -Directory -ErrorAction SilentlyContinue |
            ForEach-Object { Get-ChildItem -Path $_.FullName -Filter databricks.exe -File -Recurse -ErrorAction SilentlyContinue } |
            Select-Object -First 1
        if ($databricksPackage) { $path = $databricksPackage.FullName }
    }
    if ($path) {
        Write-Host ("{0}: PASS ({1})" -f $check.Name, $path)
    } else {
        Write-Host ("{0}: MISSING" -f $check.Name)
    }
}

$powerBiPaths = @(
    "$env:ProgramFiles\Microsoft Power BI Desktop\bin\PBIDesktop.exe",
    "${env:ProgramFiles(x86)}\Microsoft Power BI Desktop\bin\PBIDesktop.exe",
    "$env:LOCALAPPDATA\Programs\Microsoft Power BI Desktop\bin\PBIDesktop.exe",
    "$env:LOCALAPPDATA\Microsoft\WindowsApps\PBIDesktop.exe"
)
$powerBiPath = Resolve-ToolPath -Name 'PBIDesktop' -Candidates $powerBiPaths
if (-not $powerBiPath) {
    $powerBiPackage = Get-AppxPackage -Name 'Microsoft.MicrosoftPowerBIDesktop' -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($powerBiPackage) { $powerBiPath = "AppX:$($powerBiPackage.PackageFullName)" }
}
if ($powerBiPath) {
    Write-Host ("Power BI Desktop: PASS ({0})" -f $powerBiPath)
} else {
    Write-Host 'Power BI Desktop: MISSING'
}

Write-Host 'Provider authentication and MCP connectivity must be verified with read-only provider-specific checks.'
