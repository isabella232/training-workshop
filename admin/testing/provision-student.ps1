[CmdletBinding()]
param (
	[string] $studentName, # = "Test Student",
	[string] $studentEmail = $null, # = "peter.lanoie@octopus.com",
	[switch] $skipOctopus,
	[switch] $skipAzure,
	[switch] $skipGit,
	[string] $relativeDepth = "..\.."
)

. $PSScriptRoot\load-config.ps1

# This script is for testing provisioning a student

."$PSScriptRoot\..\provision-student.ps1" `
	-studentName $studentName -studentEmail $studentEmail `
	-githubUrl $githubUrl -githubPAT $githubPAT `
	-octopusUrl $octopusURL -octopusKey $octopusKey `
	-azTenantId $azTenantId -azUser $azUser -azSecret $azSecret -azSubscriptionId $azSubscriptionId `
	-azLocation $azLocation -azResourceGroupName $azResourceGroupName -azWebAppServicePlan $azWebAppServicePlan `
	-slackUrl $slackUrl `
	-relativeDepth:$relativeDepth `
	-skipOctopus:$skipOctopus `
	-skipGit:$skipGit `
	-skipAzure:$skipAzure `
	
	# -skipAzure `
	# -skipOctopus `
	# -skipGit `
	
