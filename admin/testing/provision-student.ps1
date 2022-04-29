[CmdletBinding()]
param (
	[string] $studentName,
	[string] $studentEmail = $null,
	[switch] $skipOctopus,
	[switch] $skipAzure,
	[switch] $skipGit,
	[switch] $skipBlob,
	[switch] $skipEmail,
	[string] $relativeDepth = "..\.."
)

. $PSScriptRoot\load-config.ps1

# This script is for testing provisioning a student

."$PSScriptRoot\..\provision-student.ps1" `
	-studentName $studentName -studentEmail $studentEmail `
	-githubUrl $githubUrl -githubSecurity $githubSecurity `
	-octopusUrl $octopusURL -octopusKey $octopusKey `
	-azTenantId $azTenantId -azUser $azUser -azSecret $azSecret -azSubscriptionId $azSubscriptionId `
	-azLocation $azLocation -azResourceGroupName $azResourceGroupName -azWebAppServicePlan $azWebAppServicePlan `
	-fromAddress $gmailAccount -mailAccount $gmailAccount -mailSecret $gmailSecret -smtpServer $smtpServer `
	-slackUrl $slackUrl `
	-relativeDepth:$relativeDepth `
	-skipOctopus:$skipOctopus `
	-skipGit:$skipGit `
	-skipAzure:$skipAzure `
	-skipBlob:$skipBlob `
	-skipEmail:$skipEmail `

	
	# -skipAzure `
	# -skipOctopus `
	# -skipGit `
	
