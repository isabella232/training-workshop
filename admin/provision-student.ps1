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
	[string] $azLocation,
	[string] $azResourceGroupName,
	[string] $azWebAppServicePlan,

	[string] $slackUrl,
	
	[switch] $skipGit,
	[switch] $skipOctopus,
	[switch] $skipAzure,
	[switch] $skipUser
)

. "$PSScriptRoot\shared-types.ps1"
. "$PSScriptRoot\shared-config.ps1"

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

$studentInfo = [StudentInfo]::new()

$studentInfo.StudentName = $studentName
$studentInfo.StudentEmail = $studentEmail
$studentInfo.StudentId = [System.Guid]::NewGuid()
$studentSuffix = $studentInfo.StudentId.ToString().Substring(0, 8)

$studentNamePrefix = $studentName.Replace(" ", "").Substring(0, [System.Math]::Min(9, $studentName.Length))
$studentInfo.StudentSlug = $studentSlug = "$studentNamePrefix-$studentSuffix"
$studentDisplayName = "Student - $studentName"
$studentInfo.GitBranchName = $studentBranch = "student/$($studentInfo.StudentSlug)"
$studentInfo.InstructionsUrl = "https://github.com/OctopusDeploy/training-workshop/blob/$studentBranch/instructions/README.md"
$studentSpaceId = "[unknown]"

Write-Host "Provisioning student"
Write-Host " - Name: $studentName ($studentEmail)"
Write-Host " - Slug: $($studentInfo.StudentSlug)"
Write-Host "Working against:"
Write-Host " - GitHub Repository: $githubUrl"
Write-Host " -  Octopus Instance: $octopusUrl"

if (-not $skipOctopus) {
	$description = "Space for workshop student $studentName."
	# $managersTeams = @("Teams-1") # an array of team Ids to add to Space Managers
	# Write-Host "User ID: $userId"
	# if ($userId) {
	# 	Write-Host "Adding user as space manager"
	# 	$managerTeamMembers = @($userId, $automationUserId) # an array of user Ids to add to Space Managers
	# }

	$popLoc = Get-Location
	Write-Host $popLoc
	Write-Host "Setting location to $PSScriptRoot"
	Set-Location "$PSScriptRoot\tf-octopus"

	$varSetName = "Slack Variables"
	$varSetDesc = "Variables used for posting to Slack"

	# Remove any existing TF state (should only apply to testing)
	Remove-Item *.tfstate*
	if (-not(Test-Path -PathType Container .terraform)) {
		& terraform init
	}
	& terraform apply -auto-approve `
		-var="serverURL=$octopusURL" -var="apiKey=$octopusKey" `
		-var="azure_tenant_id=$azTenantId" `
		-var="azure_subscription=$azSubscriptionId" `
		-var="azure_app_id=$azUser" `
		-var="student_display_name=$studentDisplayName" -var="student_email=$studentEmail" `
		-var="student_username=$studentEmail" -var="student_password=$($studentInfo.StudentId)" `
		-var="space_name=$($studentInfo.StudentSlug)" -var="space_description=$description" `
		-var="automation_userid=$automationUserId" `
		-var="azure_sp_secret=$azSecret" `
		-var="variableSetName=$varSetName" -var="description=$varSetDesc" `
		-var="slack_url=$slackUrl" `
	
	$tfOutputs = terraform output -json | ConvertFrom-Json

	$studentInfo.SpaceId = $studentSpaceId = $tfOutputs.student_space.value.id
	$studentInfo.SpaceUrl = "$octopusURL/app#/$($studentInfo.SpaceId)"
	
	Write-Host "Setting location to $popLoc"
	Set-Location $popLoc
}
else {
	Write-Warning "Space creation skipped."
}

$appEnvs = @("dev", "test", "prod")

foreach ($appEnv in $appEnvs) {
	$appInfo = [StudentAppInfo]::new()
	$appInfo.AppEnvironment = $appEnv
	$appInfo.AppSlug = "$($studentInfo.StudentSlug)-$appEnv"
	$appInfo.AppURL = "{student-app-url-$appEnv}"
	$studentInfo.AzureApps += $appInfo
}

if (!$skipAzure) {
	$popLoc = Get-Location
	Set-Location "$PSScriptRoot\tf-azure"

	# Remove any existing TF state (should only apply to testing)
	Remove-Item *.tfstate*
	if (-not(Test-Path -PathType Container .terraform)) {
		& terraform init
	}
	#	& terraform plan `
	& terraform apply -auto-approve `
		-var="az_tenant_id=$azTenantId" -var="az_subscription=$azSubscriptionId" `
		-var="az_app_id=$azUser" -var="az_sp_secret=$azSecret" `
		-var="az_location=$azLocation" -var="az_resource_group_name=$azResourceGroupName" `
		-var="az_app_service_plan_name=$azWebAppServicePlan" `
		-var="student_slug=$($studentInfo.StudentSlug)" `

	$tfOutputs = terraform output -json | ConvertFrom-Json
	Set-Location $popLoc

	foreach ($studentAppInfo in $studentInfo.AzureApps) {
		$resourceData = $tfOutputs."web_site_$($studentAppInfo.AppEnvironment)".value
		$studentAppInfo.AppURL = "https://" + $resourceData.default_site_hostname
		$studentAppInfo.ResourceId = $resourceData.id
	}
} else {
	Write-Warning "Azure resource creation skipped."
}

if (!$skipGit) {
	# clone repo, branch for the student
	& git clone $githubUrl .
	& git checkout main
	& git checkout -B $studentBranch

	# update the instructions file with their specific info
	$instructionDocFiles = Get-ChildItem -Path $instructionDocsDir -Recurse -File -Filter *.md
	foreach ($instructionDocFile in $instructionDocFiles) {
		$fileText = Get-Content $instructionDocFile
		$fileText = $fileText.Replace("[student-slug]", $studentInfo.StudentSlug)
		$fileText = $fileText.Replace("[space-id]", $studentSpaceId)
		$fileText = $fileText.Replace("[student-name]", $studentName)

		foreach ($studentAppInfo in $studentInfo.AzureApps) {
			$token = "[student-app-url-$($studentAppInfo.AppEnvironment)]"
			$fileText = $fileText.Replace($token, $studentAppInfo.AppURL)
		}

		Out-File -Force -FilePath $instructionDocFile -InputObject $fileText
		#Get-Content $instructionsDocFile
		& git add $instructionDocFile
	}

	# update the GitHub actions file with their space
	$fileText = Get-Content $githubActionsFile
	$fileText = $fileText.Replace("Spaces-1", $studentSpaceId)
	Out-File -Force -FilePath $githubActionsFile -InputObject $fileText
	# make sure the CICD parts are commented
	."$PSScriptRoot\ensure-yaml-comments.ps1" -yamlFile $githubActionsFile -startBeacon "<cd-start>" -endBeacon "<cd-end>"
	& git add $githubActionsFile

	& git commit -m "Save student specific content for $studentName"
	& git push origin $studentBranch
}
else {
	Write-Warning "Git branch creation skipped."
}
$studentSummary = [System.Text.StringBuilder]::New()
$studentSummary.AppendLine("################################################################################") | Out-Null
$studentSummary.AppendLine("## Student provisioning completed") | Out-Null
$studentSummary.AppendLine("## ==============================") | Out-Null
$studentSummary.AppendLine("## Student name: $studentName") | Out-Null
$studentSummary.AppendLine("## Student ID: $($studentInfo.StudentId)") | Out-Null
$studentSummary.AppendLine("## Student email: $studentEmail") | Out-Null
$studentSummary.AppendLine("## GitHub branch: https://github.com/OctopusDeploy/training-workshop/tree/$studentBranch") | Out-Null
$studentSummary.AppendLine("## Octopus space: https://octopus-training.octopus.app/app#/$studentSpaceId") | Out-Null
$studentSummary.AppendLine("## Workshop instructions URL: https://github.com/OctopusDeploy/training-workshop/tree/$studentBranch/instructions") | Out-Null
$studentSummary.AppendLine("## Student website URLs:") | Out-Null
foreach ($studentAppInfo in $studentInfo.AzureApps) {
	$studentSummary.AppendLine("##  - $($studentAppInfo.AppEnvironment): $($studentAppInfo.AppURL)") | Out-Null
}
$studentSummary.AppendLine("## -----------------------------------------------------------------------------") | Out-Null
$studentSummary.AppendLine("## Cleanup") | Out-Null
$studentSummary.AppendLine("## -----------------------------------------------------------------------------") | Out-Null
$studentSummary.AppendLine("## Deprovision student: .\testing\deprovision-student.ps1 -studentSlug $($studentInfo.StudentSlug)") | Out-Null
$studentSummary.AppendLine("## Delete azure resources: .\testing\delete-student-webapps.ps1 -studentSlug $($studentInfo.StudentSlug)") | Out-Null
$studentSummary.AppendLine("################################################################################") | Out-Null
#Write-Host $studentSummary.ToString()

"$PSScriptRoot\data"
if (!(Test-Path -Path "$PSScriptRoot\data")) {
	New-Item -Path "$PSScriptRoot\data" -ItemType Directory
}
#Out-File -FilePath "$PSScriptRoot\data\$studentSlug.txt" -InputObject $studentSummary.ToString()

$studentInfoJson = $studentInfo | ConvertTo-Json
Write-Host $studentInfoJson
$studentInfoJson | Out-File "$PSScriptRoot\data\$studentSlug.json"