[CmdletBinding()]
param (
	[Parameter(Mandatory=$true)] [string] $studentSlug,
	[switch] $skipAzure,
	[switch] $skipOctopus,
	[switch] $forceCleanup
)

.$PSScriptRoot\load-config.ps1

."$PSScriptRoot\..\deprovision-student.ps1" `
	-octopusUrl $octopusURL -octopusKey $octopusKey `
	-studentSlug $studentSlug `
	-skipAzure:$skipAzure `
	-skipOctopus:$skipOctopus `
	-forceCleanup:$forceCleanup `
	
#	-azTenantId $azTenantId -azUser $azUser -azSecret $azSecret `