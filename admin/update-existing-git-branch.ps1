[CmdletBinding()]
param (
	[Parameter(Mandatory=$true)] [string] $studentSlug
)

. "$PSScriptRoot\shared-types.ps1"
. "$PSScriptRoot\shared-config.ps1"

$studentInfo = Get-Content "$PSScriptRoot\data\$studentSlug.json" | ConvertFrom-Json

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