[CmdletBinding()]
param (
	[Parameter(Mandatory=$true)] [string] $studentSlug
)

. "$PSScriptRoot\shared-types.ps1"
. "$PSScriptRoot\shared-config.ps1"

$jsonFile = "$PSScriptRoot\data\$studentSlug.json"

if (!(Test-Path $jsonFile)) {
	Write-Error "Student info file $jsonFile not found. Aborting update."
	exit
}

$studentInfo = Get-Content $jsonFile | ConvertFrom-Json

CleanGitWorkspace

#get the student branch
& git clone $githubUrl .
& git checkout $studentInfo.GitBranchName

# overwrite everything from `main`
& git checkout main -- *
& git status

# update files based on student data
."$PSScriptRoot\update-git-branch.ps1" `
	-instructionDocsDir $instructionDocsDir `
	-studentInfo $studentInfo `
	-studentSpaceId $studentInfo.SpaceId `
	-studentName $studentInfo.StudentName `
	-githubActionsFile $githubActionsFile