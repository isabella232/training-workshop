[CmdletBinding()]
param (
	[switch]$Local
)

. "$PSScriptRoot\shared-config.ps1"

function Write-StudentEntry {
	param (
		[string]$slug
	)
	$slug = $slug.Replace(".json","")
	Write-Host "$slug | ..\repo\admin\testing\deprovision-student.ps1 -studentSlug $slug | ..\repo\admin\testing\update-existing-git-branch.ps1 -studentSlug $slug"
}

if ($Local) {
	Write-Host "Discovering student list from local files."
	Get-ChildItem "$dataFolder\*.json" | ForEach-Object { Write-StudentEntry -slug $_.Name }
} else {
	Write-Host "Discovering student list from Azure storage."
	$storageContext = (Get-AzStorageAccount -ResourceGroupName $azResourceGroupName -Name $azStorageAccount).Context
	Get-AzStorageBlob -Container $azStorageStudentContainer -Context $storageContext | ForEach-Object { Write-StudentEntry -slug $_.Name }
}





