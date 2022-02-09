[CmdletBinding()]
param (
	[string] $studentName = "Test Student",
	[string] $studentEmail = "peter.lanoie@octopus.com"
)

# This script is for testing provisioning a student

if ($baseScriptDir -eq (Get-Location)) {
	Write-Error "DO NOT RUN THIS FROM IT'S HOME DIRECTORY" exit
}

$randoStudent = ([System.Guid]:: NewGuid()).ToString().SubString(24)
. "$baseScriptDir\ ..\provision-student.ps1" `
	-githubUrl $githubUrl -githubPAT $githubPAT `
	-octopusUrl $octopusURL -octopusKey $octopusKey `
	-azTenantld $azTenantId -azUser $azUser -azSecret $azSecret `
	-skipAzure `
	-skipGit `
	-studentName $randoStudent -studentEmail "$randoStudent@octopus.com" `
	# -studentName $studentName -studentEmail $studentEmail

