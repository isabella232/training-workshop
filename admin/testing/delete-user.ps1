[CmdletBinding()]
param (
	[Parameter(Mandatory = $true)][string]$userId
)

. "$PSScriptRoot\load-config.ps1"

."$PSScriptRoot\..\delete-user.ps1" -userId $userId