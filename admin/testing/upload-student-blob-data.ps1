
. "$PSScriptRoot/../shared-config.ps1"

$files = Get-ChildItem -Path "../data/*.json"

$storageContext = (Get-AzStorageAccount -ResourceGroupName $azResourceGroupName -Name $azStorageAccount).Context

foreach ($file in $files) {
#	$file
	#Get-AzStorageBlob -Container $azStorageStudentContainer -Context $storageContext
	Set-AzStorageBlobContent `
		-Container $azStorageStudentContainer -Context $storageContext `
		-File $file `
		-BlobType Block `
		-Blob $file.Name `
		-Force `
#		-WhatIf
}
