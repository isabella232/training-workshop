class StudentInfo
{
	[string] $StudentSlug
	[string] $StudentName
	[string] $StudentID
	[string] $StudentEmail
	[string] $GitBranchName
	[string] $InstructionsUrl
	[string] $SpaceId
	[string] $SpaceUrl
	[string] $OctopusUserId
	[System.Collections.ArrayList]$AzureApps = @()
}

class StudentAppInfo {
	[string] $AppSlug
	[string] $AppEnvironment
	[string] $AppURL
	[string] $ResourceId
}

function EnsureInGitWorkspace(){
	if ((Get-Location).ToString().EndsWith("workspace")) {
		return $true
	}
	Write-Error "Git update requires running from the 'workspace' directory (outside of this repo's root; see admin/testing/readme.md)"
	return $false
}

function CleanGitWorkspace(){
	if (EnsureInGitWorkspace) {
		Write-Host ">>> Pre cleaning workspace directory"
		Remove-Item -Path "$PSScriptRoot\..\..\workspace\*" -Recurse -Force
	}
}