[CmdletBinding()]
param (
#	[Parameter(Mandatory=$true)]
	[string] $studentSlug = $null,

	[string] $octopusUrl,
	[string] $octopusKey,
	[switch] $skipGit,
	[switch] $skipOctopus,
	[switch] $skipAzure,
	[string] $azTenantId,
	[string] $azUser,
	[string] $azSecret
)

. "$PSScriptRoot\shared-types.ps1"

$azResourceGroupName = "training-workshop"



Write-Host "Deprovisioning student"
Write-Host " - (slug: $studentSlug)"
Write-Host "Working against:"
Write-Host " -  Octopus Instance: $octopusUrl"

if (-not $skipOctopus) {
	$header = @{ "X-Octopus-ApiKey" = $octopusKey }

	$spaceName = $studentSlug

	Write-Host "Looking up space by name: $spaceName"

	$spaces = (Invoke-WebRequest $octopusURL/api/spaces?take=21000 -Headers $header -Method Get -ErrorVariable octoError).Content | ConvertFrom-Json
	$space = $spaces.Items | Where-Object Name -eq $spaceName

	if ($null -eq $space) {
		Write-Host "No space found with name '$spaceName', nothing to delete."
	} else {
		Write-Host "Space found with name '$spaceName'."

		$space.TaskQueueStopped = $true
		$body = $space | ConvertTo-Json

		Write-Host "Stopping space task queue"
		(Invoke-WebRequest $octopusURL/$($space.Links.Self) -Headers $header -Method PUT -Body $body -ErrorVariable octoError) | Out-Null

		Write-Host "Deleting space"
		(Invoke-WebRequest $octopusURL/$($space.Links.Self) -Headers $header -Method DELETE -ErrorVariable octoError) | Out-Null
	}
} else {
	Write-Warning "Space operation skipped."
}

if (!$skipAzure) {
	."$PSScriptRoot\delete-student-webapps.ps1" `
		-azTenantId $azTenantId -azResourceGroupName $azResourceGroupName `
		-azSecret $azSecret -azUser $azUser `
		-studentSlug $studentSlug `
} else {
	Write-Warning "Azure resource teardown skipped."
}

if (!$skipGit -and !$skipOctopus -and !$skipAzure) {
	$studentDataFile = "$PSScriptRoot\data\$studentSlug.json"
	if (Test-Path $studentDataFile) {
		Remove-Item -Path $studentDataFile
	}
} else {
	Write-Warning "One or more cleanup stages skipped, preserving student data file."
}
