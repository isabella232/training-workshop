[CmdletBinding()]
param (
#	[Parameter(Mandatory=$true)]
	[string] $studentName = "New Student",

	[string] $githubUrl,

	[securestring] $githubPAT,

	[string] $octopusUrl,
	[string] $octopusKey,
	[switch] $skipGit,
	[switch] $skipSpace,
	[switch] $skipAzure,
	[string] $azTenantId,
	[string] $azUser,
	[string] $azSecret
)

class StudentAppInfo {
	[string]$AppEnvironment
	[string]$AppURL
	[string]$AppSlug
}

if (Test-Path .) {
	Write-Host ">>> Pre cleaning work directory"
	Remove-Item * -Recurse -Force
}

$instructionsDocFile = ".\workshop-instructions.md"
$azResourceGroupName = "training-workshop"
$azWebAppServicePlan = "training-workshop-webapps"

$studentNamePrefix = $studentName.Replace(" ", "").Substring(0,[System.Math]::Min(9, $studentName.Length))
$studentId = [System.Guid]::NewGuid()
$studentSlug = $studentId.ToString().Substring(0, 8)
$studentSlug = "$studentNamePrefix-$studentSlug"
$studentBranch = "student/$studentSlug"
$studentSpaceId = "fake-$studentSlug"

Write-Host "Provisioning student"
Write-Host " - $studentName"
Write-Host " - (slug: $studentSlug)"
Write-Host "Working against:"
Write-Host " - GitHub Repository: $githubUrl"
Write-Host " -  Octopus Instance: $octopusUrl"

if (-not $skipSpace) {
	$header = @{ "X-Octopus-ApiKey" = $octopusKey }

	$spaceName = $studentSlug
	$description = "Space for workshop student $studentName."
	$managersTeams = @("teams-everyone") # an array of team Ids to add to Space Managers
	#$managerTeamMembers = @() # an array of user Ids to add to Space Managers

	$body = @{
		Name = $spaceName
		Description = $description
		SpaceManagersTeams = $managersTeams
	#    SpaceManagersTeamMembers = $managerTeamMembers
		IsDefault = $false
		TaskQueueStopped = $false
	} | ConvertTo-Json

	$response = try {
		Write-Host "Creating space '$spaceName'"
		(Invoke-WebRequest $octopusURL/api/spaces -Headers $header -Method Post -Body $body -ErrorVariable octoError)
	} catch [System.Net.WebException] {
		$_.Exception.Response
	}

	if ($octoError) {
		Write-Host "An error was encountered trying to create the space: $($octoError.Message)"
		exit
	}

	$space = $response.Content | ConvertFrom-Json

	#Write-Host $space
	$studentSpaceId = $space.Id
} else {
	Write-Warning "Space creation skipped."
}


$appEnvs = @("dev") #, "test", "prod"

$studentAppInfos = @()
foreach ($appEnv in $appEnvs) {
	$appInfo = [StudentAppInfo]::new()
	$appInfo.AppEnvironment = $appEnv
	$appInfo.AppSlug = "$studentSlug-$appEnv"
	$studentAppInfos += $appInfo
}

if (!$skipAzure) {

	$azSecureSecret = ConvertTo-SecureString -String $azSecret -AsPlainText -Force
	$azCredential = New-Object -TypeName "System.Management.Automation.PSCredential" -ArgumentList $azUser, $azSecureSecret
	Connect-AzAccount -ServicePrincipal -Credential $azCredential -Tenant $azTenantId
	foreach ($studentApp in $studentAppInfos) {
		$azureApp = New-AzWebApp `
		-ResourceGroupName $azResourceGroupName `
		-AppServicePlan $azWebAppServicePlan
		-Name $studentApp.AppSlug `
		-Location "West US 2" `
#		-WhatIf
		$studentApp.AppURL = $azureApp.DefaultHostName
	}

} else {
	Write-Warning "Azure resource creation skipped."
}

if (!$skipGit) {
	# clone repo, branch for the student, commit and push
	& git clone $githubUrl .
	& git checkout main
	& git checkout -B $studentBranch

	$instructionsDocText = Get-Content $instructionsDocFile
	$instructionsDocText = $instructionsDocText.Replace("[student-slug]", $studentSlug).Replace("[space-id]", $studentSpaceId)

	foreach ($studentAppInfo in $studentAppInfos) {
		$token = "[student-app-hostname-$($studentAppInfo.AppEnvironment)]"
		$instructionsDocText = $instructionsDocText.Replace($token, $studentAppInfo.AppURL)
	}

	Out-File -Force -FilePath $instructionsDocFile -InputObject $instructionsDocText
	#Get-Content $instructionsDocFile

	& git add $instructionsDocFile
	& git commit -m "Create branch for $studentName"
	& git push origin $studentBranch
} else {
	Write-Warning "Git branch creation skipped."
}

# Remove-Item * -Recurse -Force

Write-Host "################################################################################"
Write-Host "## Student provisioning completed"
Write-Host "## =============================="
Write-Host "## Student name: $studentName"
Write-Host "## GitHub branch: https://github.com/OctopusDeploy/training-workshop/tree/$studentBranch"
Write-Host "## Octopus space: https://octopus-training.octopus.app/app#/$studentSpaceId"
Write-Host "## Workshop instructions URL: https://github.com/OctopusDeploy/training-workshop/blob/$studentBranch/workshop-instructions.md"
Write-Host "## Student website URLs:"
foreach ($studentAppInfo in $studentAppInfos) {
	Write-Host "##  - $($studentAppInfo.AppEnvironment): $($studentAppInfo.AppURL)"
}
Write-Host "################################################################################"
