[CmdletBinding()]
param (
	[object] $studentInfo

)

. "$PSScriptRoot\shared-config.ps1"

if (!(Test-Path -Path $dataFolder)) {
	New-Item -Path $dataFolder -ItemType Directory
}

$useAzureStorage = $true

$studentSlug = $studentInfo.StudentSlug

if (!$studentSlug) {
	Write-Error "Student slug is missing, aborting metadata save."
	exit -1
}

$studentInfoJson = $studentInfo | ConvertTo-Json
Write-Host $studentInfoJson
$studentInfoJson | Out-File "$dataFolder\$studentSlug.json"

if ($useAzureStorage) {
	Write-Host "Storing student info into blob storage: $azResourceGroupName/$azStorageAccount/$azStorageStudentContainer/$studentSlug.json"
	$storageContext = (Get-AzStorageAccount -ResourceGroupName $azResourceGroupName -Name $azStorageAccount).Context
	Set-AzStorageBlobContent `
		-Container $azStorageStudentContainer -Context $storageContext `
		-File "$dataFolder\$studentSlug.json" `
		-BlobType Block `
		-Blob "$studentSlug.json" `
}
Write-Host "========================================"
Write-Host "Provisioning complete. Deprovision with the following:"
Write-Host "     ..\repo\admin\testing\deprovision-student.ps1 -studentSlug $studentSlug"
