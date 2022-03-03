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
	[System.Collections.ArrayList]$AzureApps = @()
}

class StudentAppInfo {
	[string] $AppSlug
	[string] $AppEnvironment
	[string] $AppURL
	[string] $ResourceId
}