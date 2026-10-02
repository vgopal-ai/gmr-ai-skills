param([switch]$Json)
$scope = "Local CLI presence only; does not verify authentication, service access, permissions, MCP availability, or task-specific prerequisites."

function Get-CommandCheck {
	param(
		[string]$Name,
		[string]$CommandName,
		[string]$NotInstalledDetails
	)

	$command = Get-Command $CommandName -ErrorAction SilentlyContinue
	[pscustomobject]@{
		Name = $Name
		Status = if ($command) { "INSTALLED" } else { "NOT INSTALLED" }
		Details = if ($command) { $command.Source } else { $NotInstalledDetails }
	}
}

$checks = @(
	(Get-CommandCheck -Name "git" -CommandName "git" -NotInstalledDetails "Git executable was not found."),
	(Get-CommandCheck -Name "gh" -CommandName "gh" -NotInstalledDetails "GitHub MCP may be sufficient for agent operations."),
	(Get-CommandCheck -Name "databricks-cli" -CommandName "databricks" -NotInstalledDetails "The CLI is needed only for operations that require it."),
	(Get-CommandCheck -Name "azure-cli" -CommandName "az" -NotInstalledDetails "The CLI is needed only for operations that require it.")
)

if ($Json) {
	[pscustomobject]@{
		Scope = $scope
		Checks = $checks
	} | ConvertTo-Json -Depth 4
} else {
	Write-Output "Scope: $scope"
	$checks | Format-Table -AutoSize
}
