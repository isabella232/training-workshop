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

EnableHighlight

$haveInfo = $false
Write-Host "Checking local data cache..."
if (Test-Path -Path $studentInfoFile) {
	Write-Host "Found student info file."
	$studentInfo = Get-Content -Path $studentInfoFile | ConvertFrom-Json
	$haveInfo = $true
}

if (!$haveInfo) {
	Write-Host "Checking Azure storage..."
	$storageContext = (Get-AzStorageAccount -ResourceGroupName $azResourceGroupName -Name $azStorageAccount).Context
	Get-AzStorageBlobContent `
		-Container $azStorageStudentContainer -Context $storageContext `
		-Blob "$studentSlug.json" -Destination $studentInfoFile
	if(Test-Path -Path $studentInfoFile){
		Write-Host "Found student info file."
		$haveInfo = $true
	}
}
if (!$haveInfo) {
	Write-Warning "No student info file found."
}

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
	$storageContext = (Get-AzStorageAccount -ResourceGroupName $azResourceGroupName -Name $azStorageAccount).Context
	Remove-AzStorageBlob -Blob "$studentSlug.json" -Container $azStorageStudentContainer -Context $storageContext -ErrorAction Continue
	if (Test-Path $dataFolder) {
		Remove-Item -Path "$dataFolder\$studentSlug*"
	}
	Remove-Item -Path "$studentSlug*"
	if ($forceCleanup) {
		Write-Warning "'Force cleanup flag set', some artifacts/resources might remain."
	}
} else {
	Write-Warning "One or more cleanup stages skipped, preserving student data file. Run without any 'skip's to complete cleanup."
}

Write-Host "Deprovisioning complete."

DisableHighlight