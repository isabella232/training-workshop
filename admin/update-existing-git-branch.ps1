[CmdletBinding()]
param (
	[Parameter(Mandatory=$true)] [string] $studentSlug,
	[string] $githubUrl,
	[string] $githubSecurity
)

. "$PSScriptRoot\shared-types.ps1"
. "$PSScriptRoot\shared-config.ps1"

$jsonFile = "$PSScriptRoot\data\$studentSlug.json"

Write-Host "Checking for student info file $jsonFile..."
if (!(Test-Path $jsonFile)) {
	Write-Error "Student info file $jsonFile not found. Aborting update."
	exit
}

$studentInfo = Get-Content $jsonFile | ConvertFrom-Json

CleanGitWorkspace

#get the student branch
& git clone "https://$githubSecurity$githubUrl" .
& git checkout $studentInfo.GitBranchName

# overwrite everything from `main`
& git checkout main -- *
& git status

# update files based on student data
."$PSScriptRoot\update-git-branch.ps1" `
	-studentInfo $studentInfo 