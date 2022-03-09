[CmdletBinding()]
param (
	[Parameter(Mandatory=$true)] [string] $studentSlug
)

. $PSScriptRoot\load-config.ps1 

."$PSScriptRoot\..\update-existing-git-branch.ps1" `
	-studentSlug $studentSlug
