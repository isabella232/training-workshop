[CmdletBinding()]
param (
	#	[Parameter(Mandatory=$true)]
	[string] $studentName,
	[string] $studentEmail,

	[string] $githubUrl,
	[securestring] $githubPAT,

	[string] $octopusUrl,
	[string] $octopusKey,

	[string] $azTenantId,
	[string] $azUser,
	[string] $azSecret,
	[string] $azSubscriptionId,

	[switch] $skipGit,
	[switch] $skipSpace,
	[switch] $skipAzure,
	[switch] $skipUser
)

class StudentAppInfo {
	[string]$AppEnvironment
	[string]$AppURL
	[string]$AppSlug
}

if (!$skipGit) {
	if ((Get-Location).ToString().EndsWith("workspace")) {
		Write-Host ">>> Pre cleaning workspace directory"
		Remove-Item -Path "$PSScriptRoot\..\..\workspace\*" -Recurse -Force
	}
 else {
		Write-Error "Complete provisioning requires running from the 'workspace' directory (outside of this repo's root; see admin/testing/readme.md)"
		exit
	}
}
else {
	Write-Warning "Skipping Git operation, skipping run location safety check and workspace dir cleanup."
}

$instructionsDocFile = ".\workshop-instructions.md"
$azResourceGroupName = "training-workshop"
$azWebAppServicePlan = "training-workshop-webapps"
$automationUserId = "Users-23"

$studentId = [System.Guid]::NewGuid()
$studentSuffix = $studentId.ToString().Substring(0, 8)

$studentNamePrefix = $studentName.Replace(" ", "").Substring(0, [System.Math]::Min(9, $studentName.Length))
$studentSlug = "$studentNamePrefix-$studentSuffix"
$studentBranch = "student/$studentSlug"
$studentSpaceId = "fake-$studentSlug"

$odHeaders = @{ "X-Octopus-ApiKey" = $octopusKey }

Write-Host "Provisioning student"
Write-Host " - $studentName ($studentEmail)"
Write-Host " - (slug: $studentSlug)"
Write-Host "Working against:"
Write-Host " - GitHub Repository: $githubUrl"
Write-Host " -  Octopus Instance: $octopusUrl"

if (!$skipUser) {
	Write-Host "Ensuring user exists in Octopus."

	$response = (Invoke-WebRequest "$octopusURL/api/users?skip=0&take=2147483647" -Headers $odHeaders -Method Get -ErrorVariable octoError)
	$allUsers = $response.Content | ConvertFrom-Json
	$existingUser = ($allUsers.Items | Where-Object { $_.EmailAddress -eq $studentEmail })
	#	Write-Output $existingUser
	if (!$existingUser) {
		Write-Host "Creating new user"

		$newUser = @{
			DisplayName = "Student - $studentName"
			EmailAddress = $studentEmail
			Username = $studentEmail
			IsService = $false
			IsActive = $true
			Password = $studentId
		} | ConvertTo-Json
		Write-Host $newUser

		$response = (Invoke-WebRequest "$octopusURL/api/users" -Headers $odHeaders -Method Post -Body $newUser -ErrorVariable octoError)
		$newUser = $response.Content | ConvertFrom-Json
		$userId = $newUser.Id
		Write-Host "New user created: '$userId'"
	}
 else {
		$userId = $existingUser.Id
		Write-Host "Found existing user: '$userId'"
	}
}
else {
	Write-Warning "User assurance skipped."
}

if (-not $skipSpace) {
	$spaceName = $studentSlug
	$description = "Space for workshop student $studentName."
	$managersTeams = @("Teams-1") # an array of team Ids to add to Space Managers
	Write-Host "User ID: $userId"
	if ($userId) {
		Write-Host "Adding user as space manager"
		$managerTeamMembers = @($userId, $automationUserId) # an array of user Ids to add to Space Managers
	}

	$body = @{
		Name = $spaceName
		Description = $description
		SpaceManagersTeams = $managersTeams
		SpaceManagersTeamMembers = $managerTeamMembers
		IsDefault = $false
		TaskQueueStopped = $false
	} | ConvertTo-Json

	$response = try {
		Write-Host "Creating space '$spaceName'"
		(Invoke-WebRequest $octopusURL/api/spaces -Headers $odHeaders -Method Post -Body $body -ErrorVariable octoError)
	}
	catch [System.Net.WebException] {
		$_.Exception.Response
	}

	if ($octoError) {
		Write-Host "An error was encountered trying to create the space: $($octoError.Message)"
		exit
	}

	$space = $response.Content | ConvertFrom-Json

	#Write-Host $space
	$studentSpaceId = $space.Id

	Write-Host "Add the workshop azure account to the space"
	."$PSScriptRoot\add-azure-account.ps1" `
		-octopusUrl $octopusURL -octopusKey $octopusKey `
		-azSubscription $azSubscriptionId `
		-azTenantId $azTenantId `
		-azClientId $azUser `
		-azSecret $azSecret `
		-spaceId $studentSpaceId `


	$popLoc = Get-Location
	Write-Host $popLoc
	Write-Host "Setting location to $PSScriptRoot"
	Set-Location $PSScriptRoot

	$varSetName = "Slack Variables"
	$varSetDesc = "Variables used for posting to Slack"

	& terraform init
	& terraform apply -auto-approve `
		-var="apiKey=$octopusKey" -var="serverURL=$octopusURL" `
		-var="space=$studentSpaceId" `
		-var="variableSetName=$varSetName" -var="description=$varSetDesc" `
		-var="slack_url=someurl" -var="slack_key=ABC123" `

	Write-Host "Setting location to $popLoc"
	Set-Location $popLoc
}
else {
	Write-Warning "Space creation skipped."
}

$appEnvs = @("dev", "test", "prod")

$studentAppInfos = @()
foreach ($appEnv in $appEnvs) {
	$appInfo = [StudentAppInfo]::new()
	$appInfo.AppEnvironment = $appEnv
	$appInfo.AppSlug = "$studentSlug-$appEnv"
	$appInfo.AppURL = "{student-app-url-$appEnv}"
	$studentAppInfos += $appInfo
}

if (!$skipAzure) {

	$azSecureSecret = ConvertTo-SecureString -String $azSecret -AsPlainText -Force
	$azCredential = New-Object -TypeName "System.Management.Automation.PSCredential" -ArgumentList $azUser, $azSecureSecret
	Connect-AzAccount -ServicePrincipal -Credential $azCredential -Tenant $azTenantId
	foreach ($studentApp in $studentAppInfos) {
		Write-Host "Creating student application: $($studentApp.AppSlug) ..."
		$azureApp = New-AzWebApp `
			-ResourceGroupName $azResourceGroupName `
			-AppServicePlan $azWebAppServicePlan `
			-Name $studentApp.AppSlug `
			-Location "West US 2" `
			#		-WhatIf
			$studentApp.AppURL = "https://$($azureApp.DefaultHostName)"
	}

}
else {
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
		$token = "[student-app-url-$($studentAppInfo.AppEnvironment)]"
		$instructionsDocText = $instructionsDocText.Replace($token, $studentAppInfo.AppURL)
	}

	Out-File -Force -FilePath $instructionsDocFile -InputObject $instructionsDocText
	#Get-Content $instructionsDocFile

	& git add $instructionsDocFile
	& git commit -m "Create branch for $studentName"
	& git push origin $studentBranch
}
else {
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
