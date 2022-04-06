[CmdletBinding()]
param (
	[object] $studentInfo
)

. "$PSScriptRoot\shared-config.ps1"

if (!(Test-Path -Path $dataFolder)) {
	New-Item -Path $dataFolder -ItemType Directory | Write-Host
}

$useAzureStorage = $true

$studentSlug = $studentInfo.StudentSlug

if (!$studentSlug) {
	Write-Error "Student slug is missing, aborting metadata save."
	exit -1
}

$studentInfoJson = $studentInfo | ConvertTo-Json

$studentInfoJson | Out-File "$dataFolder\$studentSlug.json"

if ($useAzureStorage) {
	Write-Host "Storing student info into blob storage: $azResourceGroupName/$azStorageAccount/$azStorageStudentContainer/$studentSlug.json"
	$storageContext = (Get-AzStorageAccount -ResourceGroupName $azResourceGroupName -Name $azStorageAccount).Context
	$newBlob = Set-AzStorageBlobContent `
		-Container $azStorageStudentContainer -Context $storageContext `
		-File "$dataFolder\$studentSlug.json" `
		-BlobType Block `
		-Blob "$studentSlug.json" `

	Write-Host "New blog created: $($newBlob.Name) ($($newBlob.Length))"
}
Write-Host "========================================"
Write-Host $studentInfoJson
Write-Host "========================================"
Write-Host "Provisioning complete. Deprovision with the following:"
Write-Host "     ..\repo\admin\testing\deprovision-student.ps1 -studentSlug $studentSlug"

#Write-Output $studentInfo