[CmdletBinding()]
param (
	[Parameter(Mandatory=$true)] [string] $studentSlug
)

.$PSScriptRoot\load-config.ps1

."$PSScriptRoot\..\delete-student-webapps.ps1" `
	-azTenantId $azTenantId -azUser $azUser -azSecret $azSecret `
	-azResourceGroupName $azResourceGroupName `
	-studentSlug $studentSlug `
