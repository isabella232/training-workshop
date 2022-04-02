[CmdletBinding()]
param (
	[object] $studentInfo,

	[string] $githubUrl,
	[securestring] $githubPAT,
	[string] $relativeDepth = "..\.."
)

. "$PSScriptRoot\shared-types.ps1"

if (EnsureInGitWorkspace) {
	Write-Host ">>> Pre cleaning workspace directory"
	Remove-Item -Path "$PSScriptRoot\$relativeDepth\workspace\*" -Recurse -Force
} else {
	exit
}

# clone repo, branch for the student
& git clone $githubUrl . | Write-Host
& git checkout main | Write-Host
& git checkout -B $studentInfo.GitBranchName | Write-Host

."$PSScriptRoot\update-git-branch.ps1" -studentInfo $studentInfo

Write-Output $studentInfo