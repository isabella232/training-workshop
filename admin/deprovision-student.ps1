[CmdletBinding()]
param (
#	[Parameter(Mandatory=$true)]
	[string] $studentSlug = $null,

	[string] $octopusUrl,
	[string] $octopusKey,
	[switch] $skipGit,
	[switch] $skipOctopus,
	[switch] $skipAzure,
	# [string] $azTenantId,
	# [string] $azUser,
	# [string] $azSecret,
	[switch] $forceCleanup
)

. "$PSScriptRoot\shared-octo-utils.ps1"
. "$PSScriptRoot\shared-types.ps1"
. "$PSScriptRoot\shared-config.ps1"

#$azResourceGroupName = "training-workshop"

$studentInfoFile = "$dataFolder\$studentSlug.json"
$studentInfo = [StudentInfo]::New()

Write-RunbookHeader

$haveInfo = $false
if (Test-Path -Path $studentInfoFile) {
	Write-Host "Found student info file."
	$studentInfo = Get-Content -Path $studentInfoFile | ConvertFrom-Json
	$haveInfo = $true
} else {
	Write-Warning "No student info file found."
}
# $odStateFile = "$dataFolder\$studentSlug-od.tfstate"
# if (Test-Path -Path $odStateFile) {
# 	Write-Host "Found student Octopus Deploy TF state file."
# 	Copy-Item -Path $odStateFile -Destination "$tfOctopusFolder\terraform.tfstate"

# 	try {
# 		$popLoc = Get-Location
# 		Set-Location $tfOctopusFolder
# 		& terraform plan -destroy `
# 			-var="serverURL=$octopusURL" -var="apiKey=$octopusKey" `
# 			-var="automation_userid=$automationUserId" `
# 			-var="azure_app_id=$azUser" `
# 			-var="azure_sp_secret=$azSecret" `
# 			-var="azure_subscription=$azSubscriptionId" `
# 			-var="azure_tenant_id=$azTenantId" `
# 			-var="variableSetName=$varSetName" -var="description=$varSetDesc" `
# 			-var="student_display_name=$studentDisplayName" -var="student_email=$studentEmail" `
# 			-var="student_username=$studentEmail" -var="student_password=$($studentInfo.StudentId)" `
# 			-var="space_name=$($studentInfo.StudentSlug)" -var="space_description=$description" `
# 			-var="slack_url=$slackUrl" `
# 	}
# 	finally {
# 		Set-Location $popLoc
# 	}
# } else {
# 	Write-Warning "No Octopus Deploy TF state file found."
# }

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
	if ($haveInfo -and $studentInfo.OctopusUserId) {
		Write-Host "Deleting Octopus user '$($studentInfo.OctopusUserId)'."
		."$PSScriptRoot\delete-user.ps1" -userId $studentInfo.OctopusUserId
	} else {
		Write-Warning "No student user ID found in info... skipping user delete."
	}
} else {
	Write-Warning "Octopus operations skipped."
}

if (!$skipAzure) {
	."$PSScriptRoot\delete-student-webapps.ps1" `
		-studentSlug $studentSlug `
		-azResourceGroupName $azResourceGroupName `
	# -azTenantId $azTenantId `
	# -azSecret $azSecret -azUser $azUser `
} else {
	Write-Warning "Azure resource teardown skipped."
}

if ((!$skipGit -and !$skipOctopus -and !$skipAzure) -or $forceCleanup) {
	Write-Host "Cleaning up student metadata"
#	$studentDataFile = "$dataFolder\$studentSlug.json"
	if (Test-Path $dataFolder) {
		Remove-Item -Path "$dataFolder\$studentSlug*"
	}
	if ($forceCleanup) {
		Write-Warning "'Force cleanup flag set', some artifacts/resources might remain."
	}
	$storageContext = (Get-AzStorageAccount -ResourceGroupName $azResourceGroupName -Name $azStorageAccount).Context

#	Get-AzStorageBlob -Blob "$studentSlug.json" -Container $azStorageStudentContainer -Context $storageContext -ErrorAction SilentlyContinue
	Remove-AzStorageBlob -Blob "$studentSlug.json" -Container $azStorageStudentContainer -Context $storageContext -ErrorAction Continue
} else {
	Write-Warning "One or more cleanup stages skipped, preserving student data file. Run without any 'skip's to complete cleanup."
}

Write-Host "Deprovisioning complete."

Write-RunbookFooter