[CmdletBinding()]
param (
	[Parameter(Mandatory=$true)] [string] $studentSlug,
	[switch] $skipAzure
)

.$PSScriptRoot\load-config.ps1

."$PSScriptRoot\..\deprovision-student.ps1" `
	-octopusUrl $octopusURL -octopusKey $octopusKey `
	-azTenantId $azTenantId -azUser $azUser -azSecret $azSecret `
	-studentSlug $studentSlug `
	-skipAzure:$skipAzure `

#	-skipAzure `
#	-skipGit  `
#	-skipSpace `

