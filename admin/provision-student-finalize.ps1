[CmdletBinding()]
param (
	[object] $studentInfo,
	[switch] $skipEmail,
	[string] $mailAccount,
	[string] $mailSecret,
	[switch] $skipBlob
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

if ($useAzureStorage -and !$skipBlob) {
	Write-Host "Storing student info into blob storage: $azResourceGroupName/$azStorageAccount/$azStorageStudentContainer/$studentSlug.json"
	$storageContext = (Get-AzStorageAccount -ResourceGroupName $azResourceGroupName -Name $azStorageAccount).Context
	$newBlob = Set-AzStorageBlobContent `
		-Container $azStorageStudentContainer -Context $storageContext `
		-File "$dataFolder\$studentSlug.json" `
		-BlobType Block `
		-Blob "$studentSlug.json" `

	Write-Host "New blob created: $($newBlob.Name) ($($newBlob.Length))"
} else {
	Write-Warning "Blob storage of student info was skipped. Local asset is the only record of student."
}

Write-Host "========================================"
Write-Host $studentInfoJson

if (!$skipEmail) {
	# $emailTemplateFile = "$PSScriptRoot/email-template.txt"

	# $emailBody = Get-Content $emailTemplateFile

	# $emailBody = $emailBody.Replace("[instruction-link]", $instructionsLink)
	# $emailBody = $emailBody.Replace("[classroom-link]", $classroomLink)
	# $emailBody = $emailBody.Replace("[classroom-passcode]", $classroomPassword)
	# Write-Host "========================================"
	# Write-Host "To: $($studentInfo.StudentEmail)"
	# Write-Host "Subject: Octopus hands-on workshop session info"
	# $emailBody | Write-Host
	Write-Host "Sending student session info email"
	. "$PSScriptRoot\email-student.ps1" `
		-to $studentInfo.StudentEmail `
		-mailAccount $mailAccount -mailSecret $mailSecret -smtpServer $smtpServer `
		-instructionsLink $studentInfo.InstructionsUrl
}

Write-Host "========================================"
Write-Host "Provisioning complete. Deprovision with the following:"
Write-Host "     ..\repo\admin\testing\deprovision-student.ps1 -studentSlug $studentSlug"
