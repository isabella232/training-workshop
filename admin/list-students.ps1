[CmdletBinding()]
param (
	[switch] $Local,
	[switch] $ShortForm,
	[switch] $ForBlobInfo
)

. "$PSScriptRoot\shared-octo-utils.ps1"
. "$PSScriptRoot\shared-config.ps1"
. "$PSScriptRoot\shared-types.ps1"

$cmdBaseDir = "..\repo\admin";
if ((Get-Location).Path.Contains("admin")) {
	$cmdBaseDir = "."
}

EnableHighlight
if (!$Local) {
	$studentItems = UpdateLocalStudentData
}

$studentFiles = Get-ChildItem "$dataFolder\*.json"

foreach ($file in $studentFiles) {
	$slug = $file.Name.Replace(".json", "")

	if ($ShortForm) {
		Write-Host $slug
		continue
	}

	$studentInfo = Get-Content $file | ConvertFrom-Json
	$switches = ""
	if (!$studentInfo.AzureApps[0].ResourceId -or $studentInfo.AzureApps[0].ResourceId.Length -eq 0) {
		$switches = "-skipAzure -forceCleanup "
	}
	Write-Host "$cmdBaseDir\testing\deprovision-student.ps1 -studentSlug $slug $switches| $cmdBaseDir\testing\update-existing-git-branch.ps1 -studentSlug $slug | ($($file.Length))"

	$studentItem = $studentItems | Where-Object -Property Name -EQ $file.Name
	if (!$studentItem) {
		Write-Warning "Student info missing from blob storage for slug:  $slug"
	}
}
DisableHighlight
