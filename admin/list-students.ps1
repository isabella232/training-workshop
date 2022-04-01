[CmdletBinding()]
param (
	[switch]$Local,
	[switch]$ShortForm
)

. "$PSScriptRoot\shared-octo-utils.ps1"
. "$PSScriptRoot\shared-config.ps1"

function Write-StudentEntry {
	param (
		[string]$slug
	)
	$slug = $slug.Replace(".json","")
	if ($ShortForm) {
		Write-Host $slug
	} else {
		Write-Host "$slug | ..\repo\admin\testing\deprovision-student.ps1 -studentSlug $slug | ..\repo\admin\testing\update-existing-git-branch.ps1 -studentSlug $slug"
	}
}

EnableHighlight
if ($Local) {
	Write-Host "Discovering student list from local files."
	$studentItems = Get-ChildItem "$dataFolder\*.json" # | ForEach-Object { Write-StudentEntry -slug $_.Name }
} else {
	Write-Host "Discovering student list from Azure storage."
	$storageContext = (Get-AzStorageAccount -ResourceGroupName $azResourceGroupName -Name $azStorageAccount).Context
	$studentItems = Get-AzStorageBlob -Container $azStorageStudentContainer -Context $storageContext # | ForEach-Object { Write-StudentEntry -slug $_.Name }
}
$studentItems | ForEach-Object { Write-StudentEntry -slug $_.Name }
DisableHighlight