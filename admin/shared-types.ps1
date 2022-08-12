class StudentInfo
{
	[string] $StudentSlug
	[string] $StudentName
	[string] $StudentID
	[string] $StudentEmail
	[string] $DisplayName
	[string] $GitBranchName
	[string] $InstructionsUrl
	[string] $SpaceId
	[string] $SpaceUrl
	[string] $OctopusUserId
	[bool] $SkipEmail
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

function CheckCommandResult(){ 
	if ($LASTEXITCODE -ne 0) {
		Write-Error "Previous command returned an error: $LASTEXITCODE"
		Exit-PSSession
	}
}

function UpdateLocalStudentData(){
	Write-Host "Getting student list from Azure storage."
	$storageContext = (Get-AzStorageAccount -ResourceGroupName $azResourceGroupName -Name $azStorageAccount).Context
	$blobItems = Get-AzStorageBlob -Container $azStorageStudentContainer -Context $storageContext
	Write-Host "Blob items found: $($blobItems.Length)"

	foreach ($item in $blobItems) {
		$filePath = "$dataFolder\$($item.Name)"
		if (!(Test-Path "$filePath")) {
			Write-Host "Getting blob file for '$($item.Name)'..."
			Get-AzStorageBlobContent -Container $azStorageStudentContainer -Context $storageContext -Blob $item.Name -Destination $filePath
		}
	}

	return $blobItems
}

function UseOctoClient(){
	if ((Get-Package -Name Octopus.Client).Count -gt 0) {
		Write-Host "Octopus.Client package installed"
	} else {
		Write-Host "Installing Octopus.Client package..."
		[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
		Install-Package Octopus.Client -source https://www.nuget.org/api/v2 -SkipDependencies
		$path = Join-Path (Get-Item ((Get-Package Octopus.Client).source)).Directory.FullName "lib/net452/Octopus.Client.dll"
		Add-Type -Path $path
	}
}

function EnsureConfigLoaded(){
	if (!$configLoaded) {
		. $PSScriptRoot\testing\load-config.ps1
	}
}

function GetStudentInfo(){
	[CmdletBinding()]
	param (
		[string]$studentSlug
	)
	$studentFilename =  "$dataFolder\$studentSlug.json"
	$studentInfo = Get-Content $studentFilename | ConvertFrom-Json
	return $studentInfo
}
