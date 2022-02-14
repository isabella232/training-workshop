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

# class StudentAppInfo {
# 	[string]$AppEnvironment
# 	[string]$AppURL
# 	[string]$AppSlug
# }

$azResourceGroupName = "training-workshop"
$azWebAppServicePlan = "training-workshop-webapps"

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

	$azSecureSecret = ConvertTo-SecureString -String $azSecret -AsPlainText -Force
	$azCredential = New-Object -TypeName "System.Management.Automation.PSCredential" -ArgumentList $azUser, $azSecureSecret

	(Connect-AzAccount -ServicePrincipal -Credential $azCredential -Tenant $azTenantId) | Out-Null

	Write-Host "Looking for existing web apps..."
	$studentWebApps = (Get-AzWebApp -ResourceGroupName $azResourceGroupName) | Where-Object { $_.Name.Contains($studentSlug) }

	Write-Host "Web apps matching student: $($studentWebApps.Length)"
	foreach ($webApp in $studentWebApps) {
		Write-Host "Removing student web app: $($webApp.Name)"
		Remove-AzWebApp $webApp -Force
	}

# 	foreach ($studentApp in $studentAppInfos) {
# 		Write-Host "Creating student application: $($studentApp.AppSlug) ..."
# 		$azureApp = New-AzWebApp `
# 		-ResourceGroupName $azResourceGroupName `
# 		-AppServicePlan $azWebAppServicePlan `
# 		-Name $studentApp.AppSlug `
# 		-Location "West US 2" `
# #		-WhatIf
# 		$studentApp.AppURL = "https://$($azureApp.DefaultHostName)"
# 	}

} else {
	Write-Warning "Azure resource teardown skipped."
}

## Deleting user
# api/users/Users-42 HTTP: DELETE
