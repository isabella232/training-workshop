[CmdletBinding()]
param (
	[Parameter(Mandatory=$true)] [string] $studentSlug
)

$baseScriptDir = $PSScriptRoot

. $baseScriptDir\config.local.ps1

if ($baseScriptDir -eq (Get-Location)) {
	Write-Error "DO NOT RUN THIS FROM IT'S HOME DIRECTORY" 
	exit
}

. "$baseScriptDir\ .. \deprovision-student.ps1" `
	-octopusUrl $octopusURL -octopusKey $octopusKey `
	-azTenantld $azTenantId -azUser $azUser -azSecret $azSecret `
	-studentSlug $studentSlug `

#	-skipAzure `
#	-skipGit  `
#	-skipSpace `

