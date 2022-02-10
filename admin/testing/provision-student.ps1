[CmdletBinding()]
param (
	[string] $studentName = "Test Student",
	[string] $studentEmail = "peter.lanoie@octopus.com"
)

# This script is for testing provisioning a student

$randoStudent = ([System.Guid]:: NewGuid()).ToString().SubString(24)
. "$PSScriptRoot\..\provision-student.ps1" `
	-githubUrl $githubUrl -githubPAT $githubPAT `
	-octopusUrl $octopusURL -octopusKey $octopusKey `
	-azTenantId $azTenantId -azUser $azUser -azSecret $azSecret `
	-skipAzure `
	-skipGit `
	-studentName $randoStudent -studentEmail "$randoStudent@octopus.com" `
	# -studentName $studentName -studentEmail $studentEmail

