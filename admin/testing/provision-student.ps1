[CmdletBinding()]
param (
	[string] $studentName = "Test Student",
	[string] $studentEmail = "peter.lanoie@octopus.com"
)

. $PSScriptRoot\load-config.ps1

# This script is for testing provisioning a student

$randoId = [System.Guid]:: NewGuid()
$randoStudent = $randoId.ToString().SubString(24)
$studentEmail = "planoie.work+$($randoId.ToString().SubString(0, 8))@gmail.com"

."$PSScriptRoot\..\provision-student.ps1" `
	-githubUrl $githubUrl -githubPAT $githubPAT `
	-octopusUrl $octopusURL -octopusKey $octopusKey `
	-azTenantId $azTenantId -azUser $azUser -azSecret $azSecret -azSubscriptionId $azSubscriptionId `
	-studentName $randoStudent -studentEmail $studentEmail `
	-skipAzure `
	-skipGit `
	
#	-skipOctopus `
	# -studentName $studentName -studentEmail $studentEmail