[CmdletBinding()]
param (
	[string] $studentName = "Test Student",
	[string] $studentEmail = "peter.lanoie@octopus.com",
	[switch] $skipOctopus,
	[switch] $skipAzure,
	[switch] $skipGit
)

. $PSScriptRoot\load-config.ps1

# This script is for testing provisioning a student

if ($true) {
	Write-Host "################################################"
	Write-Host "## Generating random student identity"
	$randoId = [System.Guid]:: NewGuid()
	$studentName = "Student " + $randoId.ToString().SubString(24)
	$studentEmail = "planoie.work+$($randoId.ToString().SubString(0, 8))@gmail.com"
	Write-Host "## Student Name: $studentName"
	Write-Host "## Student Email: $studentEmail"
	Write-Host "################################################"
}

."$PSScriptRoot\..\provision-student.ps1" `
	-githubUrl $githubUrl -githubPAT $githubPAT `
	-octopusUrl $octopusURL -octopusKey $octopusKey `
	-azTenantId $azTenantId -azUser $azUser -azSecret $azSecret -azSubscriptionId $azSubscriptionId `
	-azLocation $azLocation -azResourceGroupName $azResourceGroupName -azWebAppServicePlan $azWebAppServicePlan `
	-studentName $studentName -studentEmail $studentEmail `
	-skipOctopus `
	-skipGit `

	#-skipAzure:$skipAzure `
	# -skipOctopus:$skipOctopus `
	# -skipGit:$skipGit `
