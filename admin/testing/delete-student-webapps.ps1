[CmdletBinding()]
param (
	[Parameter(Mandatory=$true)] [string] $studentSlug
)

.$PSScriptRoot\load-config.ps1

."$PSScriptRoot\..\delete-student-webapps.ps1" `
	-azResourceGroupName $azResourceGroupName `
	-studentSlug $studentSlug `

#-azTenantId $azTenantId -azUser $azUser -azSecret $azSecret `